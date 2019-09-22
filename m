Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCCABAB61
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389437AbfIVTiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:38:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389370AbfIVSph (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:45:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC3982186A;
        Sun, 22 Sep 2019 18:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177936;
        bh=NJLxmO+sPDzSi40Zm+6uwJ9bnxqS9Qk6TiNQiFwfxvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AyBahuBq9QU4pVtIf8i1p6k+DwBXOjHOwOCOZqVHcav99qpnqV1ET6RRoP/5NAaf+
         E3PRsnKIlm353qPmjiwWo8s6PVITYvn2nwCHSMDrtbpQ3a4fvkMygI3vxrNVQAiah1
         SZTfuO4y/HXxz7IFpioVRvHyvS8+16/NQUKz79Z4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     chenzefeng <chenzefeng2@huawei.com>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-ia64@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 046/203] ia64:unwind: fix double free for mod->arch.init_unw_table
Date:   Sun, 22 Sep 2019 14:41:12 -0400
Message-Id: <20190922184350.30563-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: chenzefeng <chenzefeng2@huawei.com>

[ Upstream commit c5e5c48c16422521d363c33cfb0dcf58f88c119b ]

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
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/ia64/kernel/module.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/module.c b/arch/ia64/kernel/module.c
index 326448f9df160..1a42ba885188a 100644
--- a/arch/ia64/kernel/module.c
+++ b/arch/ia64/kernel/module.c
@@ -914,10 +914,14 @@ module_finalize (const Elf_Ehdr *hdr, const Elf_Shdr *sechdrs, struct module *mo
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
2.20.1

