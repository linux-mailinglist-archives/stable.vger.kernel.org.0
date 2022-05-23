Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90FF5316BC
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240637AbiEWRdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240966AbiEWRaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:30:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30FD53E38;
        Mon, 23 May 2022 10:26:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 747E8B81204;
        Mon, 23 May 2022 17:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8605C385AA;
        Mon, 23 May 2022 17:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326774;
        bh=lhOmLS/R9QJKcENUCDPWK6y1PeRsDp5qBeu0TJ02EbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vdRVXDGXXfRzcu/NZkSrwpc7DxRn/moZnxEexpLdcWXBAgrXLfr2dlhvMbkb/xAOp
         L0Go8XbCXUkjE/H417rog9cZn952AwK3UMgU7r5DlY8BQj1dRIpoaBjh5QexW3PeDT
         fWi8Zu++YlZexwcPdFpdq5aTVWscaPfNxwOJZ08I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Chee Hou Ong <chee.houx.ong@intel.com>,
        Aman Kumar <aman.kumar@intel.com>,
        Pallavi Kumari <kumari.pallavi@intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.17 054/158] Revert "can: m_can: pci: use custom bit timings for Elkhart Lake"
Date:   Mon, 23 May 2022 19:03:31 +0200
Message-Id: <20220523165839.694051980@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

commit 14ea4a470494528c7e88da5c4116c24eb027059f upstream.

This reverts commit 0e8ffdf3b86dfd44b651f91b12fcae76c25c453b.

Commit 0e8ffdf3b86d ("can: m_can: pci: use custom bit timings for
Elkhart Lake") broke the test case using bitrate switching.

| ip link set can0 up type can bitrate 500000 dbitrate 4000000 fd on
| ip link set can1 up type can bitrate 500000 dbitrate 4000000 fd on
| candump can0 &
| cangen can1 -I 0x800 -L 64 -e -fb \
|     -D 11223344deadbeef55667788feedf00daabbccdd44332211 -n 1 -v -v

Above commit does everything correctly according to the datasheet.
However datasheet wasn't correct.

I got confirmation from hardware engineers that the actual CAN
hardware on Intel Elkhart Lake is based on M_CAN version v3.2.0.
Datasheet was mirroring values from an another specification which was
based on earlier M_CAN version leading to wrong bit timings.

Therefore revert the commit and switch back to common bit timings.

Fixes: ea4c1787685d ("can: m_can: pci: use custom bit timings for Elkhart Lake")
Link: https://lore.kernel.org/all/20220512124144.536850-1-jarkko.nikula@linux.intel.com
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reported-by: Chee Hou Ong <chee.houx.ong@intel.com>
Reported-by: Aman Kumar <aman.kumar@intel.com>
Reported-by: Pallavi Kumari <kumari.pallavi@intel.com>
Cc: <stable@vger.kernel.org> # v5.16+
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/m_can/m_can_pci.c |   48 +++-----------------------------------
 1 file changed, 4 insertions(+), 44 deletions(-)

--- a/drivers/net/can/m_can/m_can_pci.c
+++ b/drivers/net/can/m_can/m_can_pci.c
@@ -18,14 +18,9 @@
 
 #define M_CAN_PCI_MMIO_BAR		0
 
+#define M_CAN_CLOCK_FREQ_EHL		200000000
 #define CTL_CSR_INT_CTL_OFFSET		0x508
 
-struct m_can_pci_config {
-	const struct can_bittiming_const *bit_timing;
-	const struct can_bittiming_const *data_timing;
-	unsigned int clock_freq;
-};
-
 struct m_can_pci_priv {
 	struct m_can_classdev cdev;
 
@@ -89,40 +84,9 @@ static struct m_can_ops m_can_pci_ops =
 	.read_fifo = iomap_read_fifo,
 };
 
-static const struct can_bittiming_const m_can_bittiming_const_ehl = {
-	.name = KBUILD_MODNAME,
-	.tseg1_min = 2,		/* Time segment 1 = prop_seg + phase_seg1 */
-	.tseg1_max = 64,
-	.tseg2_min = 1,		/* Time segment 2 = phase_seg2 */
-	.tseg2_max = 128,
-	.sjw_max = 128,
-	.brp_min = 1,
-	.brp_max = 512,
-	.brp_inc = 1,
-};
-
-static const struct can_bittiming_const m_can_data_bittiming_const_ehl = {
-	.name = KBUILD_MODNAME,
-	.tseg1_min = 2,		/* Time segment 1 = prop_seg + phase_seg1 */
-	.tseg1_max = 16,
-	.tseg2_min = 1,		/* Time segment 2 = phase_seg2 */
-	.tseg2_max = 8,
-	.sjw_max = 4,
-	.brp_min = 1,
-	.brp_max = 32,
-	.brp_inc = 1,
-};
-
-static const struct m_can_pci_config m_can_pci_ehl = {
-	.bit_timing = &m_can_bittiming_const_ehl,
-	.data_timing = &m_can_data_bittiming_const_ehl,
-	.clock_freq = 200000000,
-};
-
 static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 {
 	struct device *dev = &pci->dev;
-	const struct m_can_pci_config *cfg;
 	struct m_can_classdev *mcan_class;
 	struct m_can_pci_priv *priv;
 	void __iomem *base;
@@ -150,8 +114,6 @@ static int m_can_pci_probe(struct pci_de
 	if (!mcan_class)
 		return -ENOMEM;
 
-	cfg = (const struct m_can_pci_config *)id->driver_data;
-
 	priv = cdev_to_priv(mcan_class);
 
 	priv->base = base;
@@ -163,9 +125,7 @@ static int m_can_pci_probe(struct pci_de
 	mcan_class->dev = &pci->dev;
 	mcan_class->net->irq = pci_irq_vector(pci, 0);
 	mcan_class->pm_clock_support = 1;
-	mcan_class->bit_timing = cfg->bit_timing;
-	mcan_class->data_timing = cfg->data_timing;
-	mcan_class->can.clock.freq = cfg->clock_freq;
+	mcan_class->can.clock.freq = id->driver_data;
 	mcan_class->ops = &m_can_pci_ops;
 
 	pci_set_drvdata(pci, mcan_class);
@@ -218,8 +178,8 @@ static SIMPLE_DEV_PM_OPS(m_can_pci_pm_op
 			 m_can_pci_suspend, m_can_pci_resume);
 
 static const struct pci_device_id m_can_pci_id_table[] = {
-	{ PCI_VDEVICE(INTEL, 0x4bc1), (kernel_ulong_t)&m_can_pci_ehl, },
-	{ PCI_VDEVICE(INTEL, 0x4bc2), (kernel_ulong_t)&m_can_pci_ehl, },
+	{ PCI_VDEVICE(INTEL, 0x4bc1), M_CAN_CLOCK_FREQ_EHL, },
+	{ PCI_VDEVICE(INTEL, 0x4bc2), M_CAN_CLOCK_FREQ_EHL, },
 	{  }	/* Terminating Entry */
 };
 MODULE_DEVICE_TABLE(pci, m_can_pci_id_table);


