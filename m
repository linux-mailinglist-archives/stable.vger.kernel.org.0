Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1B931BC99
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhBOPcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:32:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231207AbhBOPbM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:31:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C9AC64E93;
        Mon, 15 Feb 2021 15:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613402964;
        bh=Os9Gvae+8O6XOG788aNLZtLpM/vJrIWunQYgZHZf+yM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADvOCKrQ7NWyFMokjfN0thj5QMl4/HYu/7XrGFMqbvqKHvQAEugw8euCTtYNTcK5m
         oWiULRVgM/4Jfw6vyaYaI8NPpv118Zoum90FzVLTMotnAp5Nohzt8HAsq97sBuZf4S
         MVGVZH1xhhCkunMvPyUK1jwQIb5CL30ETIPutFGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Cristobal Forno <cforno12@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 36/60] ibmvnic: Clear failover_pending if unable to schedule
Date:   Mon, 15 Feb 2021 16:27:24 +0100
Message-Id: <20210215152716.509673232@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit ef66a1eace968ff22a35f45e6e8ec36b668b6116 ]

Normally we clear the failover_pending flag when processing the reset.
But if we are unable to schedule a failover reset we must clear the
flag ourselves. We could fail to schedule the reset if we are in PROBING
state (eg: when booting via kexec) or because we could not allocate memory.

Thanks to Cris Forno for helping isolate the problem and for testing.

Fixes: 1d8504937478 ("powerpc/vnic: Extend "failover pending" window")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Tested-by: Cristobal Forno <cforno12@linux.ibm.com>
Link: https://lore.kernel.org/r/20210203050802.680772-1-sukadev@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index c3079f436f6d7..0f35eec967ae8 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4595,7 +4595,22 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 				complete(&adapter->init_done);
 				adapter->init_done_rc = -EIO;
 			}
-			ibmvnic_reset(adapter, VNIC_RESET_FAILOVER);
+			rc = ibmvnic_reset(adapter, VNIC_RESET_FAILOVER);
+			if (rc && rc != -EBUSY) {
+				/* We were unable to schedule the failover
+				 * reset either because the adapter was still
+				 * probing (eg: during kexec) or we could not
+				 * allocate memory. Clear the failover_pending
+				 * flag since no one else will. We ignore
+				 * EBUSY because it means either FAILOVER reset
+				 * is already scheduled or the adapter is
+				 * being removed.
+				 */
+				netdev_err(netdev,
+					   "Error %ld scheduling failover reset\n",
+					   rc);
+				adapter->failover_pending = false;
+			}
 			break;
 		case IBMVNIC_CRQ_INIT_COMPLETE:
 			dev_info(dev, "Partner initialization complete\n");
-- 
2.27.0



