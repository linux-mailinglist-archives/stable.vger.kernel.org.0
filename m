Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5919C3795F8
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 19:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbhEJRcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 13:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233161AbhEJRa5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 13:30:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B2161480;
        Mon, 10 May 2021 17:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620667792;
        bh=NoxUUko7kkDexDD5edlKRqf2fLj5/AWQ8YjAVuYS6OQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LukAma3aFFyGx8i4+loOHRxDbffMAvVyuiHZVZ2mJeqKoCuoTdbvYCCNzHPQ4gomh
         uMvEoOZajrYL+bXQEb915DiK4vFCezP2N8A5dE1tlOAafstcRrpcIKLyxS7YEJOj7t
         PJrizpIib9bImbBAtpMPUdXwUQhl5IqJYfFhe7uucW8ktZ6GTuToMjjr62Q3G1nXZ0
         45TzRlA3mq9if+mNcihgnozkIgnMRFrsN7+gru/u+eMfTCxRCHFUWFUWmgJYsAXDeq
         r/TEQu15K1/X4JBUTfWe2hgcpIZgDLaahl//3qqerIk1nEeoqdIs1DdKCwsEKcIswU
         wPWxW9Bp4KBgw==
Date:   Mon, 10 May 2021 10:29:35 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     heyunlei@hihonor.com, jaegeuk@kernel.org, stable@vger.kernel.org,
        yuchao0@huawei.com
Subject: Re: FAILED: patch "[PATCH] f2fs: fix error handling in
 f2fs_end_enable_verity()" failed to apply to 5.4-stable tree
Message-ID: <YJltfzQoLKumJvpa@gmail.com>
References: <1620554944177170@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1620554944177170@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 09, 2021 at 12:09:04PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> >From 3c0315424f5e3d2a4113c7272367bee1e8e6a174 Mon Sep 17 00:00:00 2001
> From: Eric Biggers <ebiggers@google.com>
> Date: Thu, 4 Mar 2021 21:43:10 -0800
> Subject: [PATCH] f2fs: fix error handling in f2fs_end_enable_verity()
> 
> f2fs didn't properly clean up if verity failed to be enabled on a file:
> 
> - It left verity metadata (pages past EOF) in the page cache, which
>   would be exposed to userspace if the file was later extended.
> 
> - It didn't truncate the verity metadata at all (either from cache or
>   from disk) if an error occurred while setting the verity bit.
> 
> Fix these bugs by adding a call to truncate_inode_pages() and ensuring
> that we truncate the verity metadata (both from cache and from disk) in
> all error paths.  Also rework the code to cleanly separate the success
> path from the error paths, which makes it much easier to understand.
> 
> Finally, log a message if f2fs_truncate() fails, since it might
> otherwise fail silently.
> 
> Reported-by: Yunlei He <heyunlei@hihonor.com>
> Fixes: 95ae251fe828 ("f2fs: add fs-verity support")
> Cc: <stable@vger.kernel.org> # v5.4+
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Reviewed-by: Chao Yu <yuchao0@huawei.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> 

This is a clean cherry-pick, and it compiles.  So I don't see what the problem
is.

- Eric
