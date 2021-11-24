Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1635F45BDD0
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345215AbhKXMlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:41:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344978AbhKXMjC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:39:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5E44611AE;
        Wed, 24 Nov 2021 12:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756614;
        bh=A39GLVECFXPg0NrY+rWuO9gZOrewSwWLKv/xlRIDcZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yP4j3ndcw/WWIML7f6j3j3W55tBV1j2ynEeNwEa56z+K/X74evpLI0JbqMC/GZ8kD
         Yzr51l5j5ipMV+j01HDsHccLe+Phg/tM7W1dgLjuj4bl0LqRg0Wv0m1KFfnCWUXC/8
         jm19CkacpVY0MWUidx2LDB0Wl+wrQl67t5YpQbjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vaishnavi Bhat <vaish123@in.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 138/251] ibmvnic: Process crqs after enabling interrupts
Date:   Wed, 24 Nov 2021 12:56:20 +0100
Message-Id: <20211124115715.053086522@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit 6e20d00158f31f7631d68b86996b7e951c4451c8 ]

Soon after registering a CRQ it is possible that we get a fail over or
maybe a CRQ_INIT from the VIOS while interrupts were disabled.

Look for any such CRQs after enabling interrupts.

Otherwise we can intermittently fail to bring up ibmvnic adapters during
boot, specially in kexec/kdump kernels.

Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
Reported-by: Vaishnavi Bhat <vaish123@in.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 76ab6c0d40cf5..4befc885efb8d 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3835,6 +3835,9 @@ static int init_crq_queue(struct ibmvnic_adapter *adapter)
 	crq->cur = 0;
 	spin_lock_init(&crq->lock);
 
+	/* process any CRQs that were queued before we enabled interrupts */
+	tasklet_schedule(&adapter->tasklet);
+
 	return retrc;
 
 req_irq_failed:
-- 
2.33.0



