Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34472D9F8C
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440534AbgLNStW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:49:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:46104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502269AbgLNRhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:45 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 018/105] ibmvnic: delay next reset if hard reset fails
Date:   Mon, 14 Dec 2020 18:27:52 +0100
Message-Id: <20201214172556.148598300@linuxfoundation.org>
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

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit f15fde9d47b887b406f5e76490d601cfc26643c9 ]

If auto-priority failover is enabled, the backing device needs time
to settle if hard resetting fails for any reason. Add a delay of 60
seconds before retrying the hard-reset.

Fixes: 2770a7984db5 ("ibmvnic: Introduce hard reset recovery")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index f892cb4a08f4e..006670f318bf1 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2243,6 +2243,14 @@ static void __ibmvnic_reset(struct work_struct *work)
 				rc = do_hard_reset(adapter, rwi, reset_state);
 				rtnl_unlock();
 			}
+			if (rc) {
+				/* give backing device time to settle down */
+				netdev_dbg(adapter->netdev,
+					   "[S:%d] Hard reset failed, waiting 60 secs\n",
+					   adapter->state);
+				set_current_state(TASK_UNINTERRUPTIBLE);
+				schedule_timeout(60 * HZ);
+			}
 		} else if (!(rwi->reset_reason == VNIC_RESET_FATAL &&
 				adapter->from_passive_init)) {
 			rc = do_reset(adapter, rwi, reset_state);
-- 
2.27.0



