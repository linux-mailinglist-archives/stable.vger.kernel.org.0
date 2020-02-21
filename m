Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC32167819
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgBUHtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:49:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:46114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729359AbgBUHte (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:49:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D4D4222C4;
        Fri, 21 Feb 2020 07:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271373;
        bh=sedOC4hZMGE2g2i99HGX1ZfpSvh9kBm9p5Cv+cu1atc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kr2oWadv++V3vPW6tpbL35zMOrtLPVBalD3a8A4DP6jsG9UoXeT0G0TLHoa5PDkaL
         0wP+6edMl1nRzu3xYPdlpAiPKcrSxD1w2CNW3jsXboABcGaPjkkJ6MsCjS97mpMUsK
         EOCFxgFlCyr2qemsftf0DWOhUZ0puNibOYxWVGx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 114/399] ASoC: SOF: Intel: hda: solve MSI issues by merging ipc and stream irq handlers
Date:   Fri, 21 Feb 2020 08:37:19 +0100
Message-Id: <20200221072413.537539962@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 7c11af9fcdc425b80f140a218d4fef9f17734bfc ]

The existing code uses two handlers for a shared edge-based MSI interrupts.
In corner cases, interrupts are lost, leading to IPC timeouts. Those
timeouts do not appear in legacy mode.

This patch merges the two handlers and threads into a single one, and
simplifies the mask/unmask operations by using a single top-level mask
(Global Interrupt Enable). The handler only checks for interrupt
sources using the Global Interrupt Status (GIS) field, and all the
actual work happens in the thread. This also enables us to remove the
use of spin locks. Stream events are prioritized over IPC ones.

This patch was tested with HDaudio and SoundWire platforms, and all
known IPC timeout issues are solved in MSI mode. The
SoundWire-specific patches will be provided in follow-up patches,
where the SoundWire interrupts are handled in the same thread as IPC
and stream interrupts.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191204212859.13239-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/apl.c        |  1 -
 sound/soc/sof/intel/cnl.c        |  5 ---
 sound/soc/sof/intel/hda-ipc.c    | 23 +++--------
 sound/soc/sof/intel/hda-stream.c | 20 ++++-----
 sound/soc/sof/intel/hda.c        | 69 ++++++++++++++++++++++----------
 sound/soc/sof/intel/hda.h        | 11 ++---
 6 files changed, 70 insertions(+), 59 deletions(-)

diff --git a/sound/soc/sof/intel/apl.c b/sound/soc/sof/intel/apl.c
index 7daa8eb456c8d..6f45e14f2b2e3 100644
--- a/sound/soc/sof/intel/apl.c
+++ b/sound/soc/sof/intel/apl.c
@@ -41,7 +41,6 @@ const struct snd_sof_dsp_ops sof_apl_ops = {
 	.block_write	= sof_block_write,
 
 	/* doorbell */
-	.irq_handler	= hda_dsp_ipc_irq_handler,
 	.irq_thread	= hda_dsp_ipc_irq_thread,
 
 	/* ipc */
diff --git a/sound/soc/sof/intel/cnl.c b/sound/soc/sof/intel/cnl.c
index 0e1e265f3f3b3..9bd169e2691e2 100644
--- a/sound/soc/sof/intel/cnl.c
+++ b/sound/soc/sof/intel/cnl.c
@@ -106,10 +106,6 @@ static irqreturn_t cnl_ipc_irq_thread(int irq, void *context)
 				    "nothing to do in IPC IRQ thread\n");
 	}
 
-	/* re-enable IPC interrupt */
-	snd_sof_dsp_update_bits(sdev, HDA_DSP_BAR, HDA_DSP_REG_ADSPIC,
-				HDA_DSP_ADSPIC_IPC, HDA_DSP_ADSPIC_IPC);
-
 	return IRQ_HANDLED;
 }
 
