Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5304B2116
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 10:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235680AbiBKJKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 04:10:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348119AbiBKJKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 04:10:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126BD1029
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 01:10:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACDA1B828B9
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 09:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0103C340E9;
        Fri, 11 Feb 2022 09:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644570604;
        bh=CKGYqsBWEbxJ2UxpeNJw9WMzg9O76RRM6o4smLFMEuk=;
        h=Subject:To:Cc:From:Date:From;
        b=s4sdm7eMEBwhIBAS8iLCSSFrBjyaqeVOvPyE0a+0hAKWNcATzsMwI5Ncfn6/vZmHo
         ilUjceL0dNNYyHDXtWZXTIewHfQRD6qMC9hJJ5ZJWII6FHvpw+YSur0gUZTso30FJK
         SazIXPwZuaWynHuPyT8KDDj12o5OaG1I9xLaJbrQ=
Subject: FAILED: patch "[PATCH] ima: Allow template selection with ima_template[_fmt]= after" failed to apply to 4.9-stable tree
To:     roberto.sassu@huawei.com, guozihua@huawei.com, zohar@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 11 Feb 2022 10:10:01 +0100
Message-ID: <1644570601134252@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bb8e52e4906f148c2faf6656b5106cf7233e9301 Mon Sep 17 00:00:00 2001
From: Roberto Sassu <roberto.sassu@huawei.com>
Date: Mon, 31 Jan 2022 18:11:39 +0100
Subject: [PATCH] ima: Allow template selection with ima_template[_fmt]= after
 ima_hash=

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

