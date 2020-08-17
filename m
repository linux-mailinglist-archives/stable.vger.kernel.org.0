Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699FE2471C0
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391182AbgHQSdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:33:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730878AbgHQQAd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:00:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 626D720825;
        Mon, 17 Aug 2020 16:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680032;
        bh=rDcEdYxjJZyluEuB8xVxbN7YnV4MLWNg35y8ItRCF8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fBnwjf6TCE/9wRj3Mwu0V9tJLtpS5Wl/7GfB7NUq5grKGwIgtLLd83ghYfli7sGxA
         Dt0Tmabxxj3e78sCpq7xQkkVtwRkwkCxJD/Kwcw2CqlZtKH2q5d6ayNokCyU20b9x4
         szrn0/u6vKNoUYWeVa65i/5M4FzyyUGEs89E8nPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Brunberg <ingo_brunberg@web.de>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Plamen Lyutov <plamen.lyutov@gmail.com>
Subject: [PATCH 5.4 003/270] nvme: add a Identify Namespace Identification Descriptor list quirk
Date:   Mon, 17 Aug 2020 17:13:24 +0200
Message-Id: <20200817143755.983504045@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 5bedd3afee8eb01ccd256f0cd2cc0fa6f841417a upstream.

Add a quirk for a device that does not support the Identify Namespace
Identification Descriptor list despite claiming 1.3 compliance.

Fixes: ea43d9709f72 ("nvme: fix identify error status silent ignore")
Reported-by: Ingo Brunberg <ingo_brunberg@web.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Ingo Brunberg <ingo_brunberg@web.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Cc: Plamen Lyutov <plamen.lyutov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/core.c |   15 +++------------
 drivers/nvme/host/nvme.h |    7 +++++++
 drivers/nvme/host/pci.c  |    2 ++
 3 files changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1074,6 +1074,9 @@ static int nvme_identify_ns_descs(struct
 	int pos;
 	int len;
 
+	if (ctrl->quirks & NVME_QUIRK_NO_NS_DESC_LIST)
+		return 0;
+
 	c.identify.opcode = nvme_admin_identify;
 	c.identify.nsid = cpu_to_le32(nsid);
 	c.identify.cns = NVME_ID_CNS_NS_DESC_LIST;
@@ -1087,18 +1090,6 @@ static int nvme_identify_ns_descs(struct
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
 
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -115,6 +115,13 @@ enum nvme_quirks {
 	 * Prevent tag overlap between queues
 	 */
 	NVME_QUIRK_SHARED_TAGS                  = (1 << 13),
+
+	/*
+	 * The controller doesn't handle the Identify Namespace
+	 * Identification Descriptor list subcommand despite claiming
+	 * NVMe 1.3 compliance.
+	 */
+	NVME_QUIRK_NO_NS_DESC_LIST		= (1 << 15),
 };
 
 /*
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3117,6 +3117,8 @@ static const struct pci_device_id nvme_i
 	{ PCI_VDEVICE(INTEL, 0x5845),	/* Qemu emulated controller */
 		.driver_data = NVME_QUIRK_IDENTIFY_CNS |
 				NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x126f, 0x2263),	/* Silicon Motion unidentified */
+		.driver_data = NVME_QUIRK_NO_NS_DESC_LIST, },
 	{ PCI_DEVICE(0x1bb1, 0x0100),   /* Seagate Nytro Flash Storage */
 		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY, },
 	{ PCI_DEVICE(0x1c58, 0x0003),	/* HGST adapter */


