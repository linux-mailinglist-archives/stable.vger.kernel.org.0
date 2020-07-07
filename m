Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DB22171D7
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgGGP0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:26:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728835AbgGGP0L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:26:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 800A320663;
        Tue,  7 Jul 2020 15:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135571;
        bh=hHgvl0Dc8pGUFtYfFK3SnYyT+hb26J/OUJArdMEHL4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bgU0KfAgOhLhDYk7LTXoMsc9AfOopaOiq32KW1P3cYlSnh5kmvWWlvbMzVq03N9CW
         a6VHdlgKzqYLLT1s7T17trIk99Pc/CspK6Ia1szvFLjmq3Dd3UBuFS5l6g8BADlyVT
         sLxXTO5WVGPitaHt2q+KJnn606JjZv0zQXDHfLh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, KP Singh <kpsingh@google.com>,
        James Morris <jmorris@namei.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 063/112] security: Fix hook iteration and default value for inode_copy_up_xattr
Date:   Tue,  7 Jul 2020 17:17:08 +0200
Message-Id: <20200707145803.998566427@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: KP Singh <kpsingh@google.com>

[ Upstream commit 23e390cdbe6f85827a43d38f9288dcd3066fa376 ]

inode_copy_up_xattr returns 0 to indicate the acceptance of the xattr
and 1 to reject it. If the LSM does not know about the xattr, it's
expected to return -EOPNOTSUPP, which is the correct default value for
this hook. BPF LSM, currently, uses 0 as the default value and thereby
falsely allows all overlay fs xattributes to be copied up.

The iteration logic is also updated from the "bail-on-fail"
call_int_hook to continue on the non-decisive -EOPNOTSUPP and bail out
on other values.

Fixes: 98e828a0650f ("security: Refactor declaration of LSM hooks")
Signed-off-by: KP Singh <kpsingh@google.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/lsm_hook_defs.h |  2 +-
 security/security.c           | 17 ++++++++++++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 5616b2567aa7f..c2d073c49bf8a 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -149,7 +149,7 @@ LSM_HOOK(int, 0, inode_listsecurity, struct inode *inode, char *buffer,
 	 size_t buffer_size)
 LSM_HOOK(void, LSM_RET_VOID, inode_getsecid, struct inode *inode, u32 *secid)
 LSM_HOOK(int, 0, inode_copy_up, struct dentry *src, struct cred **new)
-LSM_HOOK(int, 0, inode_copy_up_xattr, const char *name)
+LSM_HOOK(int, -EOPNOTSUPP, inode_copy_up_xattr, const char *name)
 LSM_HOOK(int, 0, kernfs_init_security, struct kernfs_node *kn_dir,
 	 struct kernfs_node *kn)
 LSM_HOOK(int, 0, file_permission, struct file *file, int mask)
diff --git a/security/security.c b/security/security.c
index 51de970fbb1ed..8b4d342ade5e1 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1409,7 +1409,22 @@ EXPORT_SYMBOL(security_inode_copy_up);
 
 int security_inode_copy_up_xattr(const char *name)
 {
-	return call_int_hook(inode_copy_up_xattr, -EOPNOTSUPP, name);
+	struct security_hook_list *hp;
+	int rc;
+
+	/*
+	 * The implementation can return 0 (accept the xattr), 1 (discard the
+	 * xattr), -EOPNOTSUPP if it does not know anything about the xattr or
+	 * any other error code incase of an error.
+	 */
+	hlist_for_each_entry(hp,
+		&security_hook_heads.inode_copy_up_xattr, list) {
+		rc = hp->hook.inode_copy_up_xattr(name);
+		if (rc != LSM_RET_DEFAULT(inode_copy_up_xattr))
+			return rc;
+	}
+
+	return LSM_RET_DEFAULT(inode_copy_up_xattr);
 }
 EXPORT_SYMBOL(security_inode_copy_up_xattr);
 
-- 
2.25.1



