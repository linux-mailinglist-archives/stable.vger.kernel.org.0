Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB95A4B46D1
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245141AbiBNJrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:47:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343706AbiBNJqZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:46:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CF765488;
        Mon, 14 Feb 2022 01:39:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65A61611D2;
        Mon, 14 Feb 2022 09:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E296C340E9;
        Mon, 14 Feb 2022 09:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831588;
        bh=nl3gPIYfJzLGecfMeJs3IXQ2hN/sva0u53e++ciJdV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/87ax4Aby1UzGp7paA4dgIBaXEW90FtFKhRfqiYpwBs1pA4Rsyj9PsMcicGiA1Mw
         vsnpg4aT7z38VXgQ8pTxq/bbjaRIWCCwU8ZruGaHzRUf3G4iA3cisHMK3k/g9lPMZ9
         nDrYnnZzpVftup5OmTXPrK/JZR0rvtlkczOKHLqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Zihua <guozihua@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.10 003/116] ima: Allow template selection with ima_template[_fmt]= after ima_hash=
Date:   Mon, 14 Feb 2022 10:25:02 +0100
Message-Id: <20220214092458.789828706@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
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
@@ -27,6 +27,7 @@ static struct ima_template_desc builtin_
 
 static LIST_HEAD(defined_templates);
 static DEFINE_SPINLOCK(template_list);
+static int template_setup_done;
 
 static const struct ima_template_field supported_fields[] = {
 	{.field_id = "d", .field_init = ima_eventdigest_init,
@@ -80,10 +81,11 @@ static int __init ima_template_setup(cha
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
@@ -107,6 +109,7 @@ static int __init ima_template_setup(cha
 	}
 
 	ima_template = template_desc;
+	template_setup_done = 1;
 	return 1;
 }
 __setup("ima_template=", ima_template_setup);
@@ -115,7 +118,7 @@ static int __init ima_template_fmt_setup
 {
 	int num_templates = ARRAY_SIZE(builtin_templates);
 
-	if (ima_template)
+	if (template_setup_done)
 		return 1;
 
 	if (template_desc_init_fields(str, NULL, NULL) < 0) {
@@ -126,6 +129,7 @@ static int __init ima_template_fmt_setup
 
 	builtin_templates[num_templates - 1].fmt = str;
 	ima_template = builtin_templates + num_templates - 1;
+	template_setup_done = 1;
 
 	return 1;
 }


