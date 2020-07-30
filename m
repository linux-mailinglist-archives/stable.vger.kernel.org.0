Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F05232D4A
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbgG3II4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:08:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729624AbgG3IIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:08:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D307720838;
        Thu, 30 Jul 2020 08:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096530;
        bh=kn6xsBvh+/OHG6/QlVSA/8ITK530MiBVTVqzv90rQBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3drLSpxgBkiJHHtGnbful1g8Jhn7ea5nExRTwHiydDjovtVAtvLpNf6mz61Y6qPk
         D0eIpRg2aW8z+VCgtGy/U57Oahyaq9KNP4tNPSJIclw/GoKTnJox8w4taUL4wfaUH/
         3F8CiNvldD1ydeHtxFVGNWiSF60GTMhWKgPWzYes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 15/61] bnxt_en: Fix race when modifying pause settings.
Date:   Thu, 30 Jul 2020 10:04:33 +0200
Message-Id: <20200730074421.565483568@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.811058810@linuxfoundation.org>
References: <20200730074420.811058810@linuxfoundation.org>
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
index 3a352f76e633c..427d4dbc97354 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1023,8 +1023,11 @@ static int bnxt_set_pauseparam(struct net_device *dev,
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



