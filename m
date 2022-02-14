Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61EA24B49B0
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346159AbiBNKR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:17:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347401AbiBNKQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:16:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7576B6D970;
        Mon, 14 Feb 2022 01:53:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A209960F86;
        Mon, 14 Feb 2022 09:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828AFC340E9;
        Mon, 14 Feb 2022 09:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832433;
        bh=lyJPkVECiprsua+kfLo7vwcWYPr4vADc2/aJV5dQ37A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3gYunt78+C4R9JOOMSDo4c4XEVIRZcnD8Fv8HakgGQoDb5k6kfdlNEiruxpxq3cA
         jSq2fwa6qL+nJjn18BeUDk+g2vnnmMq8Q5e677Ae6s6k6zZTr76LJUOjL/F7JARrCM
         IX1V3yAHsY74iDzzfVZy7pRRC5S1AYyNxZ5EGLnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Zihua <guozihua@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.16 005/203] ima: Allow template selection with ima_template[_fmt]= after ima_hash=
Date:   Mon, 14 Feb 2022 10:24:09 +0100
Message-Id: <20220214092510.404600708@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

commit bb8e52e4906f148c2faf6656b5106cf7233e9301 upstream.

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

Reported-by: Guo Zihua <guozihua@huawei.com>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: stable@vger.kernel.org
Fixes: c2426d2ad5027 ("ima: added support for new kernel cmdline parameter ima_template_fmt")
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima_template.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -29,6 +29,7 @@ static struct ima_template_desc builtin_
 
 static LIST_HEAD(defined_templates);
 static DEFINE_SPINLOCK(template_list);
+static int template_setup_done;
 
 static const struct ima_template_field supported_fields[] = {
 	{.field_id = "d", .field_init = ima_eventdigest_init,
@@ -101,10 +102,11 @@ static int __init ima_template_setup(cha
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
@@ -128,6 +130,7 @@ static int __init ima_template_setup(cha
 	}
 
 	ima_template = template_desc;
+	template_setup_done = 1;
 	return 1;
 }
 __setup("ima_template=", ima_template_setup);
@@ -136,7 +139,7 @@ static int __init ima_template_fmt_setup
 {
 	int num_templates = ARRAY_SIZE(builtin_templates);
 
-	if (ima_template)
+	if (template_setup_done)
 		return 1;
 
 	if (template_desc_init_fields(str, NULL, NULL) < 0) {
@@ -147,6 +150,7 @@ static int __init ima_template_fmt_setup
 
 	builtin_templates[num_templates - 1].fmt = str;
 	ima_template = builtin_templates + num_templates - 1;
+	template_setup_done = 1;
 
 	return 1;
 }


