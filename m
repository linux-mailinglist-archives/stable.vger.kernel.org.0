Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BF54050DC
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351050AbhIIMcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:32:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353850AbhIIMY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:24:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD35D61B1B;
        Thu,  9 Sep 2021 11:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188300;
        bh=6mcHWBWcWXuC5Tmts2xdto8ZuoMFECF0/tuKk/l87Uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h10Y+ECVadaD/C/zyK4D2h77gZ6QXDjO7qQ1MjtO//ymcG0GqSxRqdTWQJcUi77jv
         JOLFGn8inPM1sDOeNJ48wUS9HZcEOxcch8x265x7vza+l6YodTGE16wuMV2riLb37G
         7xBAtXFGmPPZ5Y+0NoSxne39wAg+65llzKBllX2SBixuJsRwcXs91NTJnZUaJaNmXM
         cPTIlymqNdtVqQBeLRRZCHW0t6qMBlQwJUMliVPXg0m8IvmAp3c7uJLxa106adz3cv
         1gZ3iRXSXV2NBjbJKJck7uZnYq+UOQpv8f+CB2mZji6NRRbd00GzvC2nA8Vc2tJ9r0
         Qz+m405wucltQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 017/176] Smack: Fix wrong semantics in smk_access_entry()
Date:   Thu,  9 Sep 2021 07:48:39 -0400
Message-Id: <20210909115118.146181-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
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

