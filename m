Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9C6715F395
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393384AbgBNSNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:13:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:59710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731065AbgBNPwu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:52:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7A3724686;
        Fri, 14 Feb 2020 15:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695569;
        bh=W3YAjjAqQeAdyuTJsmpIGGIqG3trqt6js3AePwn5yyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GY9drZzc4bLkWMlvMIMJuQ5E8pc+MNHfP8VqjdiOqXadmW9HpBdw3gfdL4jM+mXIz
         hXLcfGPFIB9TM26m953xWXAx9cSDSmz1yiloy20w5jBfuriLrs7Re5yFh1Cpz+npGP
         9xugG96Rl4XaNyu8yUO+RvtM/KNnoRspWMh+FgaI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Smalley <sds@tycho.nsa.gov>, Will Deacon <will@kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>, selinux@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 181/542] selinux: revert "stop passing MAY_NOT_BLOCK to the AVC upon follow_link"
Date:   Fri, 14 Feb 2020 10:42:53 -0500
Message-Id: <20200214154854.6746-181-sashal@kernel.org>
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

[ Upstream commit 1a37079c236d55fb31ebbf4b59945dab8ec8764c ]

This reverts commit e46e01eebbbc ("selinux: stop passing MAY_NOT_BLOCK
to the AVC upon follow_link"). The correct fix is to instead fall
back to ref-walk if audit is required irrespective of the specific
audit data type.  This is done in the next commit.

Fixes: e46e01eebbbc ("selinux: stop passing MAY_NOT_BLOCK to the AVC upon follow_link")
Reported-by: Will Deacon <will@kernel.org>
Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/avc.c         | 24 ++++++++++++++++++++++--
 security/selinux/hooks.c       |  5 +++--
 security/selinux/include/avc.h |  5 +++++
 3 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index ecd3829996aa4..74c43ebe34bb8 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -862,8 +862,9 @@ static int avc_update_node(struct selinux_avc *avc,
 	 * permissive mode that only appear when in enforcing mode.
 	 *
 	 * See the corresponding handling in slow_avc_audit(), and the
-	 * logic in selinux_inode_permission for the MAY_NOT_BLOCK flag,
-	 * which is transliterated into AVC_NONBLOCKING.
+	 * logic in selinux_inode_follow_link and selinux_inode_permission
+	 * for the VFS MAY_NOT_BLOCK flag, which is transliterated into
+	 * AVC_NONBLOCKING for avc_has_perm_noaudit().
 	 */
 	if (flags & AVC_NONBLOCKING)
 		return 0;
@@ -1205,6 +1206,25 @@ int avc_has_perm(struct selinux_state *state, u32 ssid, u32 tsid, u16 tclass,
 	return rc;
 }
 
+int avc_has_perm_flags(struct selinux_state *state,
+		       u32 ssid, u32 tsid, u16 tclass, u32 requested,
+		       struct common_audit_data *auditdata,
+		       int flags)
+{
+	struct av_decision avd;
+	int rc, rc2;
+
+	rc = avc_has_perm_noaudit(state, ssid, tsid, tclass, requested,
+				  (flags & MAY_NOT_BLOCK) ? AVC_NONBLOCKING : 0,
+				  &avd);
+
+	rc2 = avc_audit(state, ssid, tsid, tclass, requested, &avd, rc,
+			auditdata, flags);
+	if (rc2)
+		return rc2;
+	return rc;
+}
+
 u32 avc_policy_seqno(struct selinux_state *state)
 {
 	return state->avc->avc_cache.latest_notif;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 116b4d644f689..710a4fffa66f4 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3004,8 +3004,9 @@ static int selinux_inode_follow_link(struct dentry *dentry, struct inode *inode,
 	if (IS_ERR(isec))
 		return PTR_ERR(isec);
 
-	return avc_has_perm(&selinux_state,
-			    sid, isec->sid, isec->sclass, FILE__READ, &ad);
+	return avc_has_perm_flags(&selinux_state,
+				  sid, isec->sid, isec->sclass, FILE__READ, &ad,
+				  rcu ? MAY_NOT_BLOCK : 0);
 }
 
 static noinline int audit_inode_permission(struct inode *inode,
diff --git a/security/selinux/include/avc.h b/security/selinux/include/avc.h
index 7be0e1e90e8be..74ea50977c201 100644
--- a/security/selinux/include/avc.h
+++ b/security/selinux/include/avc.h
@@ -153,6 +153,11 @@ int avc_has_perm(struct selinux_state *state,
 		 u32 ssid, u32 tsid,
 		 u16 tclass, u32 requested,
 		 struct common_audit_data *auditdata);
+int avc_has_perm_flags(struct selinux_state *state,
+		       u32 ssid, u32 tsid,
+		       u16 tclass, u32 requested,
+		       struct common_audit_data *auditdata,
+		       int flags);
 
 int avc_has_extended_perms(struct selinux_state *state,
 			   u32 ssid, u32 tsid, u16 tclass, u32 requested,
-- 
2.20.1

