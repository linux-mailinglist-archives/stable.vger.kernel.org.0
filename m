Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18611445F24
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 05:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhKEEbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 00:31:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230251AbhKEEbD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Nov 2021 00:31:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C083361262;
        Fri,  5 Nov 2021 04:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636086504;
        bh=KZOiKhQ37VKIy+d/W2ttFzNr4HxULf9Bi5Iicv0PObM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Dl6F+N3KlqI8X9b/nUwQLhPvPIM0orpJdUwqYg/glhXi8zgw9M0xc+qkRC2e8AhbS
         y4a4WHFfqJI0URbpxXCH6tExIOFis3Eld0O13L4X3fKW9oQ6ShdHBIHAlg9qQaEGJa
         7btYQhkExffycgG+kg1dXTSgBJc92ydUL7Q+Sw/95TffAKFqybW/3rYcdnKIVKPdXe
         eHSV+yPvd4m7D7o0Nn3fQLeJuzTmB4KBgzaQGN93B9YSdq47MtaNDSphim9gXDVcfA
         tb7vPR46cB2F9/2RWAmzPV6jD4xeiHKe+yOyUE+Jdov6wCTTooDuxreWEhkAJaXi09
         cC/4GfslMKotQ==
Message-ID: <1dd327ac-b4c0-6c03-7250-dd8a9be44657@kernel.org>
Date:   Fri, 5 Nov 2021 12:28:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v2] erofs: fix unsafe pagevec reuse of hooked pclusters
Content-Language: en-US
To:     Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
References: <20211103174953.3209-1-xiang@kernel.org>
 <20211103182006.4040-1-xiang@kernel.org>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <20211103182006.4040-1-xiang@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/11/4 2:20, Gao Xiang wrote:
> There are pclusters in runtime marked with Z_EROFS_PCLUSTER_TAIL
> before actual I/O submission. Thus, the decompression chain can be
> extended if the following pcluster chain hooks such tail pcluster.
> 
> As the related comment mentioned, if some page is made of a hooked
> pcluster and another followed pcluster, it can be reused for in-place
> I/O (since I/O should be submitted anyway):
>   _______________________________________________________________
> |  tail (partial) page |          head (partial) page           |
> |_____PRIMARY_HOOKED___|____________PRIMARY_FOLLOWED____________|
> 
> However, it's by no means safe to reuse as pagevec since if such
> PRIMARY_HOOKED pclusters finally move into bypass chain without I/O
> submission. It's somewhat hard to reproduce with LZ4 and I just found
> it (general protection fault) by ro_fsstressing a LZMA image for long
> time.
> 
> I'm going to actively clean up related code together with multi-page
> folio adaption in the next few months. Let's address it directly for
> easier backporting for now.
> 
> Call trace for reference:
>    z_erofs_decompress_pcluster+0x10a/0x8a0 [erofs]
>    z_erofs_decompress_queue.isra.36+0x3c/0x60 [erofs]
>    z_erofs_runqueue+0x5f3/0x840 [erofs]
>    z_erofs_readahead+0x1e8/0x320 [erofs]
>    read_pages+0x91/0x270
>    page_cache_ra_unbounded+0x18b/0x240
>    filemap_get_pages+0x10a/0x5f0
>    filemap_read+0xa9/0x330
>    new_sync_read+0x11b/0x1a0
>    vfs_read+0xf1/0x190
> 
> Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
> Cc: <stable@vger.kernel.org> # 4.19+
> Signed-off-by: Gao Xiang <xiang@kernel.org>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
