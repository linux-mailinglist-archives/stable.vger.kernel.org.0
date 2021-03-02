Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3249232AFCB
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239084AbhCCA2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:28:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:50742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383907AbhCBMcs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:32:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6A7F64F41;
        Tue,  2 Mar 2021 11:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686190;
        bh=38D3J8FLIRGFAsRoxpxp1VThzkM0HObSRrfrFVgjVag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKkjZNdHJoCBVqosdov+8udFpKV3tBd4gaxSu+FsGNepOlk5DvGIOO4RNey3m8n1p
         o2dP+yUjpeEIMrTDsCBfJpSK+hC2ylacA1xg6pTqp63xEZKSm4k8km9p0+yqT0mwtK
         y5IHWLmUdIajGpHkQNfbgmakn+EQcG4FuMb/I2IYcAhB0/ZMVo45WOc8NeiG+F9uDE
         ZHy29EX3hpNTDxCEcVj6mMkApqRTafNkowI926Rzn379ET2ZS6zpzUV2oTvPk7wPD2
         EtYWh4vU4uSGvkMcDDtxf6qp60pbgXAiQRrI1NiVXfT6bkL24MA71k3n9cB8hDJzOG
         1p+oxr510niUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>,
        Hinko Kocevar <hinko.kocevar@ess.eu>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sean V Kelley <sean.v.kelley@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 43/52] PCI/ERR: Retain status from error notification
Date:   Tue,  2 Mar 2021 06:55:24 -0500
Message-Id: <20210302115534.61800-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115534.61800-1-sashal@kernel.org>
References: <20210302115534.61800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 387c72cdd7fb6bef650fb078d0f6ae9682abf631 ]

Overwriting the frozen detected status with the result of the link reset
loses the NEED_RESET result that drivers are depending on for error
handling to report the .slot_reset() callback. Retain this status so
that subsequent error handling has the correct flow.

Link: https://lore.kernel.org/r/20210104230300.1277180-4-kbusch@kernel.org
Reported-by: Hinko Kocevar <hinko.kocevar@ess.eu>
Tested-by: Hedi Berriche <hedi.berriche@hpe.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Sean V Kelley <sean.v.kelley@intel.com>
Acked-by: Hedi Berriche <hedi.berriche@hpe.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/err.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
index 510f31f0ef6d..4798bd6de97d 100644
--- a/drivers/pci/pcie/err.c
+++ b/drivers/pci/pcie/err.c
@@ -198,8 +198,7 @@ pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
 	pci_dbg(bridge, "broadcast error_detected message\n");
 	if (state == pci_channel_io_frozen) {
 		pci_walk_bridge(bridge, report_frozen_detected, &status);
-		status = reset_subordinates(bridge);
-		if (status != PCI_ERS_RESULT_RECOVERED) {
+		if (reset_subordinates(bridge) != PCI_ERS_RESULT_RECOVERED) {
 			pci_warn(bridge, "subordinate device reset failed\n");
 			goto failed;
 		}
-- 
2.30.1

