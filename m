Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8C715F07A
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388557AbgBNRzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:55:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:41336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388390AbgBNP5w (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:57:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5826B2067D;
        Fri, 14 Feb 2020 15:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695872;
        bh=/3VnREholAGknjvQkn37m2IhwdrbsroF5wtY5UhNtEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yo11B/YJ+YD+M6RxyxUeDrsnf/XmJHNy/MJA3mhE8Uq4/RrXMh1q/dbng82MTYd3v
         RbxC5AY5g3OMEFD0ngqLAyg0WYlSvBOnBsnOs6N1LrrpR01WF8vUrJ2iQLN1bqrY3X
         VDZgTaPTc3TUBmj97fmFFlFMl2vwLmzxU1mfV8Wg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>, selinux@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 417/542] selinux: fix regression introduced by move_mount(2) syscall
Date:   Fri, 14 Feb 2020 10:46:49 -0500
Message-Id: <20200214154854.6746-417-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Smalley <sds@tycho.nsa.gov>

[ Upstream commit 98aa00345de54b8340dc2ddcd87f446d33387b5e ]

commit 2db154b3ea8e ("vfs: syscall: Add move_mount(2) to move mounts around")
introduced a new move_mount(2) system call and a corresponding new LSM
security_move_mount hook but did not implement this hook for any existing
LSM.  This creates a regression for SELinux with respect to consistent
checking of mounts; the existing selinux_mount hook checks mounton
permission to the mount point path.  Provide a SELinux hook
implementation for move_mount that applies this same check for
consistency.  In the future we may wish to add a new move_mount
filesystem permission and check as well, but this addresses
the immediate regression.

Fixes: 2db154b3ea8e ("vfs: syscall: Add move_mount(2) to move mounts around")
Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/hooks.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 65641c61ecb94..db44c7eb43213 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2762,6 +2762,14 @@ static int selinux_mount(const char *dev_name,
 		return path_has_perm(cred, path, FILE__MOUNTON);
 }
 
+static int selinux_move_mount(const struct path *from_path,
+			      const struct path *to_path)
+{
+	const struct cred *cred = current_cred();
+
+	return path_has_perm(cred, to_path, FILE__MOUNTON);
+}
+
 static int selinux_umount(struct vfsmount *mnt, int flags)
 {
 	const struct cred *cred = current_cred();
@@ -6907,6 +6915,8 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(sb_clone_mnt_opts, selinux_sb_clone_mnt_opts),
 	LSM_HOOK_INIT(sb_add_mnt_opt, selinux_add_mnt_opt),
 
+	LSM_HOOK_INIT(move_mount, selinux_move_mount),
+
 	LSM_HOOK_INIT(dentry_init_security, selinux_dentry_init_security),
 	LSM_HOOK_INIT(dentry_create_files_as, selinux_dentry_create_files_as),
 
-- 
2.20.1

