Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 388C67463B
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391026AbfGYFnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:43:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388270AbfGYFn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:43:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2E2021880;
        Thu, 25 Jul 2019 05:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033407;
        bh=zLIwCV3bZJFt+2RD7eslQ+avPYOsOC0b7t91Wty7k8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRMgPVYzHnjEWb/RjdCfrM8stTZGUa8pDg/7qkpI2zWcUiFdHiA7qM5FtADzNSLtV
         +R+rwgWvtYwsBDQCwjDAD5EOX/UqSFoa2aFfLxCkiCHfFrulcxBf8nWbcrjVm8rt6R
         q8yE1dtJcjcSK1HyRTZ1Z4zpAu6d/c9ZE+Y6vKC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 4.19 196/271] iwlwifi: pcie: fix ALIVE interrupt handling for gen2 devices w/o MSI-X
Date:   Wed, 24 Jul 2019 21:21:05 +0200
Message-Id: <20190724191711.894066148@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit ec46ae30245ecb41d73f8254613db07c653fb498 upstream.

We added code to restock the buffer upon ALIVE interrupt
when MSI-X is disabled. This was added as part of the context
info code. This code was added only if the ISR debug level
is set which is very unlikely to be related.
Move this code to run even when the ISR debug level is not
set.

Note that gen2 devices work with MSI-X in most cases so that
this path is seldom used.

Cc: stable@vger.kernel.org
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c |   34 ++++++++++++---------------
 1 file changed, 16 insertions(+), 18 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1778,25 +1778,23 @@ irqreturn_t iwl_pcie_irq_handler(int irq
 		goto out;
 	}
 
-	if (iwl_have_debug_level(IWL_DL_ISR)) {
-		/* NIC fires this, but we don't use it, redundant with WAKEUP */
-		if (inta & CSR_INT_BIT_SCD) {
-			IWL_DEBUG_ISR(trans,
-				      "Scheduler finished to transmit the frame/frames.\n");
-			isr_stats->sch++;
-		}
+	/* NIC fires this, but we don't use it, redundant with WAKEUP */
+	if (inta & CSR_INT_BIT_SCD) {
+		IWL_DEBUG_ISR(trans,
+			      "Scheduler finished to transmit the frame/frames.\n");
+		isr_stats->sch++;
+	}
 
-		/* Alive notification via Rx interrupt will do the real work */
-		if (inta & CSR_INT_BIT_ALIVE) {
-			IWL_DEBUG_ISR(trans, "Alive interrupt\n");
-			isr_stats->alive++;
-			if (trans->cfg->gen2) {
-				/*
-				 * We can restock, since firmware configured
-				 * the RFH
-				 */
-				iwl_pcie_rxmq_restock(trans, trans_pcie->rxq);
-			}
+	/* Alive notification via Rx interrupt will do the real work */
+	if (inta & CSR_INT_BIT_ALIVE) {
+		IWL_DEBUG_ISR(trans, "Alive interrupt\n");
+		isr_stats->alive++;
+		if (trans->cfg->gen2) {
+			/*
+			 * We can restock, since firmware configured
+			 * the RFH
+			 */
+			iwl_pcie_rxmq_restock(trans, trans_pcie->rxq);
 		}
 	}
 


