Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2078F404E01
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244833AbhIIMHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347796AbhIIME3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:04:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E41AB615A6;
        Thu,  9 Sep 2021 11:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188029;
        bh=6mcHWBWcWXuC5Tmts2xdto8ZuoMFECF0/tuKk/l87Uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zmz/R2gtTghYLlvRwLozSxhWUKGdRITKJ18CeoZYtKvvUKBGujPjdZNbGGqqPrx/t
         /Nt1efPoG5Z7UMyeVxOd256BojXZL9CQUsNRrKOClpkhOQOFXif0bN9YQqvmbTMIlU
         iVVIBT8J3Cs5okpktcBHaKL8ig/UkEpPA3JKJJjrZ6T+obxJRui+Sat03ZhcAa4Ot5
         fWEzMFoA5Dmky6zR2P9mxZCCGj71AjVPeK3xZIIfiHv6nK47uYUeBi9T56DPdapUvv
         u4IZdVFm+J+zJQ3rWhBrSDSK38+KTg/uzq6kFc57vZFBQ2lqTrre7EHfHF2hIOfPPy
         GBTrTtJnjTIkA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 026/219] Smack: Fix wrong semantics in smk_access_entry()
Date:   Thu,  9 Sep 2021 07:43:22 -0400
Message-Id: <20210909114635.143983-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

