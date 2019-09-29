Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BACE0C158E
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbfI2OAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729310AbfI2OAv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:00:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1780121882;
        Sun, 29 Sep 2019 14:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765650;
        bh=HmPW9PA3lINIaJ32HPlnVu0zN2UyoH5PCAx7CY3Qooo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cjV7ldqlZUIkSFHh8fjcUx3DbzcnMncFXc4phRYdhkM/pEvGqwT/FwLageELlG4BJ
         HltF0NDmyrl8rAh5ork9VVf1Znl4SmOCeZtyiUgYd56U3wlMOuKhP+x3+7DUfEZXR/
         eljx/wYj9EgrFNa2Ze4ftf2mP3D230Lpyw8LHYNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juliet Kim <julietk@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 05/45] net/ibmvnic: free reset work of removed device from queue
Date:   Sun, 29 Sep 2019 15:55:33 +0200
Message-Id: <20190929135026.278403849@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
References: <20190929135024.387033930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juliet Kim <julietk@linux.vnet.ibm.com>

[ Upstream commit 1c2977c094998de032fee6e898c88b4a05483d08 ]

Commit 36f1031c51a2 ("ibmvnic: Do not process reset during or after
 device removal") made the change to exit reset if the driver has been
removed, but does not free reset work items of the adapter from queue.

Ensure all reset work items are freed when breaking out of the loop early.

Fixes: 36f1031c51a2 ("ibmnvic: Do not process reset during or after device removal”)
Signed-off-by: Juliet Kim <julietk@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index fa4bb940665c2..6644cabc8e756 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1985,7 +1985,10 @@ static void __ibmvnic_reset(struct work_struct *work)
 	while (rwi) {
 		if (adapter->state == VNIC_REMOVING ||
 		    adapter->state == VNIC_REMOVED)
-			goto out;
+			kfree(rwi);
+			rc = EBUSY;
+			break;
+		}
 
 		if (adapter->force_reset_recovery) {
 			adapter->force_reset_recovery = false;
@@ -2011,7 +2014,7 @@ static void __ibmvnic_reset(struct work_struct *work)
 		netdev_dbg(adapter->netdev, "Reset failed\n");
 		free_all_rwi(adapter);
 	}
-out:
+
 	adapter->resetting = false;
 	if (we_lock_rtnl)
 		rtnl_unlock();
-- 
2.20.1



