Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B962B28B7CA
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389903AbgJLNqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:46:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389812AbgJLNqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:46:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FD0920878;
        Mon, 12 Oct 2020 13:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510359;
        bh=Cr12PpbpRf0VpJ2idEZAVYom7Vy5WI+MG3xOOzSOFyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IsFPSLdc13ijv1kWL3+F7J6dLirXwXQNAToE8pViWN+YmW/5AXmJewmHZwCG1w0aE
         7sCv5REnRwzCIEy9NCrF5WLeH1Lj5TTU9d+rNroHSwX+iWI25j1MZsbjVBBJeC/evP
         vL7Me9HLBCfXuTyL8rt/Wlz90G6Vr8F8WjdYXJDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 066/124] iavf: Fix incorrect adapter get in iavf_resume
Date:   Mon, 12 Oct 2020 15:31:10 +0200
Message-Id: <20201012133150.045456925@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

[ Upstream commit 75598a8fc0e0dff2aa5d46c62531b36a595f1d4f ]

When calling iavf_resume there was a crash because wrong
function was used to get iavf_adapter and net_device pointers.
Changed how iavf_resume is getting iavf_adapter and net_device
pointers from pci_dev.

Fixes: 5eae00c57f5e ("i40evf: main driver core")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index b3b349ecb0a8d..91343e2d3a145 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3817,8 +3817,8 @@ static int __maybe_unused iavf_suspend(struct device *dev_d)
 static int __maybe_unused iavf_resume(struct device *dev_d)
 {
 	struct pci_dev *pdev = to_pci_dev(dev_d);
-	struct iavf_adapter *adapter = pci_get_drvdata(pdev);
-	struct net_device *netdev = adapter->netdev;
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct iavf_adapter *adapter = netdev_priv(netdev);
 	u32 err;
 
 	pci_set_master(pdev);
-- 
2.25.1



