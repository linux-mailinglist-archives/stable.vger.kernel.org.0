Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C8B429018
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238609AbhJKOFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:05:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238978AbhJKODD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:03:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52E4961105;
        Mon, 11 Oct 2021 13:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960701;
        bh=Pku8DfNofgD/9nn8GK4dVAJ1vjxgTaghmHMfrhrYFqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ip9FGpB1afomX6UJJZ7mQgLwJUlAySUS6pD6EpkSTTxJCaF00kpMRdpcw8qRE8oo3
         /n4mGjCN7JUHNLzWCDV5uhzUDrkQPy6P4El53QfbDRTPgGVsrufi6STsCZzHUtZzId
         QspKu+OjeFvVaJhLOTkcbsI5wiOdIkSLkwSC/8Mg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Wajsberg <felash@gmail.com>,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Luca Coelho <luca@coelho.fi>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 051/151] iwlwifi: pcie: add configuration of a Wi-Fi adapter on Dell XPS 15
Date:   Mon, 11 Oct 2021 15:45:23 +0200
Message-Id: <20211011134519.503458400@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit fe5c735d0d47b495be6753d6aea4f8f78c909a0a ]

There is a Killer AX1650 2x2 Wi-Fi 6 and Bluetooth 5.1 wireless adapter
found on Dell XPS 15 (9510) laptop, its configuration was present on
Linux v5.7, however accidentally it has been removed from the list of
supported devices, let's add it back.

The problem is manifested on driver initialization:

  Intel(R) Wireless WiFi driver for Linux
  iwlwifi 0000:00:14.3: enabling device (0000 -> 0002)
  iwlwifi: No config found for PCI dev 43f0/1651, rev=0x354, rfid=0x10a100
  iwlwifi: probe of 0000:00:14.3 failed with error -22

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=213939
Fixes: 3f910a25839b ("iwlwifi: pcie: convert all AX101 devices to the device tables")
Cc: Julien Wajsberg <felash@gmail.com>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Acked-by: Luca Coelho <luca@coelho.fi>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210924122154.2376577-1-vladimir.zapolskiy@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 6f49950a5f6d..be3ad4281353 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -547,6 +547,8 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 	IWL_DEV_INFO(0x43F0, 0x0074, iwl_ax201_cfg_qu_hr, NULL),
 	IWL_DEV_INFO(0x43F0, 0x0078, iwl_ax201_cfg_qu_hr, NULL),
 	IWL_DEV_INFO(0x43F0, 0x007C, iwl_ax201_cfg_qu_hr, NULL),
+	IWL_DEV_INFO(0x43F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0, iwl_ax201_killer_1650s_name),
+	IWL_DEV_INFO(0x43F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0, iwl_ax201_killer_1650i_name),
 	IWL_DEV_INFO(0x43F0, 0x2074, iwl_ax201_cfg_qu_hr, NULL),
 	IWL_DEV_INFO(0x43F0, 0x4070, iwl_ax201_cfg_qu_hr, NULL),
 	IWL_DEV_INFO(0xA0F0, 0x0070, iwl_ax201_cfg_qu_hr, NULL),
-- 
2.33.0



