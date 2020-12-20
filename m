Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D262DF2F1
	for <lists+stable@lfdr.de>; Sun, 20 Dec 2020 04:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgLTDfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 22:35:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727318AbgLTDfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 22:35:22 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Serge Hallyn <shallyn@cisco.com>,
        =?UTF-8?q?Herv=C3=A9=20Guillemet?= <herve@guillemet.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "Andrew G . Morgan" <morgan@kernel.org>,
        James Morris <jamorris@linux.microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.9 05/15] [SECURITY] fix namespaced fscaps when !CONFIG_SECURITY
Date:   Sat, 19 Dec 2020 22:34:23 -0500
Message-Id: <20201220033434.2728348-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201220033434.2728348-1-sashal@kernel.org>
References: <20201220033434.2728348-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Hallyn <shallyn@cisco.com>

[ Upstream commit ed9b25d1970a4787ac6a39c2091e63b127ecbfc1 ]

Namespaced file capabilities were introduced in 8db6c34f1dbc .
When userspace reads an xattr for a namespaced capability, a
virtualized representation of it is returned if the caller is
in a user namespace owned by the capability's owning rootid.
The function which performs this virtualization was not hooked
up if CONFIG_SECURITY=n.  Therefore in that case the original
xattr was shown instead of the virtualized one.

To test this using libcap-bin (*1),

$ v=$(mktemp)
$ unshare -Ur setcap cap_sys_admin-eip $v
$ unshare -Ur setcap -v cap_sys_admin-eip $v
/tmp/tmp.lSiIFRvt8Y: OK

"setcap -v" verifies the values instead of setting them, and
will check whether the rootid value is set.  Therefore, with
this bug un-fixed, and with CONFIG_SECURITY=n, setcap -v will
fail:

$ v=$(mktemp)
$ unshare -Ur setcap cap_sys_admin=eip $v
$ unshare -Ur setcap -v cap_sys_admin=eip $v
nsowner[got=1000, want=0],/tmp/tmp.HHDiOOl9fY differs in []

Fix this bug by calling cap_inode_getsecurity() in
security_inode_getsecurity() instead of returning
-EOPNOTSUPP, when CONFIG_SECURITY=n.

*1 - note, if libcap is too old for getcap to have the '-n'
option, then use verify-caps instead.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=209689
Cc: Hervé Guillemet <herve@guillemet.org>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Serge Hallyn <shallyn@cisco.com>
Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
Signed-off-by: James Morris <jamorris@linux.microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/security.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 0a0a03b36a3bb..2befc0a25eb37 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -864,7 +864,7 @@ static inline int security_inode_killpriv(struct dentry *dentry)
 
 static inline int security_inode_getsecurity(struct inode *inode, const char *name, void **buffer, bool alloc)
 {
-	return -EOPNOTSUPP;
+	return cap_inode_getsecurity(inode, name, buffer, alloc);
 }
 
 static inline int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags)
-- 
2.27.0

