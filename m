Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 640D383BA8
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbfHFVgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:36:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729152AbfHFVgy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:36:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 963EC2189E;
        Tue,  6 Aug 2019 21:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127413;
        bh=w7VoM9dlRLwwsMNsafTyy+k21ZS8rJ3tmOxOFAENC70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x2FNdFhsADpRKZPPkoZAgIqPlxVLk2UYggvPS1ub5eEslky4RBphqlR5o1nzEmpa+
         lcUM5uvExI8+Cr2+BzcfXBC6/XHB4Tu8DWzo8DpQ7rs0aaBxgS1KpiJa69NSh8qalx
         QhOO54rLcSpsigfFunXkNKKeoBiT0USyAHokJRNQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 16/25] arm64/efi: fix variable 'si' set but not used
Date:   Tue,  6 Aug 2019 17:36:13 -0400
Message-Id: <20190806213624.20194-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213624.20194-1-sashal@kernel.org>
References: <20190806213624.20194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit f1d4836201543e88ebe70237e67938168d5fab19 ]

GCC throws out this warning on arm64.

drivers/firmware/efi/libstub/arm-stub.c: In function 'efi_entry':
drivers/firmware/efi/libstub/arm-stub.c:132:22: warning: variable 'si'
set but not used [-Wunused-but-set-variable]

Fix it by making free_screen_info() a static inline function.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/efi.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 8389050328bba..5585420860694 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -89,7 +89,11 @@ static inline unsigned long efi_get_max_initrd_addr(unsigned long dram_base,
 	((protocol##_t *)instance)->f(instance, ##__VA_ARGS__)
 
 #define alloc_screen_info(x...)		&screen_info
-#define free_screen_info(x...)
+
+static inline void free_screen_info(efi_system_table_t *sys_table_arg,
+				    struct screen_info *si)
+{
+}
 
 /* redeclare as 'hidden' so the compiler will generate relative references */
 extern struct screen_info screen_info __attribute__((__visibility__("hidden")));
-- 
2.20.1

