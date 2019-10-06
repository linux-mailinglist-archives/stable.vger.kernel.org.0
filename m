Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDDE0CD745
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbfJFRyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:54:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727224AbfJFRya (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:54:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7096D2245B;
        Sun,  6 Oct 2019 17:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383962;
        bh=axRY1t3IiJXvhDfhisGregAKW7gK5qc9mX5zwfxCozw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qm1xjHJ7AiuLqtyinaGCVNn9oct4SuGtaCFe+TQHc8Hzv2gpIuZ7zmPoKNDge7G7F
         ULGhakVnxLeLg/wDq9Mbh1z8pvDadJRJwi9YHDdVKberjsdeL64ZL+UIBJXWQdPjnK
         jq8/YBbN2EIlBC8IKmH4Y8Tcp95B6ZyotWmP/tW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+0eefc1e06a77d327a056@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@google.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 5.3 159/166] smack: use GFP_NOFS while holding inode_smack::smk_lock
Date:   Sun,  6 Oct 2019 19:22:05 +0200
Message-Id: <20191006171226.243917600@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
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
 security/smack/smack_access.c |    6 +++---
 security/smack/smack_lsm.c    |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -465,7 +465,7 @@ char *smk_parse_smack(const char *string
 	if (i == 0 || i >= SMK_LONGLABEL)
 		return ERR_PTR(-EINVAL);
 
-	smack = kzalloc(i + 1, GFP_KERNEL);
+	smack = kzalloc(i + 1, GFP_NOFS);
 	if (smack == NULL)
 		return ERR_PTR(-ENOMEM);
 
@@ -500,7 +500,7 @@ int smk_netlbl_mls(int level, char *cats
 			if ((m & *cp) == 0)
 				continue;
 			rc = netlbl_catmap_setbit(&sap->attr.mls.cat,
-						  cat, GFP_KERNEL);
+						  cat, GFP_NOFS);
 			if (rc < 0) {
 				netlbl_catmap_free(sap->attr.mls.cat);
 				return rc;
@@ -536,7 +536,7 @@ struct smack_known *smk_import_entry(con
 	if (skp != NULL)
 		goto freeout;
 
-	skp = kzalloc(sizeof(*skp), GFP_KERNEL);
+	skp = kzalloc(sizeof(*skp), GFP_NOFS);
 	if (skp == NULL) {
 		skp = ERR_PTR(-ENOMEM);
 		goto freeout;
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -288,7 +288,7 @@ static struct smack_known *smk_fetch(con
 	if (!(ip->i_opflags & IOP_XATTR))
 		return ERR_PTR(-EOPNOTSUPP);
 
-	buffer = kzalloc(SMK_LONGLABEL, GFP_KERNEL);
+	buffer = kzalloc(SMK_LONGLABEL, GFP_NOFS);
 	if (buffer == NULL)
 		return ERR_PTR(-ENOMEM);
 


