Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE06150C67
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730766AbgBCQgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:36:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:51058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731097AbgBCQgA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:36:00 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 116062051A;
        Mon,  3 Feb 2020 16:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747759;
        bh=2qIIlsh03rP1AYU4QfAbfoGND10GSohEUembRPw97q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MP+VBs54OoYEV8baqBRcIJ8e7zS4KZT18bJKH/VIz3CO3uYQLQp5xWB9QJqmWD9Sk
         9cmKkHqjUX5zj6KKtI44oWAmsytMbiI051Casb7Y/kkiCEHcvMeTJWmDuFKCTJTb78
         T8mX8VWu5ntUuOC7NgsV+4ap7KHZBxUpEn7Vc9Vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 56/90] perf/x86/intel/uncore: Remove PCIe3 unit for SNR
Date:   Mon,  3 Feb 2020 16:19:59 +0000
Message-Id: <20200203161924.560277798@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 2167f1625c2f04a33145f325db0de285630f7bd1 ]

The PCIe Root Port driver for CPU Complex PCIe Root Ports are not
loaded on SNR.

The device ID for SNR PCIe3 unit is used by both uncore driver and the
PCIe Root Port driver. If uncore driver is loaded, the PCIe Root Port
driver never be probed.

Remove the PCIe3 unit for SNR for now. The support for PCIe3 unit will
be added later separately.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lkml.kernel.org/r/20200116200210.18937-2-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snbep.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 011644802ce78..ad20220af303a 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -369,11 +369,6 @@
 #define SNR_M2M_PCI_PMON_BOX_CTL		0x438
 #define SNR_M2M_PCI_PMON_UMASK_EXT		0xff
 
-/* SNR PCIE3 */
-#define SNR_PCIE3_PCI_PMON_CTL0			0x508
-#define SNR_PCIE3_PCI_PMON_CTR0			0x4e8
-#define SNR_PCIE3_PCI_PMON_BOX_CTL		0x4e4
-
 /* SNR IMC */
 #define SNR_IMC_MMIO_PMON_FIXED_CTL		0x54
 #define SNR_IMC_MMIO_PMON_FIXED_CTR		0x38
@@ -4328,27 +4323,12 @@ static struct intel_uncore_type snr_uncore_m2m = {
 	.format_group	= &snr_m2m_uncore_format_group,
 };
 
-static struct intel_uncore_type snr_uncore_pcie3 = {
-	.name		= "pcie3",
-	.num_counters	= 4,
-	.num_boxes	= 1,
-	.perf_ctr_bits	= 48,
-	.perf_ctr	= SNR_PCIE3_PCI_PMON_CTR0,
-	.event_ctl	= SNR_PCIE3_PCI_PMON_CTL0,
-	.event_mask	= SNBEP_PMON_RAW_EVENT_MASK,
-	.box_ctl	= SNR_PCIE3_PCI_PMON_BOX_CTL,
-	.ops		= &ivbep_uncore_pci_ops,
-	.format_group	= &ivbep_uncore_format_group,
-};
-
 enum {
 	SNR_PCI_UNCORE_M2M,
-	SNR_PCI_UNCORE_PCIE3,
 };
 
 static struct intel_uncore_type *snr_pci_uncores[] = {
 	[SNR_PCI_UNCORE_M2M]		= &snr_uncore_m2m,
-	[SNR_PCI_UNCORE_PCIE3]		= &snr_uncore_pcie3,
 	NULL,
 };
 
@@ -4357,10 +4337,6 @@ static const struct pci_device_id snr_uncore_pci_ids[] = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x344a),
 		.driver_data = UNCORE_PCI_DEV_FULL_DATA(12, 0, SNR_PCI_UNCORE_M2M, 0),
 	},
-	{ /* PCIe3 */
-		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x334a),
-		.driver_data = UNCORE_PCI_DEV_FULL_DATA(4, 0, SNR_PCI_UNCORE_PCIE3, 0),
-	},
 	{ /* end: all zeroes */ }
 };
 
-- 
2.20.1



