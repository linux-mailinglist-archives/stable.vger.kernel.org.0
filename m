Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C162A1D46
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 11:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgKAKaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 05:30:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:49236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgKAKaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Nov 2020 05:30:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A957E20709;
        Sun,  1 Nov 2020 10:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604226621;
        bh=uBOxgKGox72Khbv7lHPCWHnvMnC3J+LhFgAQQopAVW0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PsZc0CNMRSOPIv5SATUZJDagBRiPVhMPpvYxGP99Rcv0eGc6EZl9qE7oqL/xu8MGk
         UUdAcmz7buYJ05NClfswKpy601VQ96XPxL+xhlBJSXCrwztcGRm1GpsWPekHzqqfvn
         FCtbvR0HETcrhosbUWm8Tglq1ys0oNS6Aoli8J+s=
Date:   Sun, 1 Nov 2020 11:31:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 4.4] f2fs crypto: avoid unneeded memory allocation in
 ->readdir
Message-ID: <20201101103104.GB2558892@kroah.com>
References: <20201031195809.377983-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031195809.377983-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 31, 2020 at 12:58:09PM -0700, Eric Biggers wrote:
> From: Chao Yu <yuchao0@huawei.com>
> 
> commit e06f86e61d7a67fe6e826010f57aa39c674f4b1b upstream.
> [This backport fixes a regression in 4.4-stable caused by commit
> 11a6e8f89521 ("f2fs: check memory boundary by insane namelen"), which
> depended on this missing commit.  This bad backport broke f2fs
> encryption because it moved the incrementing of 'bit_pos' to earlier in
> f2fs_fill_dentries() without accounting for it being used in the
> encrypted dir case.  This caused readdir() on encrypted directories to
> start failing.  Tested with 'kvm-xfstests -c f2fs -g encrypt'.]
> 
> When decrypting dirents in ->readdir, fscrypt_fname_disk_to_usr won't
> change content of original encrypted dirent, we don't need to allocate
> additional buffer for storing mirror of it, so get rid of it.
> 
> Signed-off-by: Chao Yu <yuchao0@huawei.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/f2fs/dir.c | 7 -------
>  1 file changed, 7 deletions(-)

Now queued up, thanks.

greg k-h
