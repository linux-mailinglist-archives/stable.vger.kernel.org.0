Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58EE3D6293
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbhGZPgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:36:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237707AbhGZPgB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:36:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB20F60FC1;
        Mon, 26 Jul 2021 16:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316188;
        bh=NU/UYTw5csGX16z4Y0aEdc2v5/xMTL/7VmbglNmRjFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GzG0+gZ0fjKWYgAwNUlXlgSvg7HUmnAzn9DjwCzC3KEtLAp+IVqpCHRpGdLWx4cW9
         KMVovhThVsNjGH/KXawiUbZA0RWB4AK5pPTAt3mbt/uRW4FX0eqZC3r4SoS6FqoBK/
         12c04VSPhpicyYc+/1vKkdSJ15HeL3RK6xCnEP5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hemant kumar <hemantk@codeaurora.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.13 189/223] bus: mhi: pci_generic: Fix inbound IPCR channel
Date:   Mon, 26 Jul 2021 17:39:41 +0200
Message-Id: <20210726153852.383489674@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

commit b8a97f2a65388394f433bf0730293a94f7d49046 upstream.

The qrtr-mhi client driver assumes that inbound buffers are
automatically allocated and queued by the MHI core, but this
doesn't happen for mhi pci devices since IPCR inbound channel is
not flagged with auto_queue, causing unusable IPCR (qrtr)
feature. Fix that.

Link: https://lore.kernel.org/r/1625736749-24947-1-git-send-email-loic.poulain@linaro.org
[mani: fixed a spelling mistake in commit description]
Fixes: 855a70c12021 ("bus: mhi: Add MHI PCI support for WWAN modems")
Cc: stable@vger.kernel.org #5.10
Reviewed-by: Hemant kumar <hemantk@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20210716075106.49938-4-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/pci_generic.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -75,6 +75,22 @@ struct mhi_pci_dev_info {
 		.doorbell_mode_switch = false,		\
 	}
 
+#define MHI_CHANNEL_CONFIG_DL_AUTOQUEUE(ch_num, ch_name, el_count, ev_ring) \
+	{						\
+		.num = ch_num,				\
+		.name = ch_name,			\
+		.num_elements = el_count,		\
+		.event_ring = ev_ring,			\
+		.dir = DMA_FROM_DEVICE,			\
+		.ee_mask = BIT(MHI_EE_AMSS),		\
+		.pollcfg = 0,				\
+		.doorbell = MHI_DB_BRST_DISABLE,	\
+		.lpm_notify = false,			\
+		.offload_channel = false,		\
+		.doorbell_mode_switch = false,		\
+		.auto_queue = true,			\
+	}
+
 #define MHI_EVENT_CONFIG_CTRL(ev_ring, el_count) \
 	{					\
 		.num_elements = el_count,	\
@@ -213,7 +229,7 @@ static const struct mhi_channel_config m
 	MHI_CHANNEL_CONFIG_UL(14, "QMI", 4, 0),
 	MHI_CHANNEL_CONFIG_DL(15, "QMI", 4, 0),
 	MHI_CHANNEL_CONFIG_UL(20, "IPCR", 8, 0),
-	MHI_CHANNEL_CONFIG_DL(21, "IPCR", 8, 0),
+	MHI_CHANNEL_CONFIG_DL_AUTOQUEUE(21, "IPCR", 8, 0),
 	MHI_CHANNEL_CONFIG_UL_FP(34, "FIREHOSE", 32, 0),
 	MHI_CHANNEL_CONFIG_DL_FP(35, "FIREHOSE", 32, 0),
 	MHI_CHANNEL_CONFIG_HW_UL(100, "IP_HW0", 128, 2),


