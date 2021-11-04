Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDF2445499
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhKDOQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:16:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230409AbhKDOQV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:16:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5A7B60F39;
        Thu,  4 Nov 2021 14:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035222;
        bh=l7UhRaq34zKHUBGYnqwMnRAqkcflnS14kJzzZVuecjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d32LWl7nwZRNo88ReAAFfUN/DqaFglvDEvPijuC3XSX8oJm5bFzkKI29tZn0ufJjP
         A0t8B3Mn6kuANG0U6ZzXO7Hzw+RtOvnuAqj7vSBHUjdc1YH431B5c+AFd1QfRa++Xy
         tIU1FFIvdkoSgfAN85ldaBEU7TaEtkCl9j4u7vlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erik Ekman <erik@kryo.se>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 01/12] sfc: Fix reading non-legacy supported link modes
Date:   Thu,  4 Nov 2021 15:12:27 +0100
Message-Id: <20211104141159.596099306@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141159.551636584@linuxfoundation.org>
References: <20211104141159.551636584@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erik Ekman <erik@kryo.se>

commit 041c61488236a5a84789083e3d9f0a51139b6edf upstream.

Everything except the first 32 bits was lost when the pause flags were
added. This makes the 50000baseCR2 mode flag (bit 34) not appear.

I have tested this with a 10G card (SFN5122F-R7) by modifying it to
return a non-legacy link mode (10000baseCR).

Signed-off-by: Erik Ekman <erik@kryo.se>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/ethtool_common.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -563,20 +563,14 @@ int efx_ethtool_get_link_ksettings(struc
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	struct efx_link_state *link_state = &efx->link_state;
-	u32 supported;
 
 	mutex_lock(&efx->mac_lock);
 	efx_mcdi_phy_get_link_ksettings(efx, cmd);
 	mutex_unlock(&efx->mac_lock);
 
 	/* Both MACs support pause frames (bidirectional and respond-only) */
-	ethtool_convert_link_mode_to_legacy_u32(&supported,
-						cmd->link_modes.supported);
-
-	supported |= SUPPORTED_Pause | SUPPORTED_Asym_Pause;
-
-	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported,
-						supported);
+	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
+	ethtool_link_ksettings_add_link_mode(cmd, supported, Asym_Pause);
 
 	if (LOOPBACK_INTERNAL(efx)) {
 		cmd->base.speed = link_state->speed;


