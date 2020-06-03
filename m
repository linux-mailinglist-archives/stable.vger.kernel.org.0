Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAE11ED313
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 17:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgFCPLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 11:11:54 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2272 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726061AbgFCPLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jun 2020 11:11:53 -0400
Received: from lhreml737-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 601BD6C039D8EF1A0077;
        Wed,  3 Jun 2020 16:11:50 +0100 (IST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 lhreml737-chm.china.huawei.com (10.201.108.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Wed, 3 Jun 2020 16:11:50 +0100
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.160)
 by fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Wed, 3 Jun 2020 17:11:49 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <tiwai@suse.de>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 1/2] ima: Directly assign the ima_default_policy pointer to ima_rules
Date:   Wed, 3 Jun 2020 17:08:20 +0200
Message-ID: <20200603150821.8607-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.65.160]
X-ClientProxiedBy: lhreml719-chm.china.huawei.com (10.201.108.70) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch prevents the following oops:

[   10.771813] BUG: kernel NULL pointer dereference, address: 0000000000000
[...]
[   10.779790] RIP: 0010:ima_match_policy+0xf7/0xb80
[...]
[   10.798576] Call Trace:
[   10.798993]  ? ima_lsm_policy_change+0x2b0/0x2b0
[   10.799753]  ? inode_init_owner+0x1a0/0x1a0
[   10.800484]  ? _raw_spin_lock+0x7a/0xd0
[   10.801592]  ima_must_appraise.part.0+0xb6/0xf0
[   10.802313]  ? ima_fix_xattr.isra.0+0xd0/0xd0
[   10.803167]  ima_must_appraise+0x4f/0x70
[   10.804004]  ima_post_path_mknod+0x2e/0x80
[   10.804800]  do_mknodat+0x396/0x3c0

It occurs when there is a failure during IMA initialization, and
ima_init_policy() is not called. IMA hooks still call ima_match_policy()
but ima_rules is NULL. This patch prevents the crash by directly assigning
the ima_default_policy pointer to ima_rules when ima_rules is defined. This
wouldn't alter the existing behavior, as ima_rules is always set at the end
of ima_init_policy().

Cc: stable@vger.kernel.org # 3.7.x
Fixes: 07f6a79415d7d ("ima: add appraise action keywords and default rules")
Reported-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/ima/ima_policy.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index ef7f68cc935e..e493063a3c34 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -204,7 +204,7 @@ static struct ima_rule_entry *arch_policy_entry __ro_after_init;
 static LIST_HEAD(ima_default_rules);
 static LIST_HEAD(ima_policy_rules);
 static LIST_HEAD(ima_temp_rules);
-static struct list_head *ima_rules;
+static struct list_head *ima_rules = &ima_default_rules;
 
 /* Pre-allocated buffer used for matching keyrings. */
 static char *ima_keyrings;
@@ -768,7 +768,6 @@ void __init ima_init_policy(void)
 			  ARRAY_SIZE(default_appraise_rules),
 			  IMA_DEFAULT_POLICY);
 
-	ima_rules = &ima_default_rules;
 	ima_update_policy_flag();
 }
 
-- 
2.17.1

