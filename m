Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3EE0246A0B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730093AbgHQP30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:29:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730088AbgHQP3X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:29:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D5C12395B;
        Mon, 17 Aug 2020 15:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678162;
        bh=1sMJ4DzHl9wjIkYM1UGBRkiU3Arytg+JDvm2TSLd80A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=db7VWCLlW/Ghrhmgn6wGlP4gyfY8sC9xVVILjnlci0B8ugsC+KcWuIvT8GsgK++WK
         4iVCoeSzgxs29pfK59B4OeOnLnuPhPe5ydnwEksSe7bNZGmcMsUf1zCsqWQkj9nGT8
         cHHdLNLbPojDtqx7sssMzzWJdR/Qomp/+qAGXDgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@linux.microsoft.com>,
        Janne Karhunen <janne.karhunen@gmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 239/464] ima: Have the LSM free its audit rule
Date:   Mon, 17 Aug 2020 17:13:12 +0200
Message-Id: <20200817143845.244431488@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyler Hicks <tyhicks@linux.microsoft.com>

[ Upstream commit 9ff8a616dfab96a4fa0ddd36190907dc68886d9b ]

Ask the LSM to free its audit rule rather than directly calling kfree().
Both AppArmor and SELinux do additional work in their audit_rule_free()
hooks. Fix memory leaks by allowing the LSMs to perform necessary work.

Fixes: b16942455193 ("ima: use the lsm policy update notifier")
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: Janne Karhunen <janne.karhunen@gmail.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima.h        | 5 +++++
 security/integrity/ima/ima_policy.c | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 9d94080bdad82..f0748f8ca47e9 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -404,6 +404,7 @@ static inline void ima_free_modsig(struct modsig *modsig)
 #ifdef CONFIG_IMA_LSM_RULES
 
 #define security_filter_rule_init security_audit_rule_init
+#define security_filter_rule_free security_audit_rule_free
 #define security_filter_rule_match security_audit_rule_match
 
 #else
@@ -414,6 +415,10 @@ static inline int security_filter_rule_init(u32 field, u32 op, char *rulestr,
 	return -EINVAL;
 }
 
+static inline void security_filter_rule_free(void *lsmrule)
+{
+}
+
 static inline int security_filter_rule_match(u32 secid, u32 field, u32 op,
 					     void *lsmrule)
 {
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index e493063a3c344..236a731492d1e 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -258,7 +258,7 @@ static void ima_lsm_free_rule(struct ima_rule_entry *entry)
 	int i;
 
 	for (i = 0; i < MAX_LSM_RULES; i++) {
-		kfree(entry->lsm[i].rule);
+		security_filter_rule_free(entry->lsm[i].rule);
 		kfree(entry->lsm[i].args_p);
 	}
 	kfree(entry);
-- 
2.25.1



