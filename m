Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE144ABAA4
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383962AbiBGLYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377482AbiBGLPa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:15:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9325C03FEC4;
        Mon,  7 Feb 2022 03:15:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6AEA6142D;
        Mon,  7 Feb 2022 11:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DB5C340F6;
        Mon,  7 Feb 2022 11:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232506;
        bh=G2GXwaG7VfYaeJ0AwilszI2RAd+XAFkHHjVYCZ5A+JA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0a17t8Kfe379omtsiuXEtBc7YejPFr3uIEG9vlQGiESfHeAY+mMp7vWAJFajl2bv
         ByJRjL7ABqUOmyyI10fanmjIewP9PWVEbHhyYk0c0aCfsL+p/HOb+Q2U83qs0hUWJf
         rLit0v8QSZG3GMG6sbdcCQLB+CPYYbCTiAVyg13Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyu Tao <tao.lyu@epfl.ch>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 4.19 32/86] NFSv4: Handle case where the lookup of a directory fails
Date:   Mon,  7 Feb 2022 12:05:55 +0100
Message-Id: <20220207103758.589658540@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
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
@@ -1626,6 +1626,19 @@ out:
 
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


