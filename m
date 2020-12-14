Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C622DA053
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 20:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502617AbgLNTHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 14:07:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:47736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408592AbgLNRhN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:13 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 015/105] ibmvnic: handle inconsistent login with reset
Date:   Mon, 14 Dec 2020 18:27:49 +0100
Message-Id: <20201214172556.004392623@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>

[ Upstream commit 31d6b4036098f6b59bcfa20375626b500c7d7417 ]

Inconsistent login with the vnicserver is causing the device to be
removed. This does not give the device a chance to recover from error
state. This patch schedules a FATAL reset instead to bring the adapter
up.

Fixes: 032c5e82847a2 ("Driver for IBM System i/p VNIC protocol")
Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 3654be5772c85..85c54c061ed91 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4400,7 +4400,7 @@ static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
 	     adapter->req_rx_add_queues !=
 	     be32_to_cpu(login_rsp->num_rxadd_subcrqs))) {
 		dev_err(dev, "FATAL: Inconsistent login and login rsp\n");
-		ibmvnic_remove(adapter->vdev);
+		ibmvnic_reset(adapter, VNIC_RESET_FATAL);
 		return -EIO;
 	}
 	release_login_buffer(adapter);
-- 
2.27.0



