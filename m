Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050FD50F606
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345773AbiDZIrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347127AbiDZIpv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3C5793B5;
        Tue, 26 Apr 2022 01:37:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BFC7603E0;
        Tue, 26 Apr 2022 08:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E9CC385A0;
        Tue, 26 Apr 2022 08:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962243;
        bh=WX/DtGNbHwolQ0XWCUvkRTjty4uMyDFVP57ojyvmgJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/m9gHQ4zbG/9VPNA0jnl+Dqe6FP6KeJCbkZg6yChFshWUv6/OxrPqQQlhCz9dw3H
         xXFQYkvFFzLOiA86N3chniDtHq7BoU1UkYuEANS4OK42ngWtrsMwaFZVcRuM5MB5xQ
         TxNovMJxEUSvwMaAL4Wsp9VY3TgNn8+j4OW/4dOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/124] igc: Fix suspending when PTM is active
Date:   Tue, 26 Apr 2022 10:20:32 +0200
Message-Id: <20220426081748.188785492@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit 822f52e7efdc88fccffb9fbf6250a4b7666a0b0f ]

Some mainboard/CPU combinations, in particular, Alder Lake-S with a
W680 mainboard, have shown problems (system hangs usually, no kernel
logs) with suspend/resume when PCIe PTM is enabled and active. In some
cases, it could be reproduced when removing the igc module.

The best we can do is to stop PTM dialogs from the downstream/device
side before the interface is brought down. PCIe PTM will be re-enabled
when the interface is being brought up.

Fixes: a90ec8483732 ("igc: Add support for PTP getcrosststamp()")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 4f9245aa79a1..8e521f99b80a 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -996,6 +996,17 @@ static void igc_ptp_time_restore(struct igc_adapter *adapter)
 	igc_ptp_write_i225(adapter, &ts);
 }
 
+static void igc_ptm_stop(struct igc_adapter *adapter)
+{
+	struct igc_hw *hw = &adapter->hw;
+	u32 ctrl;
+
+	ctrl = rd32(IGC_PTM_CTRL);
+	ctrl &= ~IGC_PTM_CTRL_EN;
+
+	wr32(IGC_PTM_CTRL, ctrl);
+}
+
 /**
  * igc_ptp_suspend - Disable PTP work items and prepare for suspend
  * @adapter: Board private structure
@@ -1013,8 +1024,10 @@ void igc_ptp_suspend(struct igc_adapter *adapter)
 	adapter->ptp_tx_skb = NULL;
 	clear_bit_unlock(__IGC_PTP_TX_IN_PROGRESS, &adapter->state);
 
-	if (pci_device_is_present(adapter->pdev))
+	if (pci_device_is_present(adapter->pdev)) {
 		igc_ptp_time_save(adapter);
+		igc_ptm_stop(adapter);
+	}
 }
 
 /**
-- 
2.35.1



