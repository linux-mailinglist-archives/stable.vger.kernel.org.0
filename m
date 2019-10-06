Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4D62CD408
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfJFRUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727348AbfJFRUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:20:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF4962080F;
        Sun,  6 Oct 2019 17:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382452;
        bh=Nh3wZE+l7LKMMSdsMyWo2BxUCv0fangCori9jJaVLbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XyZHjrRDm8WKCXb5f0Svb5p4u6w7ZWxXc7pQgWCLWgJ+f0vVj5D2c9mEB7Tvz0e4D
         cvsCBXogxTN512VQvXKGH7+g7ShLmn4JEdrh6AruRaX4Yul0qUABL1A+ZScj1gv805
         w2UotOf4nMJ1K0EohdobBFBvGlDEJdzui+XgprSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+0eefc1e06a77d327a056@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@google.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 4.4 35/36] smack: use GFP_NOFS while holding inode_smack::smk_lock
Date:   Sun,  6 Oct 2019 19:19:17 +0200
Message-Id: <20191006171100.911332251@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171038.266461022@linuxfoundation.org>
References: <20191006171038.266461022@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit e5bfad3d7acc5702f32aafeb388362994f4d7bd0 upstream.

inode_smack::smk_lock is taken during smack_d_instantiate(), which is
called during a filesystem transaction when creating a file on ext4.
Therefore to avoid a deadlock, all code that takes this lock must use
GFP_NOFS, to prevent memory reclaim from waiting for the filesystem
transaction to complete.

Reported-by: syzbot+0eefc1e06a77d327a056@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/smack/smack_access.c |    4 ++--
 security/smack/smack_lsm.c    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -474,7 +474,7 @@ char *smk_parse_smack(const char *string
 	if (i == 0 || i >= SMK_LONGLABEL)
 		return ERR_PTR(-EINVAL);
 
-	smack = kzalloc(i + 1, GFP_KERNEL);
+	smack = kzalloc(i + 1, GFP_NOFS);
 	if (smack == NULL)
 		return ERR_PTR(-ENOMEM);
 
@@ -545,7 +545,7 @@ struct smack_known *smk_import_entry(con
 	if (skp != NULL)
 		goto freeout;
 
-	skp = kzalloc(sizeof(*skp), GFP_KERNEL);
+	skp = kzalloc(sizeof(*skp), GFP_NOFS);
 	if (skp == NULL) {
 		skp = ERR_PTR(-ENOMEM);
 		goto freeout;
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -268,7 +268,7 @@ static struct smack_known *smk_fetch(con
 	if (ip->i_op->getxattr == NULL)
 		return ERR_PTR(-EOPNOTSUPP);
 
-	buffer = kzalloc(SMK_LONGLABEL, GFP_KERNEL);
+	buffer = kzalloc(SMK_LONGLABEL, GFP_NOFS);
 	if (buffer == NULL)
 		return ERR_PTR(-ENOMEM);
 


