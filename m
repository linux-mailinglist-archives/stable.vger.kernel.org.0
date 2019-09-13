Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92E6FB1FFD
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388679AbfIMNNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:13:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388645AbfIMNNE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:13:04 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE94C217D6;
        Fri, 13 Sep 2019 13:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380383;
        bh=wGnVJVECeZwwfGaCkjL9W2Zddl6CZD5KF6azrXZMvJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sVzGM45oLZ+FtVS1NZmRkTUnlo1ny+TefQn9zGP48tUyKRCfD/K9Sdh1K38m2LADV
         Nr9JFHyest3su8ACDOpHVZOVaUv0Liyn71x13odNmVLpDNVJ6Mnqbr4JuQCZW4cinU
         ymq1eKaJ2Ci64uWbCb9PUzN1EzhIe9CWDTHLIK14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        YueHaibing <yuehaibing@huawei.com>, Jessica Yu <jeyu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 029/190] kernel/module: Fix mem leak in module_add_modinfo_attrs
Date:   Fri, 13 Sep 2019 14:04:44 +0100
Message-Id: <20190913130601.966396917@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bc6f2a757d525e001268c3658bd88822e768f8db ]

In module_add_modinfo_attrs if sysfs_create_file
fails, we forget to free allocated modinfo_attrs
and roll back the sysfs files.

Fixes: 03e88ae1b13d ("[PATCH] fix module sysfs files reference counting")
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 2dec3d4a9b627..0d86fc73d63d1 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1694,6 +1694,8 @@ static int add_usage_links(struct module *mod)
 	return ret;
 }
 
+static void module_remove_modinfo_attrs(struct module *mod, int end);
+
 static int module_add_modinfo_attrs(struct module *mod)
 {
 	struct module_attribute *attr;
@@ -1708,24 +1710,34 @@ static int module_add_modinfo_attrs(struct module *mod)
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
@@ -1813,7 +1825,7 @@ static int mod_sysfs_setup(struct module *mod,
 	return 0;
 
 out_unreg_modinfo_attrs:
-	module_remove_modinfo_attrs(mod);
+	module_remove_modinfo_attrs(mod, -1);
 out_unreg_param:
 	module_param_sysfs_remove(mod);
 out_unreg_holders:
@@ -1849,7 +1861,7 @@ static void mod_sysfs_fini(struct module *mod)
 {
 }
 
-static void module_remove_modinfo_attrs(struct module *mod)
+static void module_remove_modinfo_attrs(struct module *mod, int end)
 {
 }
 
@@ -1865,7 +1877,7 @@ static void init_param_lock(struct module *mod)
 static void mod_sysfs_teardown(struct module *mod)
 {
 	del_usage_links(mod);
-	module_remove_modinfo_attrs(mod);
+	module_remove_modinfo_attrs(mod, -1);
 	module_param_sysfs_remove(mod);
 	kobject_put(mod->mkobj.drivers_dir);
 	kobject_put(mod->holders_dir);
-- 
2.20.1



