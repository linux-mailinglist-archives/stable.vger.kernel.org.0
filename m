Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B531C451E
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730814AbgEDSMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:12:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731292AbgEDSCN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:02:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9B52206B8;
        Mon,  4 May 2020 18:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615333;
        bh=S3qVz86W9Zi3NKQ3uIhkmOHzINLqKzJQXU7d9JYSU3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQvgeTtJsa6brAdkcs8KubWb5Vt4cbiqI6g20uEImZBjSpJ0tENiQ01cJhwVuwFa6
         o5C9n7HkpiH9+LsE0V8onQimDDCGV0asMO3nWR4qbu87DzCebpez2VvrNozz/50skg
         Ux6uucRVQ3UlqQykMvc2M8GwKmbtaY10qsuR0QwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 34/37] mmc: sdhci-pci: Fix eMMC driver strength for BYT-based controllers
Date:   Mon,  4 May 2020 19:57:47 +0200
Message-Id: <20200504165451.689053478@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165448.264746645@linuxfoundation.org>
References: <20200504165448.264746645@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 1a8eb6b373c2af6533c13d1ea11f504e5010ed9a upstream.

BIOS writers have begun the practice of setting 40 ohm eMMC driver strength
even though the eMMC may not support it, on the assumption that the kernel
will validate the value against the eMMC (Extended CSD DRIVER_STRENGTH
[offset 197]) and revert to the default 50 ohm value if 40 ohm is invalid.

This is done to avoid changing the value for different boards.

Putting aside the merits of this approach, it is clear the eMMC's mask
of supported driver strengths is more reliable than the value provided
by BIOS. Add validation accordingly.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 51ced59cc02e ("mmc: sdhci-pci: Use ACPI DSM to get driver strength for some Intel devices")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200422111629.4899-1-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-pci-core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -556,6 +556,9 @@ static int intel_select_drive_strength(s
 	struct sdhci_pci_slot *slot = sdhci_priv(host);
 	struct intel_host *intel_host = sdhci_pci_priv(slot);
 
+	if (!(mmc_driver_type_mask(intel_host->drv_strength) & card_drv))
+		return 0;
+
 	return intel_host->drv_strength;
 }
 


