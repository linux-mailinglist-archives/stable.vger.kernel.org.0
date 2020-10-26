Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0A1299FFD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410048AbgJZXxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:53:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410043AbgJZXxV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:53:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8DD52151B;
        Mon, 26 Oct 2020 23:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756400;
        bh=DDpaqNxkr21+3Q3+kpNcwRpQcITi2kQATmOHl+7rVrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b194IkUJNWPoXCMgK7N6hNMBo0g1sz4hBvRpz9t7G8bh5tJ/gmaSGUXJyBFlLU5jl
         9R6TIb3oxuZtuylEQaZNyWXO6RlBVFWMcaw3QscQ0nlrrpCMkasR6CkP4oi4tyLNac
         ADceNLhEHGI9g/qxpAyhWc1118dJp0uyrSxBzr1M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Smalley <stephen.smalley.work@gmail.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>, selinux@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 060/132] selinux: access policycaps with READ_ONCE/WRITE_ONCE
Date:   Mon, 26 Oct 2020 19:50:52 -0400
Message-Id: <20201026235205.1023962-60-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Smalley <stephen.smalley.work@gmail.com>

[ Upstream commit e8ba53d0023a76ba0f50e6ee3e6288c5442f9d33 ]

Use READ_ONCE/WRITE_ONCE for all accesses to the
selinux_state.policycaps booleans to prevent compiler
mischief.

Signed-off-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/include/security.h | 14 +++++++-------
 security/selinux/ss/services.c      |  3 ++-
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index b0e02cfe3ce14..8a432f646967e 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -177,49 +177,49 @@ static inline bool selinux_policycap_netpeer(void)
 {
 	struct selinux_state *state = &selinux_state;
 
-	return state->policycap[POLICYDB_CAPABILITY_NETPEER];
+	return READ_ONCE(state->policycap[POLICYDB_CAPABILITY_NETPEER]);
 }
 
 static inline bool selinux_policycap_openperm(void)
 {
 	struct selinux_state *state = &selinux_state;
 
-	return state->policycap[POLICYDB_CAPABILITY_OPENPERM];
+	return READ_ONCE(state->policycap[POLICYDB_CAPABILITY_OPENPERM]);
 }
 
 static inline bool selinux_policycap_extsockclass(void)
 {
 	struct selinux_state *state = &selinux_state;
 
-	return state->policycap[POLICYDB_CAPABILITY_EXTSOCKCLASS];
+	return READ_ONCE(state->policycap[POLICYDB_CAPABILITY_EXTSOCKCLASS]);
 }
 
 static inline bool selinux_policycap_alwaysnetwork(void)
 {
 	struct selinux_state *state = &selinux_state;
 
-	return state->policycap[POLICYDB_CAPABILITY_ALWAYSNETWORK];
+	return READ_ONCE(state->policycap[POLICYDB_CAPABILITY_ALWAYSNETWORK]);
 }
 
 static inline bool selinux_policycap_cgroupseclabel(void)
 {
 	struct selinux_state *state = &selinux_state;
 
-	return state->policycap[POLICYDB_CAPABILITY_CGROUPSECLABEL];
+	return READ_ONCE(state->policycap[POLICYDB_CAPABILITY_CGROUPSECLABEL]);
 }
 
 static inline bool selinux_policycap_nnp_nosuid_transition(void)
 {
 	struct selinux_state *state = &selinux_state;
 
-	return state->policycap[POLICYDB_CAPABILITY_NNP_NOSUID_TRANSITION];
+	return READ_ONCE(state->policycap[POLICYDB_CAPABILITY_NNP_NOSUID_TRANSITION]);
 }
 
 static inline bool selinux_policycap_genfs_seclabel_symlinks(void)
 {
 	struct selinux_state *state = &selinux_state;
 
-	return state->policycap[POLICYDB_CAPABILITY_GENFS_SECLABEL_SYMLINKS];
+	return READ_ONCE(state->policycap[POLICYDB_CAPABILITY_GENFS_SECLABEL_SYMLINKS]);
 }
 
 int security_mls_enabled(struct selinux_state *state);
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index ef0afd878bfca..04d1afe01838b 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2103,7 +2103,8 @@ static void security_load_policycaps(struct selinux_state *state)
 	struct ebitmap_node *node;
 
 	for (i = 0; i < ARRAY_SIZE(state->policycap); i++)
-		state->policycap[i] = ebitmap_get_bit(&p->policycaps, i);
+		WRITE_ONCE(state->policycap[i],
+			ebitmap_get_bit(&p->policycaps, i));
 
 	for (i = 0; i < ARRAY_SIZE(selinux_policycap_names); i++)
 		pr_info("SELinux:  policy capability %s=%d\n",
-- 
2.25.1

