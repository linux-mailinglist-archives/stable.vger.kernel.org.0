Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9665DA9160
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390913AbfIDSPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390892AbfIDSPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:15:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D34382339E;
        Wed,  4 Sep 2019 18:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620902;
        bh=ymm/7I0fTfk/VBG1Jrb4p22YfL6x5dPwDCsvpZ16V1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ua6DApwhrRxhSunnPvETl+zp7U4oImlFKwa/nmE1MqvcvX/5itBzjko4RmC4X6Hf4
         0imMqTn0ohFqFMFK8QKqHZxFObclSZsSSXM85H/6F/Q3m+lzXZwL7F1rluk2qoOLUT
         5jWsZ96bsyinSDBHFHCtK+Y6XHqPHCZGhrKsLudw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 137/143] iwlwifi: pcie: dont switch FW to qnj when ax201 is detected
Date:   Wed,  4 Sep 2019 19:54:40 +0200
Message-Id: <20190904175319.782005031@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 17e40e6979aaf60f356331bac129df20e1fd74a0 ]

We have a too generic condition that switches from Qu configurations
to QnJ configurations.  We need to exclude some configurations so that
they are not erroneously switched.  Add the ax201 configuration to the
list of exclusions.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 38ab24d962446..5209e8c3643eb 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3601,6 +3601,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 		   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR) &&
 		   ((trans->cfg != &iwl_ax200_cfg_cc &&
+		     trans->cfg != &iwl_ax201_cfg_qu_hr &&
 		     trans->cfg != &killer1650x_2ax_cfg &&
 		     trans->cfg != &killer1650w_2ax_cfg &&
 		     trans->cfg != &iwl_ax201_cfg_quz_hr) ||
-- 
2.20.1



