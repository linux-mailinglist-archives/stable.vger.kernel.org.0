Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E986C32850A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235322AbhCAQr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:47:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:43350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231848AbhCAQjV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:39:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10A7864F8C;
        Mon,  1 Mar 2021 16:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616106;
        bh=0bMpJi6ha4zhBMvaKTojmeQc8jHDDwZtpVVqENikCEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qt4LjynISjrquLELKPtpKLV/oKdYLY+Hbt1EEP9K2Wr0oMWJsJmJZI8VtjjP/NzWg
         ccX2OcXUrzeoZPi3PwdVtHMDpsTxeI08FP5ayfQSthZTayqlwevYprGv7P4NczJuxr
         SwTsahePwEhehBf7XkumXb9KegisRpYLz7qFNf9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <ljp@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 037/176] ibmvnic: skip send_request_unmap for timeout reset
Date:   Mon,  1 Mar 2021 17:11:50 +0100
Message-Id: <20210301161022.823990564@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Pan <ljp@linux.ibm.com>

[ Upstream commit 7d3a7b9ea59ddb223aec59b45fa1713c633aaed4 ]

Timeout reset will trigger the VIOS to unmap it automatically,
similarly as FAILVOER and MOBILITY events. If we unmap it
in the linux side, we will see errors like
"30000003: Error 4 in REQUEST_UNMAP_RSP".
So, don't call send_request_unmap for timeout reset.

Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index ec2dce057395a..4771dbee96819 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -201,8 +201,13 @@ static void free_long_term_buff(struct ibmvnic_adapter *adapter,
 	if (!ltb->buff)
 		return;
 
+	/* VIOS automatically unmaps the long term buffer at remote
+	 * end for the following resets:
+	 * FAILOVER, MOBILITY, TIMEOUT.
+	 */
 	if (adapter->reset_reason != VNIC_RESET_FAILOVER &&
-	    adapter->reset_reason != VNIC_RESET_MOBILITY)
+	    adapter->reset_reason != VNIC_RESET_MOBILITY &&
+	    adapter->reset_reason != VNIC_RESET_TIMEOUT)
 		send_request_unmap(adapter, ltb->map_id);
 	dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
 }
-- 
2.27.0



