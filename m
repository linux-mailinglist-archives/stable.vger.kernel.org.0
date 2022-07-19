Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77C2579B06
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238989AbiGSMXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239505AbiGSMXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:23:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0085FAFD;
        Tue, 19 Jul 2022 05:08:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0CD41CE1BE9;
        Tue, 19 Jul 2022 12:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034ABC341C6;
        Tue, 19 Jul 2022 12:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232479;
        bh=7cNBNBqTCRgYnTO0bj8dUdBWHEOjGgH5Rr9On3wfi1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ugc8tcD/ED4Kc3+IPb6bjwvY7Kpy6q5DBOZ31p+FmXK+zWRoDZdZ0tGoHu3VHI8mH
         HgS79hGfv/m02Iezw3ZvjSsKOUmfIT6w68qd7/6bOFUnkjMx9/7pnIcxnXn81Td9r1
         zB+RoPrfEEPIzZvCkbxg7xomxae65j6ldOps+pCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/112] net: atlantic: remove deep parameter on suspend/resume functions
Date:   Tue, 19 Jul 2022 13:54:05 +0200
Message-Id: <20220719114633.448588714@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>

[ Upstream commit 0f33250760384e05c36466b0a2f92f3c6007ba92 ]

Below commit claims that atlantic NIC requires to reset the device on pm
op, and had set the deep to true for all suspend/resume functions.
commit 1809c30b6e5a ("net: atlantic: always deep reset on pm op, fixing up my null deref regression")
So, we could remove deep parameter on suspend/resume functions without
any functional change.

Fixes: 1809c30b6e5a ("net: atlantic: always deep reset on pm op, fixing up my null deref regression")
Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Link: https://lore.kernel.org/r/20220713111224.1535938-1-acelan.kao@canonical.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/aquantia/atlantic/aq_pci_func.c  | 24 ++++++++-----------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index fc5ea434a27c..8c05b2b79339 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -385,7 +385,7 @@ static void aq_pci_shutdown(struct pci_dev *pdev)
 	}
 }
 
-static int aq_suspend_common(struct device *dev, bool deep)
+static int aq_suspend_common(struct device *dev)
 {
 	struct aq_nic_s *nic = pci_get_drvdata(to_pci_dev(dev));
 
@@ -398,17 +398,15 @@ static int aq_suspend_common(struct device *dev, bool deep)
 	if (netif_running(nic->ndev))
 		aq_nic_stop(nic);
 
-	if (deep) {
-		aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);
-		aq_nic_set_power(nic);
-	}
+	aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);
+	aq_nic_set_power(nic);
 
 	rtnl_unlock();
 
 	return 0;
 }
 
-static int atl_resume_common(struct device *dev, bool deep)
+static int atl_resume_common(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct aq_nic_s *nic;
@@ -421,10 +419,8 @@ static int atl_resume_common(struct device *dev, bool deep)
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
 
-	if (deep) {
-		/* Reinitialize Nic/Vecs objects */
-		aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);
-	}
+	/* Reinitialize Nic/Vecs objects */
+	aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);
 
 	if (netif_running(nic->ndev)) {
 		ret = aq_nic_init(nic);
@@ -450,22 +446,22 @@ static int atl_resume_common(struct device *dev, bool deep)
 
 static int aq_pm_freeze(struct device *dev)
 {
-	return aq_suspend_common(dev, true);
+	return aq_suspend_common(dev);
 }
 
 static int aq_pm_suspend_poweroff(struct device *dev)
 {
-	return aq_suspend_common(dev, true);
+	return aq_suspend_common(dev);
 }
 
 static int aq_pm_thaw(struct device *dev)
 {
-	return atl_resume_common(dev, true);
+	return atl_resume_common(dev);
 }
 
 static int aq_pm_resume_restore(struct device *dev)
 {
-	return atl_resume_common(dev, true);
+	return atl_resume_common(dev);
 }
 
 static const struct dev_pm_ops aq_pm_ops = {
-- 
2.35.1



