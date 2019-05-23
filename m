Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF185289EA
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389552AbfEWTSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:18:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389124AbfEWTSM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:18:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05928217D7;
        Thu, 23 May 2019 19:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639091;
        bh=+t0u5GOucS63bRMTYhnfoDgwbCZ7hpJlC0pSSCGnqdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HTVMFP7sc+56JRgcNRLMLzJVrka+nyVwDIiZ1Xbq6Na3JK1CpprEd9+W/ERRolTa0
         OoKtKiXva8oKSAOiKGQLt/AEHsGzVG7NEKXhzxYQv4mj9Bw8UsX3ZtcMk9mBJ4qOiL
         K7qSnNqktT48gVRWa6iVYIyMBqBG/VIZ278ruagM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kazufumi Ikeda <kaz-ikeda@xc.jp.nec.com>,
        Gaku Inami <gaku.inami.xw@bp.renesas.com>,
        Marek Vasut <marek.vasut+renesas@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH 4.19 074/114] PCI: rcar: Add the initialization of PCIe link in resume_noirq()
Date:   Thu, 23 May 2019 21:06:13 +0200
Message-Id: <20190523181738.447719138@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kazufumi Ikeda <kaz-ikeda@xc.jp.nec.com>

commit be20bbcb0a8cb5597cc62b3e28d275919f3431df upstream.

Reestablish the PCIe link very early in the resume process in case it
went down to prevent PCI accesses from hanging the bus. Such accesses
can happen early in the PCI resume process, as early as the
SUSPEND_RESUME_NOIRQ step, thus the link must be reestablished in the
driver resume_noirq() callback.

Fixes: e015f88c368d ("PCI: rcar: Add support for R-Car H3 to pcie-rcar")
Signed-off-by: Kazufumi Ikeda <kaz-ikeda@xc.jp.nec.com>
Signed-off-by: Gaku Inami <gaku.inami.xw@bp.renesas.com>
Signed-off-by: Marek Vasut <marek.vasut+renesas@gmail.com>
[lorenzo.pieralisi@arm.com: reformatted commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: stable@vger.kernel.org
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Phil Edworthy <phil.edworthy@renesas.com>
Cc: Simon Horman <horms+renesas@verge.net.au>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-renesas-soc@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/controller/pcie-rcar.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/pci/controller/pcie-rcar.c
+++ b/drivers/pci/controller/pcie-rcar.c
@@ -46,6 +46,7 @@
 
 /* Transfer control */
 #define PCIETCTLR		0x02000
+#define  DL_DOWN		BIT(3)
 #define  CFINIT			1
 #define PCIETSTR		0x02004
 #define  DATA_LINK_ACTIVE	1
@@ -94,6 +95,7 @@
 #define MACCTLR			0x011058
 #define  SPEED_CHANGE		BIT(24)
 #define  SCRAMBLE_DISABLE	BIT(27)
+#define PMSR			0x01105c
 #define MACS2R			0x011078
 #define MACCGSPSETR		0x011084
 #define  SPCNGRSN		BIT(31)
@@ -1130,6 +1132,7 @@ static int rcar_pcie_probe(struct platfo
 	pcie = pci_host_bridge_priv(bridge);
 
 	pcie->dev = dev;
+	platform_set_drvdata(pdev, pcie);
 
 	err = pci_parse_request_of_pci_ranges(dev, &pcie->resources, NULL);
 	if (err)
@@ -1221,10 +1224,28 @@ err_free_bridge:
 	return err;
 }
 
+static int rcar_pcie_resume_noirq(struct device *dev)
+{
+	struct rcar_pcie *pcie = dev_get_drvdata(dev);
+
+	if (rcar_pci_read_reg(pcie, PMSR) &&
+	    !(rcar_pci_read_reg(pcie, PCIETCTLR) & DL_DOWN))
+		return 0;
+
+	/* Re-establish the PCIe link */
+	rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
+	return rcar_pcie_wait_for_dl(pcie);
+}
+
+static const struct dev_pm_ops rcar_pcie_pm_ops = {
+	.resume_noirq = rcar_pcie_resume_noirq,
+};
+
 static struct platform_driver rcar_pcie_driver = {
 	.driver = {
 		.name = "rcar-pcie",
 		.of_match_table = rcar_pcie_of_match,
+		.pm = &rcar_pcie_pm_ops,
 		.suppress_bind_attrs = true,
 	},
 	.probe = rcar_pcie_probe,


