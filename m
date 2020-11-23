Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5BC2C08E0
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388276AbgKWNCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:02:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:36514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732795AbgKWMwi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:52:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3DC3204EF;
        Mon, 23 Nov 2020 12:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135943;
        bh=Ldy3hX7P9OkUp6SHI1zevMtPYGY+gkgEJAbM+IwMhAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KI2aDPHcQEpVRcUWNt6gUIUE2klEz55KDoxPArMG4GfXyrv2vDIh6vqW0lb/iyU19
         yd+tOwyYz//2zOkO25209Qvlu+clJPyxwCDjJFqmWDyLtFoO2Md8I/Fe/IV5ClehLe
         R1LrpZmHP3o+4nPqiPGqy60hlqnWeh1eOzd5q6CQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>,
        Manish Narani <manish.narani@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.9 243/252] mmc: sdhci-of-arasan: Issue DLL reset explicitly
Date:   Mon, 23 Nov 2020 13:23:13 +0100
Message-Id: <20201123121847.308585376@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Narani <manish.narani@xilinx.com>

commit d06d60d52ec0b0eef702dd3e7b4699f0b589ad0f upstream.

In the current implementation DLL reset will be issued for
each ITAP and OTAP setting inside ATF, this is creating issues
in some scenarios and this sequence is not inline with the TRM.
To fix the issue, DLL reset should be removed from the ATF and
host driver will request it explicitly.
This patch update host driver to explicitly request for DLL reset
before ITAP (assert DLL) and after OTAP (release DLL) settings.

Fixes: a5c8b2ae2e51 ("mmc: sdhci-of-arasan: Add support for ZynqMP Platform Tap Delays Setup")
Signed-off-by: Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
Signed-off-by: Manish Narani <manish.narani@xilinx.com>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1605515565-117562-4-git-send-email-manish.narani@xilinx.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-of-arasan.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -635,6 +635,9 @@ static int sdhci_zynqmp_sdcardclk_set_ph
 	if (ret)
 		pr_err("Error setting Output Tap Delay\n");
 
+	/* Release DLL Reset */
+	zynqmp_pm_sd_dll_reset(node_id, PM_DLL_RESET_RELEASE);
+
 	return ret;
 }
 
@@ -669,6 +672,9 @@ static int sdhci_zynqmp_sampleclk_set_ph
 	if (host->version < SDHCI_SPEC_300)
 		return 0;
 
+	/* Assert DLL Reset */
+	zynqmp_pm_sd_dll_reset(node_id, PM_DLL_RESET_ASSERT);
+
 	switch (host->timing) {
 	case MMC_TIMING_MMC_HS:
 	case MMC_TIMING_SD_HS:


