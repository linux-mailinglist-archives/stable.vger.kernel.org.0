Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064724915E1
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345875AbiARCcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245648AbiARC2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:28:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9084BC0617B0;
        Mon, 17 Jan 2022 18:25:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58608B8123D;
        Tue, 18 Jan 2022 02:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32129C36AF4;
        Tue, 18 Jan 2022 02:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472757;
        bh=6wrrJ7aDxIrQw2TbOvBal/FrCaDdQi8ycw415kthYKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=je4QrQsrEKDPLzYakPrGpBmdl4UYVsLUTUdlGc3CG+gHc32QcQ24BefcuJSkhJ289
         fUV6RduNKGPpYtPrXL93lVoHjZOUgB9fPO6x6EysjBdMojfzQauJFu0bMdZC/rKkqb
         Tmp8zkVfsVur0WagTb7Ivh/rl7Eo/r/T2OecWOg+j7GY/TtCgBLjS2q4IZna3bbCGu
         E+X4cByXx7pPBo89J+fkj+zmMsE+8d/wBLu0q7bzyM+r9Jj8cdjyRPDINnIzbgMV83
         w1f+sJH171JQuCau+E5+8KR/l3XR3eZCGqPGKgbWkRu0XrroXwCwOwCAM1GWHySw+4
         TVS8V4Buw3PbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 126/217] x86/mce: Mark mce_read_aux() noinstr
Date:   Mon, 17 Jan 2022 21:18:09 -0500
Message-Id: <20220118021940.1942199-126-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit db6c996d6ce45dfb44891f0824a65ecec216f47a ]

Fixes

  vmlinux.o: warning: objtool: do_machine_check()+0x681: call to mce_read_aux() leaves .noinstr.text section

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20211208111343.8130-10-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 75095986e5eff..69fd51a29278f 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -645,7 +645,7 @@ static struct notifier_block mce_default_nb = {
 /*
  * Read ADDR and MISC registers.
  */
-static void mce_read_aux(struct mce *m, int i)
+static noinstr void mce_read_aux(struct mce *m, int i)
 {
 	if (m->status & MCI_STATUS_MISCV)
 		m->misc = mce_rdmsrl(mca_msr_reg(i, MCA_MISC));
-- 
2.34.1

