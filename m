Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE854ABABC
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384040AbiBGLYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:24:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343686AbiBGLL1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:11:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480DDC043181;
        Mon,  7 Feb 2022 03:11:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9F0261380;
        Mon,  7 Feb 2022 11:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D58C004E1;
        Mon,  7 Feb 2022 11:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232286;
        bh=AZIGNPFfhItQhXw/IiZddg19DkJESQI6M1ZOK2QqI6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SkUGFBcF/Kw6+SMW8BK60qTWwvRvpNFOGpLS6BNyGDa8E3E/whCiEiL40EmL3pCRw
         OK6MBrxuyhLGtO8S/vZRECnNvCmnbG47iEEBT+secd2jKGOn9aemcLtGdOjgsIOEjv
         MnWnEhb3TF0k3qkX1kbqv59CUqvkev2Otx42zaw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyu Tao <tao.lyu@epfl.ch>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 4.14 29/69] NFSv4: Handle case where the lookup of a directory fails
Date:   Mon,  7 Feb 2022 12:05:51 +0100
Message-Id: <20220207103756.580477443@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit ac795161c93699d600db16c1a8cc23a65a1eceaf upstream.

If the application sets the O_DIRECTORY flag, and tries to open a
regular file, nfs_atomic_open() will punt to doing a regular lookup.
If the server then returns a regular file, we will happily return a
file descriptor with uninitialised open state.

The fix is to return the expected ENOTDIR error in these cases.

Reported-by: Lyu Tao <tao.lyu@epfl.ch>
Fixes: 0dd2b474d0b6 ("nfs: implement i_op->atomic_open()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/dir.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1607,6 +1607,19 @@ out:
 
 no_open:
 	res = nfs_lookup(dir, dentry, lookup_flags);
+	if (!res) {
+		inode = d_inode(dentry);
+		if ((lookup_flags & LOOKUP_DIRECTORY) && inode &&
+		    !S_ISDIR(inode->i_mode))
+			res = ERR_PTR(-ENOTDIR);
+	} else if (!IS_ERR(res)) {
+		inode = d_inode(res);
+		if ((lookup_flags & LOOKUP_DIRECTORY) && inode &&
+		    !S_ISDIR(inode->i_mode)) {
+			dput(res);
+			res = ERR_PTR(-ENOTDIR);
+		}
+	}
 	if (switched) {
 		d_lookup_done(dentry);
 		if (!res)


