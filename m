Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E174A4CF8DF
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238891AbiCGKCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239899AbiCGKAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:00:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18DAB69484;
        Mon,  7 Mar 2022 01:46:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 574B461052;
        Mon,  7 Mar 2022 09:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D833C340E9;
        Mon,  7 Mar 2022 09:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646387;
        bh=CNjjbDsQ8prVbFHV22sMlC4quIRpot1LlEfds24tKLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhMYOeEwCAPv6C9pcSF02cws8rMDbL/IVxQHcM2uylX0oct4Znf6TarTRopjvm/hp
         zwnGfr0TmUAeKBcIVG1dvjbqlOjEHaQHFsh7LJerVCWO8OTH1xV6K+mH0vvFLIoDhV
         ELte69wEHIYGMdgcjYeYp1LCLt/jtaOi3fUpmFjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brett Creeley <brett.creeley@intel.com>,
        Karen Sornek <karen.sornek@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 228/262] iavf: Add helper function to go from pci_dev to adapter
Date:   Mon,  7 Mar 2022 10:19:32 +0100
Message-Id: <20220307091709.615594279@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karen Sornek <karen.sornek@intel.com>

[ Upstream commit 247aa001b72b6c8a89df9d108a2ec6f274a6b64d ]

Add helper function to go from pci_dev to adapter to make work simple -
to go from a pci_dev to the adapter structure and make netdev assignment
instead of having to go to the net_device then the adapter.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 24 +++++++++++++++------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 3aa21568686d..33a3dbcf8f2d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -51,6 +51,15 @@ MODULE_LICENSE("GPL v2");
 static const struct net_device_ops iavf_netdev_ops;
 struct workqueue_struct *iavf_wq;
 
+/**
+ * iavf_pdev_to_adapter - go from pci_dev to adapter
+ * @pdev: pci_dev pointer
+ */
+static struct iavf_adapter *iavf_pdev_to_adapter(struct pci_dev *pdev)
+{
+	return netdev_priv(pci_get_drvdata(pdev));
+}
+
 /**
  * iavf_allocate_dma_mem_d - OS specific memory alloc for shared code
  * @hw:   pointer to the HW structure
@@ -3739,8 +3748,8 @@ int iavf_process_config(struct iavf_adapter *adapter)
  **/
 static void iavf_shutdown(struct pci_dev *pdev)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
-	struct iavf_adapter *adapter = netdev_priv(netdev);
+	struct iavf_adapter *adapter = iavf_pdev_to_adapter(pdev);
+	struct net_device *netdev = adapter->netdev;
 
 	netif_device_detach(netdev);
 
@@ -3923,10 +3932,11 @@ static int __maybe_unused iavf_suspend(struct device *dev_d)
 static int __maybe_unused iavf_resume(struct device *dev_d)
 {
 	struct pci_dev *pdev = to_pci_dev(dev_d);
-	struct net_device *netdev = pci_get_drvdata(pdev);
-	struct iavf_adapter *adapter = netdev_priv(netdev);
+	struct iavf_adapter *adapter;
 	u32 err;
 
+	adapter = iavf_pdev_to_adapter(pdev);
+
 	pci_set_master(pdev);
 
 	rtnl_lock();
@@ -3945,7 +3955,7 @@ static int __maybe_unused iavf_resume(struct device *dev_d)
 
 	queue_work(iavf_wq, &adapter->reset_task);
 
-	netif_device_attach(netdev);
+	netif_device_attach(adapter->netdev);
 
 	return err;
 }
@@ -3961,8 +3971,8 @@ static int __maybe_unused iavf_resume(struct device *dev_d)
  **/
 static void iavf_remove(struct pci_dev *pdev)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
-	struct iavf_adapter *adapter = netdev_priv(netdev);
+	struct iavf_adapter *adapter = iavf_pdev_to_adapter(pdev);
+	struct net_device *netdev = adapter->netdev;
 	struct iavf_fdir_fltr *fdir, *fdirtmp;
 	struct iavf_vlan_filter *vlf, *vlftmp;
 	struct iavf_adv_rss *rss, *rsstmp;
-- 
2.34.1



