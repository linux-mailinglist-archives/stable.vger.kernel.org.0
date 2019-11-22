Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F832106A8A
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfKVKfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:35:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728288AbfKVKfq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:35:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16C7120715;
        Fri, 22 Nov 2019 10:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418944;
        bh=edcdRs8qjLW9Buch9MPov4jh7ZiXSUmJVTFNJjzWTOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xTVI54vZCS0NEJDkkYttvVLJDZ/bFgXUFhQFjuZy73oLalCWlRUt9qC0mDqpXl2W9
         6ZHhVhOF6lAvIbb3npdcxyWwE6QOFjLTwRSKSDtU8YiGWY89I6Bil+MxSpD9KFe3r6
         uNNh43PTQKAUl0L/WiwSecKfZduMiheGGXBDb8y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Johansen <john.johansen@canonical.com>
Subject: [PATCH 4.4 104/159] apparmor: fix module parameters can be changed after policy is locked
Date:   Fri, 22 Nov 2019 11:28:15 +0100
Message-Id: <20191122100823.450440259@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Johansen <john.johansen@canonical.com>

commit 58acf9d911c8831156634a44d0b022d683e1e50c upstream.

the policy_lock parameter is a one way switch that prevents policy
from being further modified. Unfortunately some of the module parameters
can effectively modify policy by turning off enforcement.

split policy_admin_capable into a view check and a full admin check,
and update the admin check to test the policy_lock parameter.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/apparmor/include/policy.h |    2 ++
 security/apparmor/lsm.c            |   22 ++++++++++------------
 security/apparmor/policy.c         |   18 +++++++++++++++++-
 3 files changed, 29 insertions(+), 13 deletions(-)

--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -403,6 +403,8 @@ static inline int AUDIT_MODE(struct aa_p
 	return profile->audit;
 }
 
+bool policy_view_capable(void);
+bool policy_admin_capable(void);
 bool aa_may_manage_policy(int op);
 
 #endif /* __AA_POLICY_H */
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -749,51 +749,49 @@ __setup("apparmor=", apparmor_enabled_se
 /* set global flag turning off the ability to load policy */
 static int param_set_aalockpolicy(const char *val, const struct kernel_param *kp)
 {
-	if (!capable(CAP_MAC_ADMIN))
+	if (!policy_admin_capable())
 		return -EPERM;
-	if (aa_g_lock_policy)
-		return -EACCES;
 	return param_set_bool(val, kp);
 }
 
 static int param_get_aalockpolicy(char *buffer, const struct kernel_param *kp)
 {
-	if (!capable(CAP_MAC_ADMIN))
+	if (!policy_view_capable())
 		return -EPERM;
 	return param_get_bool(buffer, kp);
 }
 
 static int param_set_aabool(const char *val, const struct kernel_param *kp)
 {
-	if (!capable(CAP_MAC_ADMIN))
+	if (!policy_admin_capable())
 		return -EPERM;
 	return param_set_bool(val, kp);
 }
 
 static int param_get_aabool(char *buffer, const struct kernel_param *kp)
 {
-	if (!capable(CAP_MAC_ADMIN))
+	if (!policy_view_capable())
 		return -EPERM;
 	return param_get_bool(buffer, kp);
 }
 
 static int param_set_aauint(const char *val, const struct kernel_param *kp)
 {
-	if (!capable(CAP_MAC_ADMIN))
+	if (!policy_admin_capable())
 		return -EPERM;
 	return param_set_uint(val, kp);
 }
 
 static int param_get_aauint(char *buffer, const struct kernel_param *kp)
 {
-	if (!capable(CAP_MAC_ADMIN))
+	if (!policy_view_capable())
 		return -EPERM;
 	return param_get_uint(buffer, kp);
 }
 
 static int param_get_audit(char *buffer, struct kernel_param *kp)
 {
-	if (!capable(CAP_MAC_ADMIN))
+	if (!policy_view_capable())
 		return -EPERM;
 
 	if (!apparmor_enabled)
@@ -805,7 +803,7 @@ static int param_get_audit(char *buffer,
 static int param_set_audit(const char *val, struct kernel_param *kp)
 {
 	int i;
-	if (!capable(CAP_MAC_ADMIN))
+	if (!policy_admin_capable())
 		return -EPERM;
 
 	if (!apparmor_enabled)
@@ -826,7 +824,7 @@ static int param_set_audit(const char *v
 
 static int param_get_mode(char *buffer, struct kernel_param *kp)
 {
-	if (!capable(CAP_MAC_ADMIN))
+	if (!policy_admin_capable())
 		return -EPERM;
 
 	if (!apparmor_enabled)
@@ -838,7 +836,7 @@ static int param_get_mode(char *buffer,
 static int param_set_mode(const char *val, struct kernel_param *kp)
 {
 	int i;
-	if (!capable(CAP_MAC_ADMIN))
+	if (!policy_admin_capable())
 		return -EPERM;
 
 	if (!apparmor_enabled)
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -916,6 +916,22 @@ static int audit_policy(int op, gfp_t gf
 			&sa, NULL);
 }
 
+bool policy_view_capable(void)
+{
+	struct user_namespace *user_ns = current_user_ns();
+	bool response = false;
+
+	if (ns_capable(user_ns, CAP_MAC_ADMIN))
+		response = true;
+
+	return response;
+}
+
+bool policy_admin_capable(void)
+{
+	return policy_view_capable() && !aa_g_lock_policy;
+}
+
 /**
  * aa_may_manage_policy - can the current task manage policy
  * @op: the policy manipulation operation being done
@@ -930,7 +946,7 @@ bool aa_may_manage_policy(int op)
 		return 0;
 	}
 
-	if (!capable(CAP_MAC_ADMIN)) {
+	if (!policy_admin_capable()) {
 		audit_policy(op, GFP_KERNEL, NULL, "not policy admin", -EACCES);
 		return 0;
 	}


