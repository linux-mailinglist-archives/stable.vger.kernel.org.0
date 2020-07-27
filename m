Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F226F22F151
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731564AbgG0OUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:20:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731556AbgG0OUb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:20:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDD6A2070A;
        Mon, 27 Jul 2020 14:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859630;
        bh=AjMYgoWuwLdnddB2k/SjLHWHh4EXgQvwQv/pxzTpU/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0X2CU7cXDG4GMj/Ggo7QUbUI9Y5TOik/aoMCW7iqgw+6YRu4uHkT4zYuoWf32Pd0i
         qmzBMG6wGu+Tta+IzsKffaydGpl6SMbq06LBzW55HwURCQV695PHpCN+xvn41CoEbz
         JX600RXCtTcqorOeHqRJR5voMXws5LuVBLLq6ilc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 044/179] bnxt_en: Init ethtool link settings after reading updated PHY configuration.
Date:   Mon, 27 Jul 2020 16:03:39 +0200
Message-Id: <20200727134934.826510479@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit ca0c753815fe4786b79a80abf0412eb5d52090b8 ]

In a shared port PHY configuration, async event is received when any of the
port modifies the configuration. Ethtool link settings should be
initialised after updated PHY configuration from firmware.

Fixes: b1613e78e98d ("bnxt_en: Add async. event logic for PHY configuration changes.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b6fb5a1709c01..198bca9c1e2df 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10362,15 +10362,15 @@ static void bnxt_sp_task(struct work_struct *work)
 				       &bp->sp_event))
 			bnxt_hwrm_phy_qcaps(bp);
 
-		if (test_and_clear_bit(BNXT_LINK_CFG_CHANGE_SP_EVENT,
-				       &bp->sp_event))
-			bnxt_init_ethtool_link_settings(bp);
-
 		rc = bnxt_update_link(bp, true);
-		mutex_unlock(&bp->link_lock);
 		if (rc)
 			netdev_err(bp->dev, "SP task can't update link (rc: %x)\n",
 				   rc);
+
+		if (test_and_clear_bit(BNXT_LINK_CFG_CHANGE_SP_EVENT,
+				       &bp->sp_event))
+			bnxt_init_ethtool_link_settings(bp);
+		mutex_unlock(&bp->link_lock);
 	}
 	if (test_and_clear_bit(BNXT_UPDATE_PHY_SP_EVENT, &bp->sp_event)) {
 		int rc;
-- 
2.25.1