@@ -231,7 +227,6 @@ const struct snd_sof_dsp_ops sof_cnl_ops = {
 	.block_write	= sof_block_write,
 
 	/* doorbell */
-	.irq_handler	= hda_dsp_ipc_irq_handler,
 	.irq_thread	= cnl_ipc_irq_thread,
 
 	/* ipc */
diff --git a/sound/soc/sof/intel/hda-ipc.c b/sound/soc/sof/intel/hda-ipc.c
index 0fd2153c17695..1837f66e361fd 100644
--- a/sound/soc/sof/intel/hda-ipc.c
+++ b/sound/soc/sof/intel/hda-ipc.c
@@ -230,22 +230,15 @@ irqreturn_t hda_dsp_ipc_irq_thread(int irq, void *context)
 				    "nothing to do in IPC IRQ thread\n");
 	}
 
-	/* re-enable IPC interrupt */
-	snd_sof_dsp_update_bits(sdev, HDA_DSP_BAR, HDA_DSP_REG_ADSPIC,
-				HDA_DSP_ADSPIC_IPC, HDA_DSP_ADSPIC_IPC);
-
 	return IRQ_HANDLED;
 }
 
-/* is this IRQ for ADSP ? - we only care about IPC here */
-irqreturn_t hda_dsp_ipc_irq_handler(int irq, void *context)
+/* Check if an IPC IRQ occurred */
+bool hda_dsp_check_ipc_irq(struct snd_sof_dev *sdev)
 {
-	struct snd_sof_dev *sdev = context;
-	int ret = IRQ_NONE;
+	bool ret = false;
 	u32 irq_status;
 
-	spin_lock(&sdev->hw_lock);
-
 	/* store status */
 	irq_status = snd_sof_dsp_read(sdev, HDA_DSP_BAR, HDA_DSP_REG_ADSPIS);
 	dev_vdbg(sdev->dev, "irq handler: irq_status:0x%x\n", irq_status);
@@ -255,16 +248,10 @@ irqreturn_t hda_dsp_ipc_irq_handler(int irq, void *context)
 		goto out;
 
 	/* IPC message ? */
-	if (irq_status & HDA_DSP_ADSPIS_IPC) {
-		/* disable IPC interrupt */
-		snd_sof_dsp_update_bits_unlocked(sdev, HDA_DSP_BAR,
-						 HDA_DSP_REG_ADSPIC,
-						 HDA_DSP_ADSPIC_IPC, 0);
-		ret = IRQ_WAKE_THREAD;
-	}
+	if (irq_status & HDA_DSP_ADSPIS_IPC)
+		ret = true;
 
 out:
-	spin_unlock(&sdev->hw_lock);
 	return ret;
 }
 
diff --git a/sound/soc/sof/intel/hda-stream.c b/sound/soc/sof/intel/hda-stream.c
index 29ab432816701..927a36f92c242 100644
--- a/sound/soc/sof/intel/hda-stream.c
+++ b/sound/soc/sof/intel/hda-stream.c
@@ -549,22 +549,23 @@ int hda_dsp_stream_hw_free(struct snd_sof_dev *sdev,
 	return 0;
 }
 
-irqreturn_t hda_dsp_stream_interrupt(int irq, void *context)
+bool hda_dsp_check_stream_irq(struct snd_sof_dev *sdev)
 {
-	struct hdac_bus *bus = context;
-	int ret = IRQ_WAKE_THREAD;
+	struct hdac_bus *bus = sof_to_bus(sdev);
+	bool ret = false;
 	u32 status;
 
-	spin_lock(&bus->reg_lock);
+	/* The function can be called at irq thread, so use spin_lock_irq */
+	spin_lock_irq(&bus->reg_lock);
 
 	status = snd_hdac_chip_readl(bus, INTSTS);
 	dev_vdbg(bus->dev, "stream irq, INTSTS status: 0x%x\n", status);
 
-	/* Register inaccessible, ignore it.*/
-	if (status == 0xffffffff)
-		ret = IRQ_NONE;
+	/* if Register inaccessible, ignore it.*/
+	if (status != 0xffffffff)
+		ret = true;
 
-	spin_unlock(&bus->reg_lock);
+	spin_unlock_irq(&bus->reg_lock);
 
 	return ret;
 }
