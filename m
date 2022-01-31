Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BFF4A4CD9
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 18:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380741AbiAaRNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 12:13:51 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4577 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380775AbiAaRNt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 12:13:49 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JnZQN2X6hz67lD0;
        Tue,  1 Feb 2022 01:13:16 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 31 Jan 2022 18:13:46 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <guozihua@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] ima: Allow template selection with ima_template[_fmt]= after ima_hash=
Date:   Mon, 31 Jan 2022 18:11:39 +0100
Message-ID: <20220131171139.3024883-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml751-chm.china.huawei.com (10.201.108.201) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit c2426d2ad5027 ("ima: added support for new kernel cmdline parameter
ima_template_fmt") introduced an additional check on the ima_template
variable to avoid multiple template selection.

Unfortunately, ima_template could be also set by the setup function of the
ima_hash= parameter, when it calls ima_template_desc_current(). This causes
attempts to choose a new template with ima_template= or with
ima_template_fmt=, after ima_hash=, to be ignored.

Achieve the goal of the commit mentioned with the new static variable
template_setup_done, so that template selection requests after ima_hash=
are not ignored.

Finally, call ima_init_template_list(), if not already done, to initialize
the list of templates before lookup_template_desc() is called.

Cc: stable@vger.kernel.org
Fixes: c2426d2ad5027 ("ima: added support for new kernel cmdline parameter ima_template_fmt")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/ima/ima_template.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 694560396be0..db1ad6d7a57f 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -29,6 +29,7 @@ static struct ima_template_desc builtin_templates[] = {
 
 static LIST_HEAD(defined_templates);
 static DEFINE_SPINLOCK(template_list);
+static int template_setup_done;
 
 static const struct ima_template_field supported_fields[] = {
 	{.field_id = "d", .field_init = ima_eventdigest_init,
@@ -101,10 +102,11 @@ static int __init ima_template_setup(char *str)
 	struct ima_template_desc *template_desc;
 	int template_len = strlen(str);
 
-	if (ima_template)
+	if (template_setup_done)
 		return 1;
 
-	ima_init_template_list();
+	if (!ima_template)
+		ima_init_template_list();
 
 	/*
 	 * Verify that a template with the supplied name exists.
@@ -128,6 +130,7 @@ static int __init ima_template_setup(char *str)
 	}
 
 	ima_template = template_desc;
+	template_setup_done = 1;
 	return 1;
 }
 __setup("ima_template=", ima_template_setup);
@@ -136,7 +139,7 @@ static int __init ima_template_fmt_setup(char *str)
 {
 	int num_templates = ARRAY_SIZE(builtin_templates);
 
-	if (ima_template)
+	if (template_setup_done)
 		return 1;
 
 	if (template_desc_init_fields(str, NULL, NULL) < 0) {
@@ -147,6 +150,7 @@ static int __init ima_template_fmt_setup(char *str)
 
 	builtin_templates[num_templates - 1].fmt = str;
 	ima_template = builtin_templates + num_templates - 1;
+	template_setup_done = 1;
 
 	return 1;
 }
-- 
2.32.0

