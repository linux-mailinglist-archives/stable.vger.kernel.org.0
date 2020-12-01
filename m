Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424B62C9BC8
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389907AbgLAJMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:12:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:47718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389886AbgLAJMD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:12:03 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5015920671;
        Tue,  1 Dec 2020 09:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813907;
        bh=bS7P7B3lMjsOed17TZjqOIDLwmzE7rc+WAAwBchKx/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jeQIRDyzVbsSXqKlYTCrEbgnpe5gpHuontMehmW5sXEsyFC+fZAFac19I8hiE8Ksb
         a5tMPeZDJPPSjmjV6YCrLkawKISpXT4zulX4rSei0tTahuv/xKtjuN/W/v/iCI1t1/
         K5+F6hWlFZ54Zr2urGtUVi1q6sF+tmvjGxZRK6d4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <ljp@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 100/152] ibmvnic: fix call_netdevice_notifiers in do_reset
Date:   Tue,  1 Dec 2020 09:53:35 +0100
Message-Id: <20201201084724.963956594@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Pan <ljp@linux.ibm.com>

[ Upstream commit 8393597579f5250636f1cff157ea73f402b6501e ]

When netdev_notify_peers was substituted in
commit 986103e7920c ("net/ibmvnic: Fix RTNL deadlock during device reset"),
call_netdevice_notifiers(NETDEV_RESEND_IGMP, dev) was missed.
Fix it now.

Fixes: 986103e7920c ("net/ibmvnic: Fix RTNL deadlock during device reset")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index c6ee42278fdcf..723651b34f94d 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2087,8 +2087,10 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	for (i = 0; i < adapter->req_rx_queues; i++)
 		napi_schedule(&adapter->napi[i]);
 
-	if (adapter->reset_reason != VNIC_RESET_FAILOVER)
+	if (adapter->reset_reason != VNIC_RESET_FAILOVER) {
 		call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
+		call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
+	}
 
 	rc = 0;
 
-- 
2.27.0



