Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7263287E2
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237868AbhCARaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:30:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238348AbhCARYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:24:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 110A764FA0;
        Mon,  1 Mar 2021 16:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617386;
        bh=gLLEk/uZpPk1SFW8KsGU3BJ8hJZX+S/aXhbNJxBUDjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XHWAP53wG4L/UQqABa5XrShF/X5uvbvuW3PXxM6awCOw5P0E7jwY9wNEpImkWWmxn
         VUvjuT9gbcKfBL6wOeBbRy/y3ELoX5GoSq8nleqS/zG90+1CYoFEKLHsMZ9rd9aBtq
         4dTnJSybAMl/60XaQR38OdHgcfoIFj/zX1PvOvoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/340] bnxt_en: reverse order of TX disable and carrier off
Date:   Mon,  1 Mar 2021 17:09:59 +0100
Message-Id: <20210301161051.026077391@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

[ Upstream commit 132e0b65dc2b8bfa9721bfce834191f24fd1d7ed ]

A TX queue can potentially immediately timeout after it is stopped
and the last TX timestamp on that queue was more than 5 seconds ago with
carrier still up.  Prevent these intermittent false TX timeouts
by bringing down carrier first before calling netif_tx_disable().

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7c8187d386756..4ae49d92c1eed 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8347,9 +8347,10 @@ void bnxt_tx_disable(struct bnxt *bp)
 			txr->dev_state = BNXT_DEV_STATE_CLOSING;
 		}
 	}
+	/* Drop carrier first to prevent TX timeout */
+	netif_carrier_off(bp->dev);
 	/* Stop all TX queues */
 	netif_tx_disable(bp->dev);
-	netif_carrier_off(bp->dev);
 }
 
 void bnxt_tx_enable(struct bnxt *bp)
-- 
2.27.0



