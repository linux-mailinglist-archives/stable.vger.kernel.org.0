Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7831C82D10
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 09:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730952AbfHFHqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 03:46:55 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4180 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726834AbfHFHqz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 03:46:55 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id DEBA29780E0F6E8C051A;
        Tue,  6 Aug 2019 15:46:43 +0800 (CST)
Received: from use12-sp2.huawei.com (10.67.189.177) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Tue, 6 Aug 2019 15:46:35 +0800
From:   chenzefeng <chenzefeng2@huawei.com>
To:     <tony.luck@intel.com>, <fenghua.yu@intel.com>,
        <chenzefeng2@huawei.com>
CC:     <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH] ia64:unwind: fix double free for mod->arch.init_unw_table
Date:   Tue, 6 Aug 2019 15:46:33 +0800
Message-ID: <1565077593-72480-1-git-send-email-chenzefeng2@huawei.com>
X-Mailer: git-send-email 1.8.5.6
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.189.177]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The function free_module in file kernel/module.c as follow:

void free_module(struct module *mod) {
	......
	module_arch_cleanup(mod);
	......
	module_arch_freeing_init(mod);
	......
}

Both module_arch_cleanup and module_arch_freeing_init function
would free the mod->arch.init_unw_table, which cause double free.

Here, set mod->arch.init_unw_table = NULL after remove the unwind
table to avoid double free.

Signed-off-by: chenzefeng <chenzefeng2@huawei.com>
---
 arch/ia64/kernel/module.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/module.c b/arch/ia64/kernel/module.c
index 326448f..1a42ba8 100644
--- a/arch/ia64/kernel/module.c
+++ b/arch/ia64/kernel/module.c
@@ -914,10 +914,14 @@ struct plt_entry {
 void
 module_arch_cleanup (struct module *mod)
 {
-	if (mod->arch.init_unw_table)
+	if (mod->arch.init_unw_table) {
 		unw_remove_unwind_table(mod->arch.init_unw_table);
-	if (mod->arch.core_unw_table)
+		mod->arch.init_unw_table = NULL;
+	}
+	if (mod->arch.core_unw_table) {
 		unw_remove_unwind_table(mod->arch.core_unw_table);
+		mod->arch.core_unw_table = NULL;
+	}
 }
 
 void *dereference_module_function_descriptor(struct module *mod, void *ptr)
-- 
1.8.5.6