@@ -602,7 +603,8 @@ static bool hda_dsp_stream_check(struct hdac_bus *bus, u32 status)
 
 irqreturn_t hda_dsp_stream_threaded_handler(int irq, void *context)
 {
-	struct hdac_bus *bus = context;
+	struct snd_sof_dev *sdev = context;
+	struct hdac_bus *bus = sof_to_bus(sdev);
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA)
 	u32 rirb_status;
 #endif
diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index fb17b87b684bf..82ecadda886c6 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -499,6 +499,49 @@ static const struct sof_intel_dsp_desc
 	return chip_info;
 }
 
+static irqreturn_t hda_dsp_interrupt_handler(int irq, void *context)
+{
+	struct snd_sof_dev *sdev = context;
+
+	/*
+	 * Get global interrupt status. It includes all hardware interrupt
+	 * sources in the Intel HD Audio controller.
+	 */
+	if (snd_sof_dsp_read(sdev, HDA_DSP_HDA_BAR, SOF_HDA_INTSTS) &
+	    SOF_HDA_INTSTS_GIS) {
+
+		/* disable GIE interrupt */
+		snd_sof_dsp_update_bits(sdev, HDA_DSP_HDA_BAR,
+					SOF_HDA_INTCTL,
+					SOF_HDA_INT_GLOBAL_EN,
+					0);
+
+		return IRQ_WAKE_THREAD;
+	}
+
+	return IRQ_NONE;
+}
+
+static irqreturn_t hda_dsp_interrupt_thread(int irq, void *context)
+{
+	struct snd_sof_dev *sdev = context;
+
+	/* deal with streams and controller first */
+	if (hda_dsp_check_stream_irq(sdev))
+		hda_dsp_stream_threaded_handler(irq, sdev);
+
+	if (hda_dsp_check_ipc_irq(sdev))
+		sof_ops(sdev)->irq_thread(irq, sdev);
+
+	/* enable GIE interrupt */
+	snd_sof_dsp_update_bits(sdev, HDA_DSP_HDA_BAR,
+				SOF_HDA_INTCTL,
+				SOF_HDA_INT_GLOBAL_EN,
+				SOF_HDA_INT_GLOBAL_EN);
+
+	return IRQ_HANDLED;
+}
+
 int hda_dsp_probe(struct snd_sof_dev *sdev)
 {
 	struct pci_dev *pci = to_pci_dev(sdev->dev);
@@ -603,9 +646,7 @@ int hda_dsp_probe(struct snd_sof_dev *sdev)
 	 */
 	if (hda_use_msi && pci_alloc_irq_vectors(pci, 1, 1, PCI_IRQ_MSI) > 0) {
 		dev_info(sdev->dev, "use msi interrupt mode\n");
-		hdev->irq = pci_irq_vector(pci, 0);
-		/* ipc irq number is the same of hda irq */
-		sdev->ipc_irq = hdev->irq;
+		sdev->ipc_irq = pci_irq_vector(pci, 0);
 		/* initialised to "false" by kzalloc() */
 		sdev->msi_enabled = true;
 	}
@@ -616,28 +657,17 @@ int hda_dsp_probe(struct snd_sof_dev *sdev)
 		 * in IO-APIC mode, hda->irq and ipc_irq are using the same
 		 * irq number of pci->irq
 		 */
-		hdev->irq = pci->irq;
 		sdev->ipc_irq = pci->irq;
 	}
 
-	dev_dbg(sdev->dev, "using HDA IRQ %d\n", hdev->irq);
-	ret = request_threaded_irq(hdev->irq, hda_dsp_stream_interrupt,
-				   hda_dsp_stream_threaded_handler,
-				   IRQF_SHARED, "AudioHDA", bus);
-	if (ret < 0) {
-		dev_err(sdev->dev, "error: failed to register HDA IRQ %d\n",
-			hdev->irq);
-		goto free_irq_vector;
-	}
-
 	dev_dbg(sdev->dev, "using IPC IRQ %d\n", sdev->ipc_irq);
-	ret = request_threaded_irq(sdev->ipc_irq, hda_dsp_ipc_irq_handler,
-				   sof_ops(sdev)->irq_thread, IRQF_SHARED,
-				   "AudioDSP", sdev);
+	ret = request_threaded_irq(sdev->ipc_irq, hda_dsp_interrupt_handler,
+				   hda_dsp_interrupt_thread,
+				   IRQF_SHARED, "AudioDSP", sdev);
 	if (ret < 0) {
 		dev_err(sdev->dev, "error: failed to register IPC IRQ %d\n",
 			sdev->ipc_irq);
-		goto free_hda_irq;
+		goto free_irq_vector;
 	}
 
 	pci_set_master(pci);
