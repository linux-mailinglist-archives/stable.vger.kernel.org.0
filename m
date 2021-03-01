Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCEB6328675
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbhCARKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:10:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:35190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235978AbhCARED (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:04:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2198964F3B;
        Mon,  1 Mar 2021 16:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616732;
        bh=p5FXNcqSeVES+LWvUUwn3px+TbM2dlAivgzrRcQb9OA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dVekGxBEau1lQr/vdPnQKRN0KQEOfeyIdktPs2xQqYobx5eUetjHy+WgWH+kpFfkz
         3TdASppMCXM1SBJM0l3NMK5RJ+y9G5LSzGjwvAk8IUUJ7W608abECsLzEonblGaHNN
         fq84vgATfVTI/y2Ty+FIgTCndbQEV9jhdvt0PJxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 059/247] bnxt_en: reverse order of TX disable and carrier off
Date:   Mon,  1 Mar 2021 17:11:19 +0100
Message-Id: <20210301161034.547407173@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index db1a23b8d531d..44ed2f6e2d96c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6298,9 +6298,10 @@ void bnxt_tx_disable(struct bnxt *bp)
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



