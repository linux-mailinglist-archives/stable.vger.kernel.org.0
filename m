Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A90444551E
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhKDOUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231391AbhKDOTB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:19:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F95A61247;
        Thu,  4 Nov 2021 14:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035383;
        bh=CE+rnquf1kjI51pRhEmbEFU+bjxRIYaCB9yGHCFRE6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5eEHrS7y5EhWFHzrxjwpx7qGqMVKqzeX61QmIoYRMVRgQJUMOuBcFm7wxhj2nKdh
         Vbtr3pzsPH7Ocmjh85HgMVyu3rCdSJG4uG/lcY2R/gJ4kUGYnudCYwGngs6yZmuRAW
         u7mdWeNvLsoYzkD5aEOBeCZiQXUsmGkykXD7NIu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erik Ekman <erik@kryo.se>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 5/7] sfc: Fix reading non-legacy supported link modes
Date:   Thu,  4 Nov 2021 15:13:08 +0100
Message-Id: <20211104141158.203339269@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141158.037189396@linuxfoundation.org>
References: <20211104141158.037189396@linuxfoundation.org>
User-Agent: quilt/0.66
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
 drivers/net/ethernet/sfc/ethtool.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -131,20 +131,14 @@ efx_ethtool_get_link_ksettings(struct ne
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	struct efx_link_state *link_state = &efx->link_state;
-	u32 supported;
 
 	mutex_lock(&efx->mac_lock);
 	efx->phy_op->get_link_ksettings(efx, cmd);
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


