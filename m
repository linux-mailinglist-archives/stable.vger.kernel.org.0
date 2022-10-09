Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D795F916C
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 00:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbiJIWcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 18:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbiJIWaT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 18:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2DC12D1C;
        Sun,  9 Oct 2022 15:19:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6265C60C2B;
        Sun,  9 Oct 2022 22:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F72C4347C;
        Sun,  9 Oct 2022 22:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353985;
        bh=nrC9Dr2wMV1BAeXVmJ883+viaAmTBePwL4hWr+ZTiAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r+N5wzOt5yhD4nNk7VczxqDO8U0Eq/4vWV7Z/wnTZFjB3DrpgcWbj2P5naDbKWZ8/
         LlHACaBPh7owGPSIYngICbtM6aG5w+LeuGq5fxWipTY2xSxe2DZpS0pKBr/ybNKHLY
         y61anLNG4bQOCU8LzPgYaeUHl43RJ1MNFgpLnSu9kfL/95GQ30bKHi46aJNhwF0RTa
         bZsLT4mQ+0tme8uLD2+fVZT762D5UJTh3ukSEn/XaTWvzBYVt98kmiv0w2CqGr11NY
         kpkzq/44r8bJ27zbtfsRUCsW5MlK448luDZTVGw2oWOrH/gQvweq/gySUOX8MRc9l6
         BFkAFakr14OFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jane Chu <jane.chu@oracle.com>, Borislav Petkov <bp@suse.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        x86@kernel.org, linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/46] x86/mce: Retrieve poison range from hardware
Date:   Sun,  9 Oct 2022 18:18:36 -0400
Message-Id: <20221009221912.1217372-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221912.1217372-1-sashal@kernel.org>
References: <20221009221912.1217372-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jane Chu <jane.chu@oracle.com>

[ Upstream commit f9781bb18ed828e7b83b7bac4a4ad7cd497ee7d7 ]

When memory poison consumption machine checks fire, MCE notifier
handlers like nfit_handle_mce() record the impacted physical address
range which is reported by the hardware in the MCi_MISC MSR. The error
information includes data about blast radius, i.e. how many cachelines
did the hardware determine are impacted. A recent change

  7917f9cdb503 ("acpi/nfit: rely on mce->misc to determine poison granularity")

updated nfit_handle_mce() to stop hard coding the blast radius value of
1 cacheline, and instead rely on the blast radius reported in 'struct
mce' which can be up to 4K (64 cachelines).

It turns out that apei_mce_report_mem_error() had a similar problem in
that it hard coded a blast radius of 4K rather than reading the blast
radius from the error information. Fix apei_mce_report_mem_error() to
convey the proper poison granularity.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/7ed50fd8-521e-cade-77b1-738b8bfb8502@oracle.com
Link: https://lore.kernel.org/r/20220826233851.1319100-1-jane.chu@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/apei.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mce/apei.c b/arch/x86/kernel/cpu/mce/apei.c
index 0e3ae64d3b76..b08b90cdc2a3 100644
--- a/arch/x86/kernel/cpu/mce/apei.c
+++ b/arch/x86/kernel/cpu/mce/apei.c
@@ -29,15 +29,26 @@
 void apei_mce_report_mem_error(int severity, struct cper_sec_mem_err *mem_err)
 {
 	struct mce m;
+	int lsb;
 
 	if (!(mem_err->validation_bits & CPER_MEM_VALID_PA))
 		return;
 
+	/*
+	 * Even if the ->validation_bits are set for address mask,
+	 * to be extra safe, check and reject an error radius '0',
+	 * and fall back to the default page size.
+	 */
+	if (mem_err->validation_bits & CPER_MEM_VALID_PA_MASK)
+		lsb = find_first_bit((void *)&mem_err->physical_addr_mask, PAGE_SHIFT);
+	else
+		lsb = PAGE_SHIFT;
+
 	mce_setup(&m);
 	m.bank = -1;
 	/* Fake a memory read error with unknown channel */
 	m.status = MCI_STATUS_VAL | MCI_STATUS_EN | MCI_STATUS_ADDRV | MCI_STATUS_MISCV | 0x9f;
-	m.misc = (MCI_MISC_ADDR_PHYS << 6) | PAGE_SHIFT;
+	m.misc = (MCI_MISC_ADDR_PHYS << 6) | lsb;
 
 	if (severity >= GHES_SEV_RECOVERABLE)
 		m.status |= MCI_STATUS_UC;
-- 
2.35.1

