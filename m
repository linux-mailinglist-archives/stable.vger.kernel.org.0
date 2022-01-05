Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F87484F0D
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 09:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238356AbiAEIND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 03:13:03 -0500
Received: from inva020.nxp.com ([92.121.34.13]:39056 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238354AbiAEIMw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Jan 2022 03:12:52 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 062E61A163E;
        Wed,  5 Jan 2022 09:12:51 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C1BC51A125A;
        Wed,  5 Jan 2022 09:12:50 +0100 (CET)
Received: from localhost.localdomain (shlinux2.ap.freescale.net [10.192.224.44])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 7D716183ACDE;
        Wed,  5 Jan 2022 16:12:49 +0800 (+08)
From:   Richard Zhu <hongxing.zhu@nxp.com>
To:     l.stach@pengutronix.de, bhelgaas@google.com, broonie@kernel.org,
        lorenzo.pieralisi@arm.com, jingoohan1@gmail.com, festevam@gmail.com
Cc:     hongxing.zhu@nxp.com, stable@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-imx@nxp.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH v5 0/6] PCI: imx6: refine codes and add compliance tests mode support 
Date:   Wed,  5 Jan 2022 15:43:16 +0800
Message-Id: <1641368602-20401-1-git-send-email-hongxing.zhu@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series patches refine pci-imx6 driver and do the following changes.
- Encapsulate the clock enable into one standalone function
- Add the error propagation from host_init
- Balance the usage of the regulator and clocks when link never came up
- Add the compliance tests mode support

Main changes from v4 to v5:
- Since i.MX8MM PCIe support had been merged. Based on Lorenzo's git repos,
  rebase and resend the patch-set.

Main changes from v3 to v4:
- Regarding Mark's comments, delete the regulator_is_enabled() check.
- Squash #3 and #6 of v3 patch into #5 patch of v4 set.

Main changes from v2 to v3:
- Add "Reviewed-by: Lucas Stach <l.stach@pengutronix.de>" tag into
  first two patches.
- Add a Fixes tag into #3 patch.
- Split the #4 of v2 to two patches, one is clock disable codes move,
  the other one is the acutal clock unbalance fix.
- Add a new host_exit() callback into dw_pcie_host_ops, then it could be
  invoked to handle the unbalance issue in the error handling after
  host_init() function when link is down.
- Add a new host_exit() callback for i.MX PCIe driver to handle this case
  in the error handling after host_init.

Main changes from v1 to v2:
Regarding Lucas' comments.
  - Move the placement of the new imx6_pcie_clk_enable() to avoid the
    forward declarition.
  - Seperate the second patch of v1 patch-set to three patches.
  - Use the module_param to replace the kernel command line.
Regarding Bjorn's comments:
  - Use the cover-letter for a multi-patch series.
  - Correct the subject line, and refine the commit logs. For example,
    remove the timestamp of the logs.

drivers/pci/controller/dwc/pci-imx6.c             | 197 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------
drivers/pci/controller/dwc/pcie-designware-host.c |   5 ++-
drivers/pci/controller/dwc/pcie-designware.h      |   1 +
3 files changed, 128 insertions(+), 75 deletions(-)

[PATCH v5 1/6] PCI: imx6: Encapsulate the clock enable into one
[PATCH v5 2/6] PCI: imx6: Add the error propagation from host_init
[PATCH v5 3/6] PCI: imx6: PCI: imx6: Move imx6_pcie_clk_disable()
[PATCH v5 4/6] PCI: dwc: Add dw_pcie_host_ops.host_exit() callback
[PATCH v5 5/6] PCI: imx6: Fix the regulator dump when link never came
[PATCH v5 6/6] PCI: imx6: Add the compliance tests mode support
