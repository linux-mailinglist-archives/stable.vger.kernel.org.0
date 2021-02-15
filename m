Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB67C31BD19
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhBOPj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:39:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231484AbhBOPhw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:37:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59C2F64EA8;
        Mon, 15 Feb 2021 15:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403199;
        bh=GSw9bnD9A1N/+UTECpJAzlbYHSYzAcWOFUxglhtMWzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TyMh7f052Y5m34McJX4hIRI9U1c6Jpnjlu6IgAkCv76/ET9fwKl68z2IYLnsXOVik
         I0BBWIzPKC0XWNaWKcXtUeT54cwCQwTqCtcI2nO77+bVyG6vD/TAf4r8Dw0M1Pqr1D
         /0pzxJmWYczoPHbBvrApmxGyos4AI2DIFv/pn8JA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/104] net: enetc: initialize the RFS and RSS memories
Date:   Mon, 15 Feb 2021 16:27:18 +0100
Message-Id: <20210215152721.570239746@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 07bf34a50e327975b21a9dee64d220c3dcb72ee9 ]

Michael tried to enable Advanced Error Reporting through the ENETC's
Root Complex Event Collector, and the system started spitting out single
bit correctable ECC errors coming from the ENETC interfaces:

pcieport 0000:00:1f.0: AER: Multiple Corrected error received: 0000:00:00.0
fsl_enetc 0000:00:00.0: PCIe Bus Error: severity=Corrected, type=Transaction Layer, (Receiver ID)
fsl_enetc 0000:00:00.0:   device [1957:e100] error status/mask=00004000/00000000
fsl_enetc 0000:00:00.0:    [14] CorrIntErr
fsl_enetc 0000:00:00.1: PCIe Bus Error: severity=Corrected, type=Transaction Layer, (Receiver ID)
fsl_enetc 0000:00:00.1:   device [1957:e100] error status/mask=00004000/00000000
fsl_enetc 0000:00:00.1:    [14] CorrIntErr

Further investigating the port correctable memory error detect register
(PCMEDR) shows that these AER errors have an associated SOURCE_ID of 6
(RFS/RSS):

$ devmem 0x1f8010e10 32
0xC0000006
$ devmem 0x1f8050e10 32
0xC0000006

Discussion with the hardware design engineers reveals that on LS1028A,
the hardware does not do initialization of that RFS/RSS memory, and that
software should clear/initialize the entire table before starting to
operate. That comes as a bit of a surprise, since the driver does not do
initialization of the RFS memory. Also, the initialization of the
Receive Side Scaling is done only partially.

Even though the entire ENETC IP has a single shared flow steering
memory, the flow steering service should returns matches only for TCAM
entries that are within the range of the Station Interface that is doing
the search. Therefore, it should be sufficient for a Station Interface
to initialize all of its own entries in order to avoid any ECC errors,
and only the Station Interfaces in use should need initialization.

There are Physical Station Interfaces associated with PCIe PFs and
Virtual Station Interfaces associated with PCIe VFs. We let the PF
driver initialize the entire port's memory, which includes the RFS
entries which are going to be used by the VF.

Reported-by: Michael Walle <michael@walle.cc>
Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Michael Walle <michael@walle.cc>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Link: https://lore.kernel.org/r/20210204134511.2640309-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  2 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 59 +++++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 4cbf1667d7ff4..014ca6ae121f8 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -196,6 +196,8 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_CBS_BW_MASK	GENMASK(6, 0)
 #define ENETC_PTCCBSR1(n)	(0x1114 + (n) * 8) /* n = 0 to 7*/
 #define ENETC_RSSHASH_KEY_SIZE	40
+#define ENETC_PRSSCAPR		0x1404
+#define ENETC_PRSSCAPR_GET_NUM_RSS(val)	(BIT((val) & 0xf) * 32)
 #define ENETC_PRSSK(n)		(0x1410 + (n) * 4) /* n = [0..9] */
 #define ENETC_PSIVLANFMR	0x1700
 #define ENETC_PSIVLANFMR_VS	BIT(0)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 419306342ac51..06514af0df106 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1004,6 +1004,51 @@ static void enetc_phylink_destroy(struct enetc_ndev_priv *priv)
 		phylink_destroy(priv->phylink);
 }
 
+/* Initialize the entire shared memory for the flow steering entries
+ * of this port (PF + VFs)
+ */
+static int enetc_init_port_rfs_memory(struct enetc_si *si)
+{
+	struct enetc_cmd_rfse rfse = {0};
+	struct enetc_hw *hw = &si->hw;
+	int num_rfs, i, err = 0;
+	u32 val;
+
+	val = enetc_port_rd(hw, ENETC_PRFSCAPR);
+	num_rfs = ENETC_PRFSCAPR_GET_NUM_RFS(val);
+
+	for (i = 0; i < num_rfs; i++) {
+		err = enetc_set_fs_entry(si, &rfse, i);
+		if (err)
+			break;
+	}
+
+	return err;
+}
+
+static int enetc_init_port_rss_memory(struct enetc_si *si)
+{
+	struct enetc_hw *hw = &si->hw;
+	int num_rss, err;
+	int *rss_table;
+	u32 val;
+
+	val = enetc_port_rd(hw, ENETC_PRSSCAPR);
+	num_rss = ENETC_PRSSCAPR_GET_NUM_RSS(val);
+	if (!num_rss)
+		return 0;
+
+	rss_table = kcalloc(num_rss, sizeof(*rss_table), GFP_KERNEL);
+	if (!rss_table)
+		return -ENOMEM;
+
+	err = enetc_set_rss_table(si, rss_table, num_rss);
+
+	kfree(rss_table);
+
+	return err;
+}
+
 static int enetc_pf_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *ent)
 {
@@ -1058,6 +1103,18 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 		goto err_alloc_si_res;
 	}
 
+	err = enetc_init_port_rfs_memory(si);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to initialize RFS memory\n");
+		goto err_init_port_rfs;
+	}
+
+	err = enetc_init_port_rss_memory(si);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to initialize RSS memory\n");
+		goto err_init_port_rss;
+	}
+
 	err = enetc_alloc_msix(priv);
 	if (err) {
 		dev_err(&pdev->dev, "MSIX alloc failed\n");
@@ -1086,6 +1143,8 @@ err_phylink_create:
 	enetc_mdiobus_destroy(pf);
 err_mdiobus_create:
 	enetc_free_msix(priv);
+err_init_port_rss:
+err_init_port_rfs:
 err_alloc_msix:
 	enetc_free_si_resources(priv);
 err_alloc_si_res:
-- 
2.27.0



