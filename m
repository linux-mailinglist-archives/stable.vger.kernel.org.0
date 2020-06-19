Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B663200F3F
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403869AbgFSPRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:17:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404142AbgFSPRG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:17:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D55A721582;
        Fri, 19 Jun 2020 15:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579825;
        bh=BL5eAXPRlC1IBRiuQcN180O4CGnUQWKkqqkqjGc2e78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2FLjLJ1JJeJOAJMJV0iR9BdXV6oUIeKHOLwPK5NN5g5DdpakWaMulBe0bd8JkQZY1
         DaqtPO0wp+7RVI8F1w9jwQ4C9YTx9hHn44wurXNdkDniUz0c5Jgx40uDyrMHu9tvZb
         DVVY2rYf4Nq2hG+UoUwymqrTGjGsa9SFAt2G2vMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Guedes <andre.guedes@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 008/376] igc: Fix default MAC address filter override
Date:   Fri, 19 Jun 2020 16:28:46 +0200
Message-Id: <20200619141710.757057747@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

[ Upstream commit ac9156b27564a089ec52f526bfcb59f61c34e7c6 ]

This patch fixes a bug when the user adds the first MAC address filter
via ethtool NFC mechanism.

When the first MAC address filter is added, it overwrites the default
MAC address filter configured at RAL[0] and RAH[0]. As consequence,
frames addressed to the interface MAC address are not sent to host
anymore.

This patch fixes the bug by calling igc_set_default_mac_filter() during
adapter init so the position 0 of adapter->mac_table[] is assigned to
the default MAC address.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 69fa1ce1f927..c7020ff2f490 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2325,7 +2325,9 @@ static void igc_configure(struct igc_adapter *adapter)
 	igc_setup_mrqc(adapter);
 	igc_setup_rctl(adapter);
 
+	igc_set_default_mac_filter(adapter);
 	igc_nfc_filter_restore(adapter);
+
 	igc_configure_tx(adapter);
 	igc_configure_rx(adapter);
 
-- 
2.25.1



