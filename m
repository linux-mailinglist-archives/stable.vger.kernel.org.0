Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F9040E0BB
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbhIPQXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:23:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241555AbhIPQVn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:21:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15F8F61425;
        Thu, 16 Sep 2021 16:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808907;
        bh=cV7WmLDjnDZQEeewxro9qVt6omi3siHsFrzxGLSmrOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZSBhgLkuTSp6IeeaxZHJJR03d5Mo8+AMU9Pq7ypHCCUDmli7Lohj1Mj+d31HCj4j
         CqByZzvF/grGd6rK2Jdpv6tVVfie57m52C+/T3XiD9/9Jx7+HFQN+IZL6tzv0tLapQ
         iWKaTrQr6AU4U81mo5G5386zNHcQYaRrc4i2xgDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 266/306] iwlwifi: mvm: Fix scan channel flags settings
Date:   Thu, 16 Sep 2021 18:00:11 +0200
Message-Id: <20210916155803.133853202@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 090f1be3abf3069ef856b29761f181808bf55917 ]

The iwl_mvm_scan_ch_n_aps_flag() is called with a variable
before the value of the variable is set. Fix it.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210826224715.f6f188980a5e.Ie7331a8b94004d308f6cbde44e519155a5be91dd@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index aebaad45043f..a5d90e028833 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1682,7 +1682,7 @@ iwl_mvm_umac_scan_cfg_channels_v6(struct iwl_mvm *mvm,
 		struct iwl_scan_channel_cfg_umac *cfg = &cp->channel_config[i];
 		u32 n_aps_flag =
 			iwl_mvm_scan_ch_n_aps_flag(vif_type,
-						   cfg->v2.channel_num);
+						   channels[i]->hw_value);
 
 		cfg->flags = cpu_to_le32(flags | n_aps_flag);
 		cfg->v2.channel_num = channels[i]->hw_value;
-- 
2.30.2



