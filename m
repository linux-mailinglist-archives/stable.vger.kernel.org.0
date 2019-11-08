Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E886F55CB
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391069AbfKHTEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:04:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391066AbfKHTEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:04:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10A1B20650;
        Fri,  8 Nov 2019 19:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239883;
        bh=1Xi4C8BHtyWqVSzTXqvV4jzH3vajRRFBRAa8ig1ix9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPMIAWCOEgE9HuoriSh6MEuknePqlXNbkFfBL1H14zLHAvlW42//V0lzteoQ9+GWO
         0+tapRVFlEf+Wkau1Vpaf+olyB5usVfTuZd1OML0D4tHQrt6RWHWPTIjk2JV7csKCd
         xJwtXDEpxPQ58t6oXrvkBMg8OiD7VHD0/5hurA70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 015/140] ASoC: SOF: Intel: initialise and verify FW crash dump data.
Date:   Fri,  8 Nov 2019 19:49:03 +0100
Message-Id: <20191108174903.096215652@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liam Girdwood <liam.r.girdwood@linux.intel.com>

[ Upstream commit ff2be865633e6fa523cd2db3b73197d795dec991 ]

FW mailbox offset was not set before use and HDR size was not validated.
Fix this.

Signed-off-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190927200538.660-12-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/bdw.c | 7 +++++++
 sound/soc/sof/intel/byt.c | 6 ++++++
 sound/soc/sof/intel/hda.c | 7 +++++++
 3 files changed, 20 insertions(+)

diff --git a/sound/soc/sof/intel/bdw.c b/sound/soc/sof/intel/bdw.c
index 70d524ef9bc07..0ca3c1b55eeb1 100644
--- a/sound/soc/sof/intel/bdw.c
+++ b/sound/soc/sof/intel/bdw.c
@@ -37,6 +37,7 @@
 #define MBOX_SIZE       0x1000
 #define MBOX_DUMP_SIZE 0x30
 #define EXCEPT_OFFSET	0x800
+#define EXCEPT_MAX_HDR_SIZE	0x400
 
 /* DSP peripherals */
 #define DMAC0_OFFSET    0xFE000
@@ -228,6 +229,11 @@ static void bdw_get_registers(struct snd_sof_dev *sdev,
 	/* note: variable AR register array is not read */
 
 	/* then get panic info */
+	if (xoops->arch_hdr.totalsize > EXCEPT_MAX_HDR_SIZE) {
+		dev_err(sdev->dev, "invalid header size 0x%x. FW oops is bogus\n",
+			xoops->arch_hdr.totalsize);
+		return;
+	}
 	offset += xoops->arch_hdr.totalsize;
 	sof_mailbox_read(sdev, offset, panic_info, sizeof(*panic_info));
 
@@ -588,6 +594,7 @@ static int bdw_probe(struct snd_sof_dev *sdev)
 	/* TODO: add offsets */
 	sdev->mmio_bar = BDW_DSP_BAR;
 	sdev->mailbox_bar = BDW_DSP_BAR;
+	sdev->dsp_oops_offset = MBOX_OFFSET;
 
 	/* PCI base */
 	mmio = platform_get_resource(pdev, IORESOURCE_MEM,
diff --git a/sound/soc/sof/intel/byt.c b/sound/soc/sof/intel/byt.c
index 107d711efc3f0..96faaa8fa5a3a 100644
--- a/sound/soc/sof/intel/byt.c
+++ b/sound/soc/sof/intel/byt.c
@@ -28,6 +28,7 @@
 #define MBOX_OFFSET		0x144000
 #define MBOX_SIZE		0x1000
 #define EXCEPT_OFFSET		0x800
+#define EXCEPT_MAX_HDR_SIZE	0x400
 
 /* DSP peripherals */
 #define DMAC0_OFFSET		0x098000
@@ -273,6 +274,11 @@ static void byt_get_registers(struct snd_sof_dev *sdev,
 	/* note: variable AR register array is not read */
 
 	/* then get panic info */
+	if (xoops->arch_hdr.totalsize > EXCEPT_MAX_HDR_SIZE) {
+		dev_err(sdev->dev, "invalid header size 0x%x. FW oops is bogus\n",
+			xoops->arch_hdr.totalsize);
+		return;
+	}
 	offset += xoops->arch_hdr.totalsize;
 	sof_mailbox_read(sdev, offset, panic_info, sizeof(*panic_info));
 
diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 7f665392618f6..f2d45d62dfa56 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -37,6 +37,8 @@
 #define IS_CFL(pci) ((pci)->vendor == 0x8086 && (pci)->device == 0xa348)
 #define IS_CNL(pci) ((pci)->vendor == 0x8086 && (pci)->device == 0x9dc8)
 
+#define EXCEPT_MAX_HDR_SIZE	0x400
+
 /*
  * Debug
  */
@@ -121,6 +123,11 @@ static void hda_dsp_get_registers(struct snd_sof_dev *sdev,
 	/* note: variable AR register array is not read */
 
 	/* then get panic info */
+	if (xoops->arch_hdr.totalsize > EXCEPT_MAX_HDR_SIZE) {
+		dev_err(sdev->dev, "invalid header size 0x%x. FW oops is bogus\n",
+			xoops->arch_hdr.totalsize);
+		return;
+	}
 	offset += xoops->arch_hdr.totalsize;
 	sof_block_read(sdev, sdev->mmio_bar, offset,
 		       panic_info, sizeof(*panic_info));
-- 
2.20.1



