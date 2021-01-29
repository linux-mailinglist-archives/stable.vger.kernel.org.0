Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55490308F13
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 22:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbhA2VLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 16:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233399AbhA2VLi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 16:11:38 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EFBC061574;
        Fri, 29 Jan 2021 13:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=nKkcRmmPEgVIlUYC0hUi7DE2b8+YDtqtGJ0z4kX1lMw=; b=Sx8K+MCbPxbAsbIGnw0vwOauEv
        B2M4fFMnFPvEcE4Vco+HTMQzVfjGzSkxbZnKlSAbCoX+UqK+4wxIQ30ThfACaUtrQzEEpXbrD7u2H
        K4XA/pyLSpuZBaO8TocHWcq7prBgMItcJjpzA9I/y9zSG2s+8wzES+4QH6rfEAAnJakQ4oojFJ9cq
        RXtdQkSu4bdwI7DEMYF7flH8Age+k+kBzrWHsiP7FDTU3YMcIojispqSWo0Psvk63VW6VihX3WezO
        saLTQxwamd+oLLtPvx9tCv+rMOebQDH5oQhgHfRizB7a7FfIQkPRvcMfBlPbQVskuGtcuK+k4srxC
        zHVt4ePw==;
Received: from [2601:1c0:6280:3f0::7650]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l5b2d-0005VS-IH; Fri, 29 Jan 2021 21:10:55 +0000
Subject: Re: [PATCH] exfat: fix shift-out-of-bounds in exfat_fill_super()
To:     Namjae Jeon <namjae.jeon@samsung.com>,
        linux-fsdevel@vger.kernel.org
Cc:     willy@infradead.org, sj1557.seo@samsung.com, stable@vger.kernel.org
References: <CGME20210129072117epcas1p29cfb23f0ff88f659b404b1d54fb44ee8@epcas1p2.samsung.com>
 <20210129071222.7582-1-namjae.jeon@samsung.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <67a65e15-dd17-85fd-cf91-0b9ad5f43b49@infradead.org>
Date:   Fri, 29 Jan 2021 13:10:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210129071222.7582-1-namjae.jeon@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/28/21 11:12 PM, Namjae Jeon wrote:
> syzbot reported a warning which could cause shift-out-of-bounds issue.
> 
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x183/0x22e lib/dump_stack.c:120
>  ubsan_epilogue lib/ubsan.c:148 [inline]
>  __ubsan_handle_shift_out_of_bounds+0x432/0x4d0 lib/ubsan.c:395
>  exfat_read_boot_sector fs/exfat/super.c:471 [inline]
>  __exfat_fill_super fs/exfat/super.c:556 [inline]
>  exfat_fill_super+0x2acb/0x2d00 fs/exfat/super.c:624
>  get_tree_bdev+0x406/0x630 fs/super.c:1291
>  vfs_get_tree+0x86/0x270 fs/super.c:1496
>  do_new_mount fs/namespace.c:2881 [inline]
>  path_mount+0x1937/0x2c50 fs/namespace.c:3211
>  do_mount fs/namespace.c:3224 [inline]
>  __do_sys_mount fs/namespace.c:3432 [inline]
>  __se_sys_mount+0x2f9/0x3b0 fs/namespace.c:3409
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> exfat specification describe sect_per_clus_bits field of boot sector
> could be at most 16 and at least 0. And sect_size_bits can also
> affect this calculation, It also needs validation.
> This patch add validation for sect_per_clus_bits and sect_size_bits
> field of boot sector.
> 
> Fixes: 719c1e182916 ("exfat: add super block operations")
> Cc: stable@vger.kernel.org # v5.9+
> Reported-by: syzbot+da4fe66aaadd3c2e2d1c@syzkaller.appspotmail.com
> Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>

Tested-by: Randy Dunlap <rdunlap@infradead.org>

[  172.721719] exFAT-fs (loop0): bogus sector size bits : 0

[  172.721736] exFAT-fs (loop0): failed to read boot sector
[  172.721744] exFAT-fs (loop0): failed to recognize exfat type

Thanks.

> ---
>  fs/exfat/exfat_raw.h |  4 ++++
>  fs/exfat/super.c     | 31 ++++++++++++++++++++++++++-----
>  2 files changed, 30 insertions(+), 5 deletions(-)


-- 
~Randy

