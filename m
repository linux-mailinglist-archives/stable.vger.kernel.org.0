Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16CD23A68A
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbgHCMYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:24:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgHCMYL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:24:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 218C920829;
        Mon,  3 Aug 2020 12:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457444;
        bh=EODeaBupaQIBpukJAkUzXaEpgdiYn49P6L2ybRD1oQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f0B3O2dKjSFbdritV0wZuuQDwEPic12I5oU5vdMo20rAIQRQSKFZ7eSJYBDjuyUw8
         h3IK+J15ESHf8N/AgVFxtuPt3RYgq5SZr09Ig+izR2QMbx0Dty1SbnmZ2w7ZU/Y5H/
         nkVGMyCjwNi0uNkgfz4Emg9uS1FtzMqitHQEAYio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Brunberg <ingo_brunberg@web.de>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 070/120] nvme: add a Identify Namespace Identification Descriptor list quirk
Date:   Mon,  3 Aug 2020 14:18:48 +0200
Message-Id: <20200803121906.209715440@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 5bedd3afee8eb01ccd256f0cd2cc0fa6f841417a ]

Add a quirk for a device that does not support the Identify Namespace
Identification Descriptor list despite claiming 1.3 compliance.

Fixes: ea43d9709f72 ("nvme: fix identify error status silent ignore")
Reported-by: Ingo Brunberg <ingo_brunberg@web.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Ingo Brunberg <ingo_brunberg@web.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 15 +++------------
 drivers/nvme/host/nvme.h |  7 +++++++
 drivers/nvme/host/pci.c  |  2 ++
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 137d7bcc13585..f7540a9e54fd2 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1106,6 +1106,9 @@ static int nvme_identify_ns_descs(struct nvme_ctrl *ctrl, unsigned nsid,
 	int pos;
 	int len;
 
+	if (ctrl->quirks & NVME_QUIRK_NO_NS_DESC_LIST)
+		return 0;
+
 	c.identify.opcode = nvme_admin_identify;
 	c.identify.nsid = cpu_to_le32(nsid);
 	c.identify.cns = NVME_ID_CNS_NS_DESC_LIST;
@@ -1119,18 +1122,6 @@ static int nvme_identify_ns_descs(struct nvme_ctrl *ctrl, unsigned nsid,
 	if (status) {
 		dev_warn(ctrl->device,
 			"Identify Descriptors failed (%d)\n", status);
-		 /*
-		  * Don't treat non-retryable errors as fatal, as we potentially
-		  * already have a NGUID or EUI-64.  If we failed with DNR set,
-		  * we want to silently ignore the error as we can still
-		  * identify the device, but if the status has DNR set, we want
-		  * to propagate the error back specifically for the disk
-		  * revalidation flow to make sure we don't abandon the
-		  * device just because of a temporal retry-able error (such
-		  * as path of transport errors).
-		  */
-		if (status > 0 && (status & NVME_SC_DNR))
-			status = 0;
 		goto free_data;
 	}
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 46f965f8c9bcd..8f1b0a30fd2a6 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -126,6 +126,13 @@ enum nvme_quirks {
 	 * Don't change the value of the temperature threshold feature
 	 */
 	NVME_QUIRK_NO_TEMP_THRESH_CHANGE	= (1 << 14),
+
+	/*
+	 * The controller doesn't handle the Identify Namespace
+	 * Identification Descriptor list subcommand despite claiming
+	 * NVMe 1.3 compliance.
+	 */
+	NVME_QUIRK_NO_NS_DESC_LIST		= (1 << 15),
 };
 
 /*
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 4ad629eb3bc66..10d65f27879fd 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3105,6 +3105,8 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_VDEVICE(INTEL, 0x5845),	/* Qemu emulated controller */
 		.driver_data = NVME_QUIRK_IDENTIFY_CNS |
 				NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x126f, 0x2263),	/* Silicon Motion unidentified */
+		.driver_data = NVME_QUIRK_NO_NS_DESC_LIST, },
 	{ PCI_DEVICE(0x1bb1, 0x0100),   /* Seagate Nytro Flash Storage */
 		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY, },
 	{ PCI_DEVICE(0x1c58, 0x0003),	/* HGST adapter */
-- 
2.25.1



