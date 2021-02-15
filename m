Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC9F31BD23
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbhBOPkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:40:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:50214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231503AbhBOPhy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:37:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85AA964EE6;
        Mon, 15 Feb 2021 15:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403210;
        bh=YRSsPjhU5NSqReLOkiilngwVizIj9OU4Bj324PZBaew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSeUol0Dt+wVO1+ffYIk2ijxxybURwzX0r/5oNVj6uSL39rZDO7ESUZPTn9XlZ2Ms
         Udb7Cp8PT18Ll4gVwkoXpL1bYSiI9iUrW53yfkXtiVFLnIkLX/fT9mDBuc8ydsbNx6
         GpcdiuKJyB+o8MyydnQJT2bKZQaBP4lr25SaAue0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Cristobal Forno <cforno12@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/104] ibmvnic: Clear failover_pending if unable to schedule
Date:   Mon, 15 Feb 2021 16:27:21 +0100
Message-Id: <20210215152721.661356833@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
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
index 2f281d0f98070..ee16e0e4fa5fc 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4813,7 +4813,22 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
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



