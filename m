Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEE715C4C1
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388018AbgBMPuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:50:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:45638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387579AbgBMP03 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:29 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FDC124671;
        Thu, 13 Feb 2020 15:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607589;
        bh=YUGtBppluf/GNuwmwdxwwXdXPfgjPAuei32E0Qaw8oM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SK39BkWTEzAh89JtjKWg0rKByxi8GUyJpDyoMEouiQkHTAgC2HR9BI9DHCUTM1UNB
         nIxJL29/RlynCe4Crhtb//rclbnG9eZh8F+Nb11va7YX3l7nJQxE0WkuZQ6GLgzQxG
         VNqqZu6dUA+2LMqUsjCM73ckTlzCjhERAopyTdm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.19 09/52] ath10k: pci: Only dump ATH10K_MEM_REGION_TYPE_IOREG when safe
Date:   Thu, 13 Feb 2020 07:20:50 -0800
Message-Id: <20200213151814.650067469@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151810.331796857@linuxfoundation.org>
References: <20200213151810.331796857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit d239380196c4e27a26fa4bea73d2bf994c14ec2d upstream.

ath10k_pci_dump_memory_reg() will try to access memory of type
ATH10K_MEM_REGION_TYPE_IOREG however, if a hardware restart is in progress
this can crash a system.

Individual ioread32() time has been observed to jump from 15-20 ticks to >
80k ticks followed by a secure-watchdog bite and a system reset.

Work around this corner case by only issuing the read transaction when the
driver state is ATH10K_STATE_ON.

Tested-on: QCA9988 PCI 10.4-3.9.0.2-00044

Fixes: 219cc084c6706 ("ath10k: add memory dump support QCA9984")
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath10k/pci.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1613,11 +1613,22 @@ static int ath10k_pci_dump_memory_reg(st
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	u32 i;
+	int ret;
+
+	mutex_lock(&ar->conf_mutex);
+	if (ar->state != ATH10K_STATE_ON) {
+		ath10k_warn(ar, "Skipping pci_dump_memory_reg invalid state\n");
+		ret = -EIO;
+		goto done;
+	}
 
 	for (i = 0; i < region->len; i += 4)
 		*(u32 *)(buf + i) = ioread32(ar_pci->mem + region->start + i);
 
-	return region->len;
+	ret = region->len;
+done:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
 }
 
 /* if an error happened returns < 0, otherwise the length */
@@ -1713,7 +1724,11 @@ static void ath10k_pci_dump_memory(struc
 			count = ath10k_pci_dump_memory_sram(ar, current_region, buf);
 			break;
 		case ATH10K_MEM_REGION_TYPE_IOREG:
-			count = ath10k_pci_dump_memory_reg(ar, current_region, buf);
+			ret = ath10k_pci_dump_memory_reg(ar, current_region, buf);
+			if (ret < 0)
+				break;
+
+			count = ret;
 			break;
 		default:
 			ret = ath10k_pci_dump_memory_generic(ar, current_region, buf);


