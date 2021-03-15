Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB3333B97A
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbhCOOGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232387AbhCOOBV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 665F464F1A;
        Mon, 15 Mar 2021 14:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816838;
        bh=BoFeJl2b2IAlMXRiME3GRR8ptyLtIUx1y864mnsLlQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQlja6sbIDefNW+pCA5teZKvWDne0zLL5jcReDFhNODVd++arvCrPjTjp8sYwrm2W
         WAB4LV67ITzgo27IMPFOU3CISieqYC2EursVM1xm4HxmjGsT/J/EtJ+OoNuuZBUu6x
         k6uOhUOUOsI/Y16+RRuuKup9NNx2vVnkRtU1PCk4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hinko Kocevar <hinko.kocevar@ess.eu>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Keith Busch <kbusch@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sean V Kelley <sean.v.kelley@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 155/306] PCI/ERR: Retain status from error notification
Date:   Mon, 15 Mar 2021 14:53:38 +0100
Message-Id: <20210315135512.875485335@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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



