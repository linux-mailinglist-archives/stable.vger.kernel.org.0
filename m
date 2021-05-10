Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F4C3783D0
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhEJKrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233228AbhEJKpX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:45:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26921619A0;
        Mon, 10 May 2021 10:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642927;
        bh=A1sqtSWQaf8zBLgegXJRFlueszPXuAONOOjH0VraFmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wfYHNFBq+v+5owhBvW5shLyVP/U5N+7kYb7BpE4Vm8xO/n45+ZXFCkF1d6WqXvdaq
         3Fj1Hin0BCPw/aKLbpvWc/EZCF9RnXvcK44zz0iX2Rchuz442iUxPb2ikCN/hox3Vq
         JMz+UDMvfxysMLLRBsScSBSw266FuYYczh2BbTrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "David E. Box" <david.e.box@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/299] platform/x86: intel_pmc_core: Dont use global pmcdev in quirks
Date:   Mon, 10 May 2021 12:18:25 +0200
Message-Id: <20210510102008.507160403@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David E. Box <david.e.box@linux.intel.com>

[ Upstream commit c9f86d6ca6b5e23d30d16ade4b9fff5b922a610a ]

The DMI callbacks, used for quirks, currently access the PMC by getting
the address a global pmc_dev struct. Instead, have the callbacks set a
global quirk specific variable. In probe, after calling dmi_check_system(),
pass pmc_dev to a function that will handle each quirk if its variable
condition is met. This allows removing the global pmc_dev later.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>
Link: https://lore.kernel.org/r/20210417031252.3020837-2-david.e.box@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_pmc_core.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/intel_pmc_core.c b/drivers/platform/x86/intel_pmc_core.c
index e06b36e87a33..ca32a4c80f62 100644
--- a/drivers/platform/x86/intel_pmc_core.c
+++ b/drivers/platform/x86/intel_pmc_core.c
@@ -1186,9 +1186,15 @@ static const struct pci_device_id pmc_pci_ids[] = {
  * the platform BIOS enforces 24Mhz crystal to shutdown
  * before PMC can assert SLP_S0#.
  */
+static bool xtal_ignore;
 static int quirk_xtal_ignore(const struct dmi_system_id *id)
 {
-	struct pmc_dev *pmcdev = &pmc;
+	xtal_ignore = true;
+	return 0;
+}
+
+static void pmc_core_xtal_ignore(struct pmc_dev *pmcdev)
+{
 	u32 value;
 
 	value = pmc_core_reg_read(pmcdev, pmcdev->map->pm_vric1_offset);
@@ -1197,7 +1203,6 @@ static int quirk_xtal_ignore(const struct dmi_system_id *id)
 	/* Low Voltage Mode Enable */
 	value &= ~SPT_PMC_VRIC1_SLPS0LVEN;
 	pmc_core_reg_write(pmcdev, pmcdev->map->pm_vric1_offset, value);
-	return 0;
 }
 
 static const struct dmi_system_id pmc_core_dmi_table[]  = {
@@ -1212,6 +1217,14 @@ static const struct dmi_system_id pmc_core_dmi_table[]  = {
 	{}
 };
 
+static void pmc_core_do_dmi_quirks(struct pmc_dev *pmcdev)
+{
+	dmi_check_system(pmc_core_dmi_table);
+
+	if (xtal_ignore)
+		pmc_core_xtal_ignore(pmcdev);
+}
+
 static int pmc_core_probe(struct platform_device *pdev)
 {
 	static bool device_initialized;
@@ -1253,7 +1266,7 @@ static int pmc_core_probe(struct platform_device *pdev)
 	mutex_init(&pmcdev->lock);
 	platform_set_drvdata(pdev, pmcdev);
 	pmcdev->pmc_xram_read_bit = pmc_core_check_read_lock_bit();
-	dmi_check_system(pmc_core_dmi_table);
+	pmc_core_do_dmi_quirks(pmcdev);
 
 	/*
 	 * On TGL, due to a hardware limitation, the GBE LTR blocks PC10 when
-- 
2.30.2



