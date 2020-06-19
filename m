Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652E8200D7A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390339AbgFSO6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390336AbgFSO6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:58:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7D5C217D8;
        Fri, 19 Jun 2020 14:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578681;
        bh=hAWr0Dq4DWCd3YCGURfNx79O6opztkOeSirdgo20uJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3ja+I+16wXzqfVrkd+EoPoxgpNcRAzU23rBOCzmtjQK1fhAXhsnJQHhdl3ePB0Ki
         ViFouc8hZXqquAsl9oBJt2iy4dcShMbbfyRN7RpEsD+BoLYd4ZsX7gqQWPaJx1OeRt
         ZWgzkLdqx0o3yElxR4mk0jdbbvdl3HUHUNVRjx/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Veerabhadrarao Badiganti <vbadigan@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 088/267] mmc: sdhci-msm: Clear tuning done flag while hs400 tuning
Date:   Fri, 19 Jun 2020 16:31:13 +0200
Message-Id: <20200619141653.095322399@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>

commit 9253d71011c349d5f5cc0cebdf68b4a80811b92d upstream.

Clear tuning_done flag while executing tuning to ensure vendor
specific HS400 settings are applied properly when the controller
is re-initialized in HS400 mode.

Without this, re-initialization of the qcom SDHC in HS400 mode fails
while resuming the driver from runtime-suspend or system-suspend.

Fixes: ff06ce417828 ("mmc: sdhci-msm: Add HS400 platform support")
Cc: stable@vger.kernel.org
Signed-off-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
Link: https://lore.kernel.org/r/1590678838-18099-1-git-send-email-vbadigan@codeaurora.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-msm.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1084,6 +1084,12 @@ static int sdhci_msm_execute_tuning(stru
 	msm_host->use_cdr = true;
 
 	/*
+	 * Clear tuning_done flag before tuning to ensure proper
+	 * HS400 settings.
+	 */
+	msm_host->tuning_done = 0;
+
+	/*
 	 * For HS400 tuning in HS200 timing requires:
 	 * - select MCLK/2 in VENDOR_SPEC
 	 * - program MCLK to 400MHz (or nearest supported) in GCC


