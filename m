Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D81C2B5CC6
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbfIRG0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:26:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbfIRG0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:26:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A86B821924;
        Wed, 18 Sep 2019 06:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787964;
        bh=RNCX+fJlMdn0iDOz7lBTlhcRBNaEyS2dXlsok6AN1B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oRdEzQNhla/FX59hOODpH5fox/LZPR8w7/FSga2jHJ/Fs7Csc1xRm5qzIjzso343r
         zFdilvB4hdGBGEunceTXA1qjicV/0e14RCc2HNbPhPz71euFy/YBYEq3yZSSbo0C68
         PBTJSYVGq1go339C/X8JxaYWmQauCoCfuxxoKYAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        YueHaibing <yuehaibing@huawei.com>, Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 5.2 50/85] kernel/module: Fix mem leak in module_add_modinfo_attrs
Date:   Wed, 18 Sep 2019 08:19:08 +0200
Message-Id: <20190918061235.708547112@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit bc6f2a757d525e001268c3658bd88822e768f8db upstream.

In module_add_modinfo_attrs if sysfs_create_file
fails, we forget to free allocated modinfo_attrs
and roll back the sysfs files.

Fixes: 03e88ae1b13d ("[PATCH] fix module sysfs files reference counting")
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/module.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1697,6 +1697,8 @@ static int add_usage_links(struct module
 	return ret;
 }
 
+static void module_remove_modinfo_attrs(struct module *mod, int end);
+
 static int module_add_modinfo_attrs(struct module *mod)
 {
 	struct module_attribute *attr;
@@ -1711,24 +1713,34 @@ static int module_add_modinfo_attrs(stru
 		return -ENOMEM;
 
 	temp_attr = mod->modinfo_attrs;
-	for (i = 0; (attr = modinfo_attrs[i]) && !error; i++) {
+	for (i = 0; (attr = modinfo_attrs[i]); i++) {
 		if (!attr->test || attr->test(mod)) {
 			memcpy(temp_attr, attr, sizeof(*temp_attr));
 			sysfs_attr_init(&temp_attr->attr);
 			error = sysfs_create_file(&mod->mkobj.kobj,
 					&temp_attr->attr);
+			if (error)
+				goto error_out;
 			++temp_attr;
 		}
 	}
+
+	return 0;
+
+error_out:
+	if (i > 0)
+		module_remove_modinfo_attrs(mod, --i);
 	return error;
 }
 
-static void module_remove_modinfo_attrs(struct module *mod)
+static void module_remove_modinfo_attrs(struct module *mod, int end)
 {
 	struct module_attribute *attr;
 	int i;
 
 	for (i = 0; (attr = &mod->modinfo_attrs[i]); i++) {
+		if (end >= 0 && i > end)
+			break;
 		/* pick a field to test for end of list */
 		if (!attr->attr.name)
 			break;
@@ -1816,7 +1828,7 @@ static int mod_sysfs_setup(struct module
 	return 0;
 
 out_unreg_modinfo_attrs:
-	module_remove_modinfo_attrs(mod);
+	module_remove_modinfo_attrs(mod, -1);
 out_unreg_param:
 	module_param_sysfs_remove(mod);
 out_unreg_holders:
@@ -1852,7 +1864,7 @@ static void mod_sysfs_fini(struct module
 {
 }
 
-static void module_remove_modinfo_attrs(struct module *mod)
+static void module_remove_modinfo_attrs(struct module *mod, int end)
 {
 }
 
@@ -1868,7 +1880,7 @@ static void init_param_lock(struct modul
 static void mod_sysfs_teardown(struct module *mod)
 {
 	del_usage_links(mod);
-	module_remove_modinfo_attrs(mod);
+	module_remove_modinfo_attrs(mod, -1);
 	module_param_sysfs_remove(mod);
 	kobject_put(mod->mkobj.drivers_dir);
 	kobject_put(mod->holders_dir);


