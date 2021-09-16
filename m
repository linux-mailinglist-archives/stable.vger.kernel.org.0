Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8022340E303
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343688AbhIPQoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245632AbhIPQmC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:42:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C022613B1;
        Thu, 16 Sep 2021 16:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809465;
        bh=6mcHWBWcWXuC5Tmts2xdto8ZuoMFECF0/tuKk/l87Uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tGdTskoDGHsA8vhCJcf/2FrDY19/YI86mG9sXPdFe/eTdf2Pu82688qer6jID27T1
         9YmxdnADQgHV3/VyMg4dxDfraJO2QV5NDitrYMrP+wBIr10Fgh/P82mPFnkS0ZpTgG
         HI0CvOtQ2M8dorVYkVjK0w4mpq+4QPeHVZVlm6VE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 164/380] Smack: Fix wrong semantics in smk_access_entry()
Date:   Thu, 16 Sep 2021 17:58:41 +0200
Message-Id: <20210916155809.664284642@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit 6d14f5c7028eea70760df284057fe198ce7778dd ]

In the smk_access_entry() function, if no matching rule is found
in the rust_list, a negative error code will be used to perform bit
operations with the MAY_ enumeration value. This is semantically
wrong. This patch fixes this issue.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_access.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 7eabb448acab..169929c6c4eb 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -81,23 +81,22 @@ int log_policy = SMACK_AUDIT_DENIED;
 int smk_access_entry(char *subject_label, char *object_label,
 			struct list_head *rule_list)
 {
-	int may = -ENOENT;
 	struct smack_rule *srp;
 
 	list_for_each_entry_rcu(srp, rule_list, list) {
 		if (srp->smk_object->smk_known == object_label &&
 		    srp->smk_subject->smk_known == subject_label) {
-			may = srp->smk_access;
-			break;
+			int may = srp->smk_access;
+			/*
+			 * MAY_WRITE implies MAY_LOCK.
+			 */
+			if ((may & MAY_WRITE) == MAY_WRITE)
+				may |= MAY_LOCK;
+			return may;
 		}
 	}
 
-	/*
-	 * MAY_WRITE implies MAY_LOCK.
-	 */
-	if ((may & MAY_WRITE) == MAY_WRITE)
-		may |= MAY_LOCK;
-	return may;
+	return -ENOENT;
 }
 
 /**
-- 
2.30.2



