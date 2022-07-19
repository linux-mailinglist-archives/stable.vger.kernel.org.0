Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 893B5579E75
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242634AbiGSNBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242717AbiGSM73 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:59:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4D246D84;
        Tue, 19 Jul 2022 05:24:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6ED8AB81B36;
        Tue, 19 Jul 2022 12:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9066FC341D3;
        Tue, 19 Jul 2022 12:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233494;
        bh=7dVizbUshcZcXEg8DTB9O6088LdUH2iKBxS14dy8z6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wu81fupvCWKx4ShJbouMJZeFbcQlI+psetdNEYpOqsxBtKW4BqeDVLQU1qNA4LHbk
         Qws0KRxyWmcs3dDyxUCBrCnI8GZxRtCNAMiV5WtCSKnVpP1LNOC7gCE5Iyg6wh9WyG
         dzyliQw9NiNc3c3bYXIflV7QYTDDbVW1kt2Or7cU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 140/231] net: atlantic: remove deep parameter on suspend/resume functions
Date:   Tue, 19 Jul 2022 13:53:45 +0200
Message-Id: <20220719114726.159402867@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
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
index 831833911a52..dbd5263130f9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -379,7 +379,7 @@ static void aq_pci_shutdown(struct pci_dev *pdev)
 	}
 }
 
-static int aq_suspend_common(struct device *dev, bool deep)
+static int aq_suspend_common(struct device *dev)
 {
 	struct aq_nic_s *nic = pci_get_drvdata(to_pci_dev(dev));
 
@@ -392,17 +392,15 @@ static int aq_suspend_common(struct device *dev, bool deep)
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
@@ -415,10 +413,8 @@ static int atl_resume_common(struct device *dev, bool deep)
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
@@ -444,22 +440,22 @@ static int atl_resume_common(struct device *dev, bool deep)
 
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



