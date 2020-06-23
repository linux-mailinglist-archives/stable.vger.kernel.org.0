Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5276E20666D
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393840AbgFWVlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388354AbgFWUFY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:05:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 567E1206C3;
        Tue, 23 Jun 2020 20:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942723;
        bh=1NF0D52SjLWuoqpErt/1qZ2TWiGPSKCCStjOOEoxLF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=isEAPzBxL1dubKlS6w9G9MbsHfNHGadMKCZBkWYEpGRb2jhvIfx2RB2iW5II8U+i1
         CEAI6sAJHSMuPUtiraPnExSZtLPHh/oJTtqhuDAqERDp0G5muOLuYfkRk4T6iokqOY
         ycDnbQXOLfMRkQwE9OonfVg3/Pt9LkSC+hp7czgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 111/477] apparmor: fix nnp subset test for unconfined
Date:   Tue, 23 Jun 2020 21:51:48 +0200
Message-Id: <20200623195412.838293014@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a84ef030fbd7d..4cfa58c077780 100644
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
@@ -1423,7 +1424,7 @@ check:
 		 * reduce restrictions.
 		 */
 		if (task_no_new_privs(current) && !unconfined(label) &&
-		    !aa_label_is_subset(new, ctx->nnp)) {
+		    !aa_label_is_unconfined_subset(new, ctx->nnp)) {
 			/* not an apparmor denial per se, so don't log it */
 			AA_DEBUG("no_new_privs - change_hat denied");
 			error = -EPERM;
diff --git a/security/apparmor/include/label.h b/security/apparmor/include/label.h
index 47942c4ba7ca7..255764ab06e2f 100644
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
index 6c3acae701efd..5f324d63ceaa3 100644
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



