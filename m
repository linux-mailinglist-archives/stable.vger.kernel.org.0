Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302722014F9
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390980AbgFSQQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:16:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389893AbgFSPDN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:03:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 539BB21D6C;
        Fri, 19 Jun 2020 15:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578993;
        bh=eUehmMnJWi9gs9W/Ve5XycfW+f5pF8W4BZWeL9TVWbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aKBN+m9EVStAV8juqXBGi86jglBu+cw9jpPyF7M9EnUeEFbWIUmTLLsgDHeQu7mJe
         lWSazqDxaCbbDmMMWTfLp6/p3GTvKQRvU5Ho/Dd1cpQTXNZWbzgsf9jCWs1yJjN5DQ
         fGV8YY6n2ZyfW9/jjPKpz4mui9YzD14pN41e2QCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Blechmann <tim@klingt.org>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 218/267] ALSA: lx6464es - add support for LX6464ESe pci express variant
Date:   Fri, 19 Jun 2020 16:33:23 +0200
Message-Id: <20200619141659.178610450@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Blechmann <tim@klingt.org>

[ Upstream commit 789492f0c86505e63369907bcb1afdf52dec9366 ]

The pci express variant of the digigram lx6464es card has a different
device ID, but works without changes to the driver.
Thanks to Nikolas Slottke for reporting and testing.

Signed-off-by: Tim Blechmann <tim@klingt.org>
Link: https://lore.kernel.org/r/20190906082119.40971-1-tim@klingt.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pci_ids.h       | 2 ++
 sound/pci/lx6464es/lx6464es.c | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 81ddbd891202..bd682fcb9768 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1952,6 +1952,8 @@
 #define PCI_VENDOR_ID_DIGIGRAM		0x1369
 #define PCI_SUBDEVICE_ID_DIGIGRAM_LX6464ES_SERIAL_SUBSYSTEM	0xc001
 #define PCI_SUBDEVICE_ID_DIGIGRAM_LX6464ES_CAE_SERIAL_SUBSYSTEM	0xc002
+#define PCI_SUBDEVICE_ID_DIGIGRAM_LX6464ESE_SERIAL_SUBSYSTEM		0xc021
+#define PCI_SUBDEVICE_ID_DIGIGRAM_LX6464ESE_CAE_SERIAL_SUBSYSTEM	0xc022
 
 #define PCI_VENDOR_ID_KAWASAKI		0x136b
 #define PCI_DEVICE_ID_MCHIP_KL5A72002	0xff01
diff --git a/sound/pci/lx6464es/lx6464es.c b/sound/pci/lx6464es/lx6464es.c
index 54f6252faca6..daf25655f635 100644
--- a/sound/pci/lx6464es/lx6464es.c
+++ b/sound/pci/lx6464es/lx6464es.c
@@ -65,6 +65,14 @@ static const struct pci_device_id snd_lx6464es_ids[] = {
 			 PCI_VENDOR_ID_DIGIGRAM,
 			 PCI_SUBDEVICE_ID_DIGIGRAM_LX6464ES_CAE_SERIAL_SUBSYSTEM),
 	},			/* LX6464ES-CAE */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_LX6464ES,
+			 PCI_VENDOR_ID_DIGIGRAM,
+			 PCI_SUBDEVICE_ID_DIGIGRAM_LX6464ESE_SERIAL_SUBSYSTEM),
+	},			/* LX6464ESe */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_LX6464ES,
+			 PCI_VENDOR_ID_DIGIGRAM,
+			 PCI_SUBDEVICE_ID_DIGIGRAM_LX6464ESE_CAE_SERIAL_SUBSYSTEM),
+	},			/* LX6464ESe-CAE */
 	{ 0, },
 };
 
-- 
2.25.1