@@ -668,8 +698,6 @@ int hda_dsp_probe(struct snd_sof_dev *sdev)
 
 free_ipc_irq:
 	free_irq(sdev->ipc_irq, sdev);
-free_hda_irq:
-	free_irq(hdev->irq, bus);
 free_irq_vector:
 	if (sdev->msi_enabled)
 		pci_free_irq_vectors(pci);
@@ -715,7 +743,6 @@ int hda_dsp_remove(struct snd_sof_dev *sdev)
 				SOF_HDA_PPCTL_GPROCEN, 0);
 
 	free_irq(sdev->ipc_irq, sdev);
-	free_irq(hda->irq, bus);
 	if (sdev->msi_enabled)
 		pci_free_irq_vectors(pci);
 
diff --git a/sound/soc/sof/intel/hda.h b/sound/soc/sof/intel/hda.h
index 18d7e72bf9b72..63df888dddb6c 100644
--- a/sound/soc/sof/intel/hda.h
+++ b/sound/soc/sof/intel/hda.h
@@ -43,11 +43,14 @@
 /* SOF_HDA_GCTL register bist */
 #define SOF_HDA_GCTL_RESET		BIT(0)
 
-/* SOF_HDA_INCTL and SOF_HDA_INTSTS regs */
+/* SOF_HDA_INCTL regs */
 #define SOF_HDA_INT_GLOBAL_EN		BIT(31)
 #define SOF_HDA_INT_CTRL_EN		BIT(30)
 #define SOF_HDA_INT_ALL_STREAM		0xff
 
+/* SOF_HDA_INTSTS regs */
+#define SOF_HDA_INTSTS_GIS		BIT(31)
+
 #define SOF_HDA_MAX_CAPS		10
 #define SOF_HDA_CAP_ID_OFF		16
 #define SOF_HDA_CAP_ID_MASK		GENMASK(SOF_HDA_CAP_ID_OFF + 11,\
@@ -406,8 +409,6 @@ struct sof_intel_hda_dev {
 	/* the maximum number of streams (playback + capture) supported */
 	u32 stream_max;
 
-	int irq;
-
 	/* PM related */
 	bool l1_support_changed;/* during suspend, is L1SEN changed or not */
 
@@ -511,11 +512,12 @@ int hda_dsp_stream_hw_params(struct snd_sof_dev *sdev,
 			     struct snd_pcm_hw_params *params);
 int hda_dsp_stream_trigger(struct snd_sof_dev *sdev,
 			   struct hdac_ext_stream *stream, int cmd);
-irqreturn_t hda_dsp_stream_interrupt(int irq, void *context);
 irqreturn_t hda_dsp_stream_threaded_handler(int irq, void *context);
 int hda_dsp_stream_setup_bdl(struct snd_sof_dev *sdev,
 			     struct snd_dma_buffer *dmab,
 			     struct hdac_stream *stream);
+bool hda_dsp_check_ipc_irq(struct snd_sof_dev *sdev);
+bool hda_dsp_check_stream_irq(struct snd_sof_dev *sdev);
 
 struct hdac_ext_stream *
 	hda_dsp_stream_get(struct snd_sof_dev *sdev, int direction);
@@ -540,7 +542,6 @@ void hda_dsp_ipc_get_reply(struct snd_sof_dev *sdev);
 int hda_dsp_ipc_get_mailbox_offset(struct snd_sof_dev *sdev);
 int hda_dsp_ipc_get_window_offset(struct snd_sof_dev *sdev, u32 id);
 
-irqreturn_t hda_dsp_ipc_irq_handler(int irq, void *context);
 irqreturn_t hda_dsp_ipc_irq_thread(int irq, void *context);
 int hda_dsp_ipc_cmd_done(struct snd_sof_dev *sdev, int dir);
 
-- 
2.20.1



