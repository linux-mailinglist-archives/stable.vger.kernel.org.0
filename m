Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90264BE156
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347200AbiBUJEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:04:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347433AbiBUJBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:01:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F95286CB;
        Mon, 21 Feb 2022 00:56:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 150E9B80EB6;
        Mon, 21 Feb 2022 08:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192D5C340EB;
        Mon, 21 Feb 2022 08:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433777;
        bh=HCtdl9fNMs3hqVtvX/xSaIwtj1S6Z3+sdQrickaFRmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQeuXXD3kfXEHX6VK0O/SmepuJ/342m5CM5EEK3CIS2Hy3esZMnp3F6RCS0/YkDsh
         N913XETRTZZpSxVi5Bkb/lZdbt/A6SgttZ75wy1s7nPoMr0LU0gTHIZaf+cWNeeTXl
         myhGzByenaGJuMkogq3v+kSa6j3ubuu6RrL1VQ24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 4.19 38/58] NFS: LOOKUP_DIRECTORY is also ok with symlinks
Date:   Mon, 21 Feb 2022 09:49:31 +0100
Message-Id: <20220221084913.105252338@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
References: <20220221084911.895146879@linuxfoundation.org>
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

commit e0caaf75d443e02e55e146fd75fe2efc8aed5540 upstream.

Commit ac795161c936 (NFSv4: Handle case where the lookup of a directory
fails) [1], part of Linux since 5.17-rc2, introduced a regression, where
a symbolic link on an NFS mount to a directory on another NFS does not
resolve(?) the first time it is accessed:

Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Fixes: ac795161c936 ("NFSv4: Handle case where the lookup of a directory fails")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Tested-by: Donald Buczek <buczek@molgen.mpg.de>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/dir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1629,14 +1629,14 @@ no_open:
 	if (!res) {
 		inode = d_inode(dentry);
 		if ((lookup_flags & LOOKUP_DIRECTORY) && inode &&
-		    !S_ISDIR(inode->i_mode))
+		    !(S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode)))
 			res = ERR_PTR(-ENOTDIR);
 		else if (inode && S_ISREG(inode->i_mode))
 			res = ERR_PTR(-EOPENSTALE);
 	} else if (!IS_ERR(res)) {
 		inode = d_inode(res);
 		if ((lookup_flags & LOOKUP_DIRECTORY) && inode &&
-		    !S_ISDIR(inode->i_mode)) {
+		    !(S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))) {
 			dput(res);
 			res = ERR_PTR(-ENOTDIR);
 		} else if (inode && S_ISREG(inode->i_mode)) {


