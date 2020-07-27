Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CA022EF37
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730554AbgG0OOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:14:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729978AbgG0OOb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:14:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 950C320838;
        Mon, 27 Jul 2020 14:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859271;
        bh=Z71URfF1deFG2Su/vdXfO9Wq0fh/V5I1+AEO+5F6fjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wQQ5+lJ7lasZchhevX82tBvAd84H82NbNhf5Y5jZcHWMWJBhrQ+xkimuosAPE3pyc
         hjJtULhj1+jqUpWcNGLK8YuYoW+ab2mDGVaDoaCXntH1fF7ChJKSD/Z8635qPp373Z
         6Iw10/i76cs83G1uyfP0Oze9xvkcqGSC7AUW0zbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/138] bnxt_en: Fix race when modifying pause settings.
Date:   Mon, 27 Jul 2020 16:03:51 +0200
Message-Id: <20200727134927.179295298@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
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
index fb1ab58da9fa5..1f512e7c3d434 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1688,8 +1688,11 @@ static int bnxt_set_pauseparam(struct net_device *dev,
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



