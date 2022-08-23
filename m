Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C4D59D352
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241765AbiHWILt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242047AbiHWIKc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:10:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8CEF3B;
        Tue, 23 Aug 2022 01:07:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D62E610AA;
        Tue, 23 Aug 2022 08:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC2FC433D6;
        Tue, 23 Aug 2022 08:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242039;
        bh=t4F7UxwgqjJIxKuZKRMLCgcA54hql5brZfQwsEScR3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xq+APEnbMWFsk5wySC1a6MaH81N0DtDziN6aE6gSJHeFkjMxRMhPlz3/hEESJicdf
         9t4H/FLvgevq7XYGhap3yg2/DiXeBVWrJLDbcBqBt0QXrEHZpnDNSFtXukPnxlTVi3
         hDERDk3u3bTekL71Y0p7BPioNjB/5Bx2lzg/WYos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Alexander Grund <theflamefire89@gmail.com>
Subject: [PATCH 4.9 010/101] selinux: Minor cleanups
Date:   Tue, 23 Aug 2022 10:02:43 +0200
Message-Id: <20220823080034.977764462@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 420591128cb206201dc444c2d42fb6f299b2ecd0 upstream.

Fix the comment for function __inode_security_revalidate, which returns
an integer.

Use the LABEL_* constants consistently for isec->initialized.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Alexander Grund <theflamefire89@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c     |    3 ++-
 security/selinux/selinuxfs.c |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -237,6 +237,7 @@ static int inode_alloc_security(struct i
 	isec->sid = SECINITSID_UNLABELED;
 	isec->sclass = SECCLASS_FILE;
 	isec->task_sid = sid;
+	isec->initialized = LABEL_INVALID;
 	inode->i_security = isec;
 
 	return 0;
@@ -247,7 +248,7 @@ static int inode_doinit_with_dentry(stru
 /*
  * Try reloading inode security labels that have been marked as invalid.  The
  * @may_sleep parameter indicates when sleeping and thus reloading labels is
- * allowed; when set to false, returns ERR_PTR(-ECHILD) when the label is
+ * allowed; when set to false, returns -ECHILD when the label is
  * invalid.  The @opt_dentry parameter should be set to a dentry of the inode;
  * when no dentry is available, set it to NULL instead.
  */
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1301,7 +1301,7 @@ static int sel_make_bools(void)
 			goto out;
 
 		isec->sid = sid;
-		isec->initialized = 1;
+		isec->initialized = LABEL_INITIALIZED;
 		inode->i_fop = &sel_bool_ops;
 		inode->i_ino = i|SEL_BOOL_INO_OFFSET;
 		d_add(dentry, inode);
@@ -1835,7 +1835,7 @@ static int sel_fill_super(struct super_b
 	isec = (struct inode_security_struct *)inode->i_security;
 	isec->sid = SECINITSID_DEVNULL;
 	isec->sclass = SECCLASS_CHR_FILE;
-	isec->initialized = 1;
+	isec->initialized = LABEL_INITIALIZED;
 
 	init_special_inode(inode, S_IFCHR | S_IRUGO | S_IWUGO, MKDEV(MEM_MAJOR, 3));
 	d_add(dentry, inode);


