Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B013447E14B
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 11:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243082AbhLWKUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 05:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239344AbhLWKUP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 05:20:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271ACC061401
        for <stable@vger.kernel.org>; Thu, 23 Dec 2021 02:20:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 930CCB81FC2
        for <stable@vger.kernel.org>; Thu, 23 Dec 2021 10:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4380C36AE5;
        Thu, 23 Dec 2021 10:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640254812;
        bh=3+IykB2Y2gqFYnf6XJKGS4EHPlXnnjVUfJGBfp8pSxk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iO8oI6hi3a+sOznvWg7xrSdTJil/pL/5zv7wgZrwhcEtD7NdtR2w6YqF7jeUP02rv
         157uJbTfiEvEhHJzcNoMP0iGZkmSkX+EI0CVjyT5ldBek3Ba7WYmiOZES5jaY1v//g
         38TysEz/bMemyvdY0H+Q1QHKd37retk2V+qeHMFc=
Date:   Thu, 23 Dec 2021 11:20:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v5.10] ceph: fix up non-directory creation in SGID
 directories
Message-ID: <YcRNV5z5bkSNu2kr@kroah.com>
References: <https://lore.kernel.org/stable/YcBgWdVOT6GtICE6@kroah.com>
 <20211223095733.587981-1-brauner@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211223095733.587981-1-brauner@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 23, 2021 at 10:57:33AM +0100, Christian Brauner wrote:
> From: Christian Brauner <christian.brauner@ubuntu.com>
> 
> Ceph always inherits the SGID bit if it is set on the parent inode,
> while the generic inode_init_owner does not do this in a few cases where
> it can create a possible security problem (cf. [1]).
> 
> Update ceph to strip the SGID bit just as inode_init_owner would.
> 
> This bug was detected by the mapped mount testsuite in [3]. The
> testsuite tests all core VFS functionality and semantics with and
> without mapped mounts. That is to say it functions as a generic VFS
> testsuite in addition to a mapped mount testsuite. While working on
> mapped mount support for ceph, SIGD inheritance was the only failing
> test for ceph after the port.
> 
> The same bug was detected by the mapped mount testsuite in XFS in
> January 2021 (cf. [2]).
> 
> [1]: commit 0fa3ecd87848 ("Fix up non-directory creation in SGID directories")
> [2]: commit 01ea173e103e ("xfs: fix up non-directory creation in SGID directories")
> [3]: https://git.kernel.org/fs/xfs/xfstests-dev.git
> 
> Cc: stable@vger.kernel.org (adapted to v5.10)
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  fs/ceph/file.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)

What is the git commit id in Linus's tree?
