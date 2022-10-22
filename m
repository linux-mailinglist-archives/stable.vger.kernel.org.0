Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662FD608902
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbiJVI1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233897AbiJVI1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:27:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06855D884;
        Sat, 22 Oct 2022 01:01:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03FA8B82E3A;
        Sat, 22 Oct 2022 08:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47592C433D7;
        Sat, 22 Oct 2022 08:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425629;
        bh=/LmuOibYq4SSvlEYG9tQkbKyOyx/DdrdHV6RwtqcukY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e91XYWv0pFF2EWHFRJpPF9k4iN2EpPywCtd9Ur7rcIRui/RvnyEctEaHUmoC3+WWQ
         cVFhMw8T9tF1HoufetMDtCJRyChleBKSOspPwn1nowglaYOS+wQrL08XHYKBjfmUWb
         OWTpKUhvn2Kbfy4xjFrHqTeUAvOkBXsALIXyziO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jane Chu <jane.chu@oracle.com>,
        Borislav Petkov <bp@suse.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 564/717] x86/mce: Retrieve poison range from hardware
Date:   Sat, 22 Oct 2022 09:27:23 +0200
Message-Id: <20221022072523.321590110@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 717192915f28..8ed341714686 100644
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



