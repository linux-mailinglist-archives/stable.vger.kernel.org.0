Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475B11FE823
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgFRCqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:46:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728545AbgFRBKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34D12221EA;
        Thu, 18 Jun 2020 01:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442635;
        bh=z3TApV2sXDsdLnRKDBfmzrWUPYKbt+3FMoXHkR5RR4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Idx70aDqfovYNJvbt/7yv3i/ZjLTmL0ZWV4V5NF9bK34LGZk5mU2zlHF4+O3vuaoe
         I01Zfc+zGXPCVZaXEDl8rbkYvobtEvN16eAWAjJD2iAQpNTkwEB3twTnZ+LryfI4eT
         zrZHMUBDhrY8oH4IK52SAmwqzhRZyGvTWHzYiStM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 112/388] apparmor: fix nnp subset test for unconfined
Date:   Wed, 17 Jun 2020 21:03:29 -0400
Message-Id: <20200618010805.600873-112-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 3ed4aaa94fc07db3cd0c91be95e3e1b9782a2710 ]

The subset test is not taking into account the unconfined exception
which will cause profile transitions in the stacked confinement
case to fail when no_new_privs is applied.

This fixes a regression introduced in the fix for
https://bugs.launchpad.net/bugs/1839037

BugLink: https://bugs.launchpad.net/bugs/1844186
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/domain.c        |  9 +++++----
 security/apparmor/include/label.h |  1 +
 security/apparmor/label.c         | 33 +++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index a84ef030fbd7..4cfa58c07778 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -929,7 +929,8 @@ int apparmor_bprm_set_creds(struct linux_binprm *bprm)
 	 * aways results in a further reduction of permissions.
 	 */
 	if ((bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS) &&
-	    !unconfined(label) && !aa_label_is_subset(new, ctx->nnp)) {
+	    !unconfined(label) &&
+	    !aa_label_is_unconfined_subset(new, ctx->nnp)) {
 		error = -EPERM;
 		info = "no new privs";
 		goto audit;
@@ -1207,7 +1208,7 @@ int aa_change_hat(const char *hats[], int count, u64 token, int flags)
 		 * reduce restrictions.
 		 */
 		if (task_no_new_privs(current) && !unconfined(label) &&
-		    !aa_label_is_subset(new, ctx->nnp)) {
+		    !aa_label_is_unconfined_subset(new, ctx->nnp)) {
 			/* not an apparmor denial per se, so don't log it */
 			AA_DEBUG("no_new_privs - change_hat denied");
 			error = -EPERM;
@@ -1228,7 +1229,7 @@ int aa_change_hat(const char *hats[], int count, u64 token, int flags)
 		 * reduce restrictions.
 		 */
 		if (task_no_new_privs(current) && !unconfined(label) &&
-		    !aa_label_is_subset(previous, ctx->nnp)) {
+		    !aa_label_is_unconfined_subset(previous, ctx->nnp)) {
 			/* not an apparmor denial per se, so don't log it */
 			AA_DEBUG("no_new_privs - change_hat denied");
 			error = -EPERM;
@@ -1423,7 +1424,7 @@ int aa_change_profile(const char *fqname, int flags)
 		 * reduce restrictions.
 		 */
 		if (task_no_new_privs(current) && !unconfined(label) &&
-		    !aa_label_is_subset(new, ctx->nnp)) {
+		    !aa_label_is_unconfined_subset(new, ctx->nnp)) {
 			/* not an apparmor denial per se, so don't log it */
 			AA_DEBUG("no_new_privs - change_hat denied");
 			error = -EPERM;
diff --git a/security/apparmor/include/label.h b/security/apparmor/include/label.h
index 47942c4ba7ca..255764ab06e2 100644
--- a/security/apparmor/include/label.h
+++ b/security/apparmor/include/label.h
@@ -281,6 +281,7 @@ bool aa_label_init(struct aa_label *label, int size, gfp_t gfp);
 struct aa_label *aa_label_alloc(int size, struct aa_proxy *proxy, gfp_t gfp);
 
 bool aa_label_is_subset(struct aa_label *set, struct aa_label *sub);
+bool aa_label_is_unconfined_subset(struct aa_label *set, struct aa_label *sub);
 struct aa_profile *__aa_label_next_not_in_set(struct label_it *I,
 					     struct aa_label *set,
 					     struct aa_label *sub);
diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index 6c3acae701ef..5f324d63ceaa 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -550,6 +550,39 @@ bool aa_label_is_subset(struct aa_label *set, struct aa_label *sub)
 	return __aa_label_next_not_in_set(&i, set, sub) == NULL;
 }
 
+/**
+ * aa_label_is_unconfined_subset - test if @sub is a subset of @set
+ * @set: label to test against
+ * @sub: label to test if is subset of @set
+ *
+ * This checks for subset but taking into account unconfined. IF
+ * @sub contains an unconfined profile that does not have a matching
+ * unconfined in @set then this will not cause the test to fail.
+ * Conversely we don't care about an unconfined in @set that is not in
+ * @sub
+ *
+ * Returns: true if @sub is special_subset of @set
+ *     else false
+ */
+bool aa_label_is_unconfined_subset(struct aa_label *set, struct aa_label *sub)
+{
+	struct label_it i = { };
+	struct aa_profile *p;
+
+	AA_BUG(!set);
+	AA_BUG(!sub);
+
+	if (sub == set)
+		return true;
+
+	do {
+		p = __aa_label_next_not_in_set(&i, set, sub);
+		if (p && !profile_unconfined(p))
+			break;
+	} while (p);
+
+	return p == NULL;
+}
 
 
 /**
-- 
2.25.1

