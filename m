Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 760DD66E8C
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfGLM0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727561AbfGLM03 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:26:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E1BD2084B;
        Fri, 12 Jul 2019 12:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934388;
        bh=jnfapKDAJb2wo6tU6rPlft0yXV1aRdTj1hfyQPk7CqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nq5BPMrbWw/pTsbGFhXg43jktsWGbgbMduSQRkpefTWraGJHSThhwSDbPf7wAOBsD
         cFdy0USIR7UUPatNG5MGbJzZTioaDCm4sFfXpa1IhAdFjMABicv/Hz3Onl03r/pfQG
         InkhWv11DyCp2yYwSD7g78PW+MjR2n8x3nDCQFYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 040/138] ibmvnic: Do not close unopened driver during reset
Date:   Fri, 12 Jul 2019 14:18:24 +0200
Message-Id: <20190712121630.214132491@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1f94608b0ce141be5286dde31270590bdf35b86a ]

Check driver state before halting it during a reset. If the driver is
not running, do nothing. Otherwise, a request to deactivate a down link
can cause an error and the reset will fail.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 3dfb2d131eb7..71bf895409a1 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1751,7 +1751,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 
 	ibmvnic_cleanup(netdev);
 
-	if (adapter->reset_reason != VNIC_RESET_MOBILITY &&
+	if (reset_state == VNIC_OPEN &&
+	    adapter->reset_reason != VNIC_RESET_MOBILITY &&
 	    adapter->reset_reason != VNIC_RESET_FAILOVER) {
 		rc = __ibmvnic_close(netdev);
 		if (rc)
-- 
2.20.1



