Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00FC03D55E8
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 10:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbhGZIMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 04:12:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232019AbhGZIMt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 04:12:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE1EF60F21;
        Mon, 26 Jul 2021 08:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627289598;
        bh=9tDSGzumtlADcErJ6KQY9vLU6T9f/7Lck+i07Kj3OaQ=;
        h=Subject:To:Cc:From:Date:From;
        b=N7ibLfoDl6EZdhO3/boxKZF0UcV53yJjL6hJSUK5I264682wvsRMVOUzb37V90qfC
         kfWSRPHw/5Q1M8xqjoMCxkyJIcV315o+dg8c0k9FHhWEB75p/q7AtABg6AtYru81Vq
         tJN8cVUjfV1tyI/qwsi1qnE1E272bdZu+x3D5jrc=
Subject: FAILED: patch "[PATCH] bus: mhi: pci_generic: Fix inbound IPCR channel" failed to apply to 5.10-stable tree
To:     loic.poulain@linaro.org, gregkh@linuxfoundation.org,
        hemantk@codeaurora.org, mani@kernel.org,
        manivannan.sadhasivam@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 26 Jul 2021 10:48:10 +0200
Message-ID: <1627289290254126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b8a97f2a65388394f433bf0730293a94f7d49046 Mon Sep 17 00:00:00 2001
From: Loic Poulain <loic.poulain@linaro.org>
Date: Fri, 16 Jul 2021 13:21:06 +0530
Subject: [PATCH] bus: mhi: pci_generic: Fix inbound IPCR channel

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

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index 3396cb30ebec..4dd1077354af 100644
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
@@ -213,7 +229,7 @@ static const struct mhi_channel_config modem_qcom_v1_mhi_channels[] = {
 	MHI_CHANNEL_CONFIG_UL(14, "QMI", 4, 0),
 	MHI_CHANNEL_CONFIG_DL(15, "QMI", 4, 0),
 	MHI_CHANNEL_CONFIG_UL(20, "IPCR", 8, 0),
-	MHI_CHANNEL_CONFIG_DL(21, "IPCR", 8, 0),
+	MHI_CHANNEL_CONFIG_DL_AUTOQUEUE(21, "IPCR", 8, 0),
 	MHI_CHANNEL_CONFIG_UL_FP(34, "FIREHOSE", 32, 0),
 	MHI_CHANNEL_CONFIG_DL_FP(35, "FIREHOSE", 32, 0),
 	MHI_CHANNEL_CONFIG_HW_UL(100, "IP_HW0", 128, 2),

