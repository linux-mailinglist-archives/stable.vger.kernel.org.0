Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0290322F258
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730484AbgG0Ojb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:39:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729378AbgG0OJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:09:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1246A2083E;
        Mon, 27 Jul 2020 14:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595858994;
        bh=TIhLDenDiUzlHo0WlCWSDO4biF+szFVqHksXro8nHYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mq9nbZHMCeqzbPJtzXKqPGi+vwJ11lMQUF/Fg6lyAITTzf5gHsIOzB0MbrAwuOFR/
         BayaY+Ly8inpZLXIaZQ36MHtkS2NtKOgYEp9A+CK/gX7PNobUPxvgvzdlj4zTR2e8f
         WK/HjEnUWIYLMCKv1U9kc4A9iPfShwFHdYWrB48Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/86] bnxt_en: Fix race when modifying pause settings.
Date:   Mon, 27 Jul 2020 16:03:59 +0200
Message-Id: <20200727134915.625690928@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
References: <20200727134914.312934924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 163e9ef63641a02de4c95cd921577265c52e1ce2 ]

The driver was modified to not rely on rtnl lock to protect link
settings about 2 years ago.  The pause setting was missed when
making that change.  Fix it by acquiring link_lock mutex before
calling bnxt_hwrm_set_pause().

Fixes: e2dc9b6e38fa ("bnxt_en: Don't use rtnl lock to protect link change logic in workqueue.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 047024717d654..63730e449e088 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1392,8 +1392,11 @@ static int bnxt_set_pauseparam(struct net_device *dev,
 	if (epause->tx_pause)
 		link_info->req_flow_ctrl |= BNXT_LINK_PAUSE_TX;
 
-	if (netif_running(dev))
+	if (netif_running(dev)) {
+		mutex_lock(&bp->link_lock);
 		rc = bnxt_hwrm_set_pause(bp);
+		mutex_unlock(&bp->link_lock);
+	}
 	return rc;
 }
 
-- 
2.25.1



