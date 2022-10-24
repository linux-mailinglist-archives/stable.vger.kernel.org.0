Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915EF60B841
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbiJXTnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbiJXTmB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:42:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214BAA3AAE;
        Mon, 24 Oct 2022 11:11:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F4BEB817AE;
        Mon, 24 Oct 2022 12:51:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D10C433D6;
        Mon, 24 Oct 2022 12:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615894;
        bh=nrC9Dr2wMV1BAeXVmJ883+viaAmTBePwL4hWr+ZTiAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1gtJE6h/6eJEzXg4GlzM5Zpn+CQGFeYhCFhm/uOT9iVNeh0zrG5LErGZHuuXdWyPV
         IhdLo0xCE9CzwZg3Rl3bNi/wKoeLlhdV6Ytq+1qt2kknszmUhYIUl72fd+3WSGTdy2
         BBUvF7wHkZHMRONGsLMCnjFF+CaIY0hQJUxt/C6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jane Chu <jane.chu@oracle.com>,
        Borislav Petkov <bp@suse.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 422/530] x86/mce: Retrieve poison range from hardware
Date:   Mon, 24 Oct 2022 13:32:46 +0200
Message-Id: <20221024113104.198125757@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



