Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70FA31576B4
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbgBJMyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:54:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:45274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729283AbgBJMl4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:56 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67D4121569;
        Mon, 10 Feb 2020 12:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338516;
        bh=Uf/P5d/5TrksL8ea7MV227yLCwb075Ldl4o4O86/dTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bjd12VzgOl5SST5oK/OCHV4+NZjN2LQcxahkMjf47AJ/JRRTfdvj2jc/3cUbaIv21
         LaI3YdBuE05vRo1+2P58jYo27Q+w9V/xUpomnQ5kWlLaSXQNgxIV0VyuHJtrDsVFRn
         eBn/F6RyBzFUNZ/ve0mfkqoMjCRztR+40WQEcngs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 325/367] net: systemport: Avoid RBUF stuck in Wake-on-LAN mode
Date:   Mon, 10 Feb 2020 04:33:58 -0800
Message-Id: <20200210122452.954848786@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 263a425a482fc495d6d3f9a29b9103a664c38b69 ]

After a number of suspend and resume cycles, it is possible for the RBUF
to be stuck in Wake-on-LAN mode, despite the MPD enable bit being
cleared which instructed the RBUF to exit that mode.

Avoid creating that problematic condition by clearing the RX_EN and
TX_EN bits in the UniMAC prior to disable the Magic Packet Detector
logic which is guaranteed to make the RBUF exit Wake-on-LAN mode.

Fixes: 83e82f4c706b ("net: systemport: add Wake-on-LAN support")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2728,6 +2728,9 @@ static int __maybe_unused bcm_sysport_re
 
 	umac_reset(priv);
 
+	/* Disable the UniMAC RX/TX */
+	umac_enable_set(priv, CMD_RX_EN | CMD_TX_EN, 0);
+
 	/* We may have been suspended and never received a WOL event that
 	 * would turn off MPD detection, take care of that now
 	 */


