Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0BC59A3CC
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354046AbiHSQrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353743AbiHSQq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:46:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8458C12AD22;
        Fri, 19 Aug 2022 09:12:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BB8BB825D3;
        Fri, 19 Aug 2022 16:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF00C433C1;
        Fri, 19 Aug 2022 16:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925491;
        bh=maXJZmtfGHTbigKGqgNHPqRQAaITODt4/YtQSu33wlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dejY5PZ81ioTDjn/ncS6QfNQBU1VIr8mJWABYGO2e6eqdAYjLeLlVQSHGlAMW3Hoq
         /O+JOhPyp1H4tnjJuYrEml3K2d1g85KNSAPzkhglXwEJBGz1bK/uYu7J/dvFgYmNc7
         O898/eWDpIITKfXMhdJa+8lM7ad7YwHnVsmMDlgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean V Kelley <sean.v.kelley@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 477/545] PCI/ERR: Simplify by computing pci_pcie_type() once
Date:   Fri, 19 Aug 2022 17:44:07 +0200
Message-Id: <20220819153850.764825952@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean V Kelley <sean.v.kelley@intel.com>

[ Upstream commit 480ef7cb9fcebda7b28cbed4f6cdcf0a02f4a6ca ]

Instead of calling pci_pcie_type(dev) twice, call it once and save the
result.  No functional change intended.

Link: https://lore.kernel.org/r/20201121001036.8560-7-sean.v.kelley@intel.com
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> # non-native/no RCEC
Signed-off-by: Sean V Kelley <sean.v.kelley@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c         | 5 +++--
 drivers/pci/pcie/err.c         | 5 +++--
 drivers/pci/pcie/portdrv_pci.c | 9 +++++----
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 61f78b20b0cf..72dbc193a25f 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1039,6 +1039,7 @@ EXPORT_SYMBOL_GPL(aer_recover_queue);
  */
 int aer_get_device_error_info(struct pci_dev *dev, struct aer_err_info *info)
 {
+	int type = pci_pcie_type(dev);
 	int aer = dev->aer_cap;
 	int temp;
 
@@ -1057,8 +1058,8 @@ int aer_get_device_error_info(struct pci_dev *dev, struct aer_err_info *info)
 			&info->mask);
 		if (!(info->status & ~info->mask))
 			return 0;
-	} else if (pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT ||
-	           pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM ||
+	} else if (type == PCI_EXP_TYPE_ROOT_PORT ||
+		   type == PCI_EXP_TYPE_DOWNSTREAM ||
 		   info->severity == AER_NONFATAL) {
 
 		/* Link is still healthy for IO reads */
diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
index 05f61da5ed9d..7a5af873d8bc 100644
--- a/drivers/pci/pcie/err.c
+++ b/drivers/pci/pcie/err.c
@@ -150,6 +150,7 @@ pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
 		pci_channel_state_t state,
 		pci_ers_result_t (*reset_subordinates)(struct pci_dev *pdev))
 {
+	int type = pci_pcie_type(dev);
 	pci_ers_result_t status = PCI_ERS_RESULT_CAN_RECOVER;
 	struct pci_bus *bus;
 
@@ -157,8 +158,8 @@ pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
 	 * Error recovery runs on all subordinates of the first downstream port.
 	 * If the downstream port detected the error, it is cleared at the end.
 	 */
-	if (!(pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT ||
-	      pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM))
+	if (!(type == PCI_EXP_TYPE_ROOT_PORT ||
+	      type == PCI_EXP_TYPE_DOWNSTREAM))
 		dev = pci_upstream_bridge(dev);
 	bus = dev->subordinate;
 
diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index 26259630fd10..aac1a6828b4f 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -101,13 +101,14 @@ static const struct dev_pm_ops pcie_portdrv_pm_ops = {
 static int pcie_portdrv_probe(struct pci_dev *dev,
 					const struct pci_device_id *id)
 {
+	int type = pci_pcie_type(dev);
 	int status;
 
 	if (!pci_is_pcie(dev) ||
-	    ((pci_pcie_type(dev) != PCI_EXP_TYPE_ROOT_PORT) &&
-	     (pci_pcie_type(dev) != PCI_EXP_TYPE_UPSTREAM) &&
-	     (pci_pcie_type(dev) != PCI_EXP_TYPE_DOWNSTREAM) &&
-	     (pci_pcie_type(dev) != PCI_EXP_TYPE_RC_EC)))
+	    ((type != PCI_EXP_TYPE_ROOT_PORT) &&
+	     (type != PCI_EXP_TYPE_UPSTREAM) &&
+	     (type != PCI_EXP_TYPE_DOWNSTREAM) &&
+	     (type != PCI_EXP_TYPE_RC_EC)))
 		return -ENODEV;
 
 	status = pcie_port_device_register(dev);
-- 
2.35.1



