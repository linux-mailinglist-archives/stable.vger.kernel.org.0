Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98223311461
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhBEWFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:05:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:44976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232929AbhBEO5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:57:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB11164E2E;
        Fri,  5 Feb 2021 14:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534276;
        bh=WitU+AQ52xquQh8NwEkFztfaVuHRXAQtbpcpl/piX3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAyAVRtBQHGcZWvQj0k3XlDHMXp7YdM7ecrbMRRI2/DKcOEiapQT+dkhwjdh2PDFX
         IZW8JpFYbAwWoFq+MZ23g1vLM85WD/GlM4wqsk30PJ3BDj+CVC/L7m07VDA1sisVy1
         PysqLiMjhdMNU90CdIBBszjrIXwGt9FCJVfdwmsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ofir Bitton <obitton@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 51/57] habanalabs: zero pci counters packet before submit to FW
Date:   Fri,  5 Feb 2021 15:07:17 +0100
Message-Id: <20210205140658.171836974@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ofir Bitton <obitton@habana.ai>

[ Upstream commit 9354f1b421f76f8368be13954f87d07bcbd6fffe ]

Driver does not zero some pci counters packets before sending
to FW. This causes an out of sync PI/CI between driver and FW.

Signed-off-by: Ofir Bitton <obitton@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/firmware_if.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/misc/habanalabs/common/firmware_if.c b/drivers/misc/habanalabs/common/firmware_if.c
index cd41c7ceb0e78..13c6eebd4fa63 100644
--- a/drivers/misc/habanalabs/common/firmware_if.c
+++ b/drivers/misc/habanalabs/common/firmware_if.c
@@ -385,6 +385,10 @@ int hl_fw_cpucp_pci_counters_get(struct hl_device *hdev,
 	}
 	counters->rx_throughput = result;
 
+	memset(&pkt, 0, sizeof(pkt));
+	pkt.ctl = cpu_to_le32(CPUCP_PACKET_PCIE_THROUGHPUT_GET <<
+			CPUCP_PKT_CTL_OPCODE_SHIFT);
+
 	/* Fetch PCI tx counter */
 	pkt.index = cpu_to_le32(cpucp_pcie_throughput_tx);
 	rc = hdev->asic_funcs->send_cpu_message(hdev, (u32 *) &pkt, sizeof(pkt),
@@ -397,6 +401,7 @@ int hl_fw_cpucp_pci_counters_get(struct hl_device *hdev,
 	counters->tx_throughput = result;
 
 	/* Fetch PCI replay counter */
+	memset(&pkt, 0, sizeof(pkt));
 	pkt.ctl = cpu_to_le32(CPUCP_PACKET_PCIE_REPLAY_CNT_GET <<
 			CPUCP_PKT_CTL_OPCODE_SHIFT);
 
-- 
2.27.0



