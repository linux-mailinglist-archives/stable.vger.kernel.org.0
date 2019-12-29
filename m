Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFA212C815
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731632AbfL2Rur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:50:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:35434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731929AbfL2Ruq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:50:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20338207FD;
        Sun, 29 Dec 2019 17:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641845;
        bh=ZkIBtwBjEDbbhwugtThGzhgGGUDvFbuITYStAhQMrmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjTQ5J246Tro2vjmVMUX6Dix1mSOsu0W9WkiCqM/GqhcGNsYx4wuXMlTF7BnWZslO
         fZOziYcQAaRwTd+VJoAFZBbHCIb4ZkoRnTRtVDyYSok7kPppgm+M1w3oI33mBIfDV8
         K7yYt9T703jkDox1F+w4PrxniNyXhGfZohyctZlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslaw Gawin <jaroslawx.gawin@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 192/434] i40e: Wrong Advertised FEC modes after set FEC to AUTO
Date:   Sun, 29 Dec 2019 18:24:05 +0100
Message-Id: <20191229172714.576002535@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslaw Gawin <jaroslawx.gawin@intel.com>

[ Upstream commit e42b7e9cefca9dd008cbafffca97285cf264f72d ]

Fix display of parameters "Configured FEC encodings:" and "Advertised
FEC modes:" in ethtool.  Implemented by setting proper FEC bits in
“advertising” bitmask of link_modes struct and “fec” bitmask in
ethtool_fecparam struct. Without this patch wrong FEC settings
can be shown.

Signed-off-by: Jaroslaw Gawin <jaroslawx.gawin@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 13 ++++++--
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 32 +++++++++----------
 2 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 7560f06768e0..3160b5bbe672 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -2571,9 +2571,16 @@ noinline_for_stack i40e_status i40e_update_link_info(struct i40e_hw *hw)
 		if (status)
 			return status;
 
-		hw->phy.link_info.req_fec_info =
-			abilities.fec_cfg_curr_mod_ext_info &
-			(I40E_AQ_REQUEST_FEC_KR | I40E_AQ_REQUEST_FEC_RS);
+		if (abilities.fec_cfg_curr_mod_ext_info &
+		    I40E_AQ_ENABLE_FEC_AUTO)
+			hw->phy.link_info.req_fec_info =
+				(I40E_AQ_REQUEST_FEC_KR |
+				 I40E_AQ_REQUEST_FEC_RS);
+		else
+			hw->phy.link_info.req_fec_info =
+				abilities.fec_cfg_curr_mod_ext_info &
+				(I40E_AQ_REQUEST_FEC_KR |
+				 I40E_AQ_REQUEST_FEC_RS);
 
 		memcpy(hw->phy.link_info.module_type, &abilities.module_type,
 		       sizeof(hw->phy.link_info.module_type));
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 41e1240acaea..b577e6adf3bf 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -722,7 +722,14 @@ static void i40e_get_settings_link_up_fec(u8 req_fec_info,
 	ethtool_link_ksettings_add_link_mode(ks, supported, FEC_RS);
 	ethtool_link_ksettings_add_link_mode(ks, supported, FEC_BASER);
 
-	if (I40E_AQ_SET_FEC_REQUEST_RS & req_fec_info) {
+	if ((I40E_AQ_SET_FEC_REQUEST_RS & req_fec_info) &&
+	    (I40E_AQ_SET_FEC_REQUEST_KR & req_fec_info)) {
+		ethtool_link_ksettings_add_link_mode(ks, advertising,
+						     FEC_NONE);
+		ethtool_link_ksettings_add_link_mode(ks, advertising,
+						     FEC_BASER);
+		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_RS);
+	} else if (I40E_AQ_SET_FEC_REQUEST_RS & req_fec_info) {
 		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_RS);
 	} else if (I40E_AQ_SET_FEC_REQUEST_KR & req_fec_info) {
 		ethtool_link_ksettings_add_link_mode(ks, advertising,
@@ -730,12 +737,6 @@ static void i40e_get_settings_link_up_fec(u8 req_fec_info,
 	} else {
 		ethtool_link_ksettings_add_link_mode(ks, advertising,
 						     FEC_NONE);
-		if (I40E_AQ_SET_FEC_AUTO & req_fec_info) {
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     FEC_RS);
-			ethtool_link_ksettings_add_link_mode(ks, advertising,
-							     FEC_BASER);
-		}
 	}
 }
 
@@ -1437,6 +1438,7 @@ static int i40e_get_fec_param(struct net_device *netdev,
 	struct i40e_hw *hw = &pf->hw;
 	i40e_status status = 0;
 	int err = 0;
+	u8 fec_cfg;
 
 	/* Get the current phy config */
 	memset(&abilities, 0, sizeof(abilities));
@@ -1448,18 +1450,16 @@ static int i40e_get_fec_param(struct net_device *netdev,
 	}
 
 	fecparam->fec = 0;
-	if (abilities.fec_cfg_curr_mod_ext_info & I40E_AQ_SET_FEC_AUTO)
+	fec_cfg = abilities.fec_cfg_curr_mod_ext_info;
+	if (fec_cfg & I40E_AQ_SET_FEC_AUTO)
 		fecparam->fec |= ETHTOOL_FEC_AUTO;
-	if ((abilities.fec_cfg_curr_mod_ext_info &
-	     I40E_AQ_SET_FEC_REQUEST_RS) ||
-	    (abilities.fec_cfg_curr_mod_ext_info &
-	     I40E_AQ_SET_FEC_ABILITY_RS))
+	else if (fec_cfg & (I40E_AQ_SET_FEC_REQUEST_RS |
+		 I40E_AQ_SET_FEC_ABILITY_RS))
 		fecparam->fec |= ETHTOOL_FEC_RS;
-	if ((abilities.fec_cfg_curr_mod_ext_info &
-	     I40E_AQ_SET_FEC_REQUEST_KR) ||
-	    (abilities.fec_cfg_curr_mod_ext_info & I40E_AQ_SET_FEC_ABILITY_KR))
+	else if (fec_cfg & (I40E_AQ_SET_FEC_REQUEST_KR |
+		 I40E_AQ_SET_FEC_ABILITY_KR))
 		fecparam->fec |= ETHTOOL_FEC_BASER;
-	if (abilities.fec_cfg_curr_mod_ext_info == 0)
+	if (fec_cfg == 0)
 		fecparam->fec |= ETHTOOL_FEC_OFF;
 
 	if (hw->phy.link_info.fec_info & I40E_AQ_CONFIG_FEC_KR_ENA)
-- 
2.20.1



