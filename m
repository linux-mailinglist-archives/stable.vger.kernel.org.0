Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E5245C05D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345690AbhKXNHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:07:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:47540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347295AbhKXNFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:05:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A92FB61214;
        Wed, 24 Nov 2021 12:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757459;
        bh=i0/SSP6wMqGq3MA8g9maM/Gpkd7UtDZf1BkDMRNtZtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJqOfTxfPkPg1vQz6ufA+4a4w6DaH9lgdkorxedM+9C13CnIrx5UiaqIVxP3FaHfR
         1BdzahVeeTlxV0DrBRlBg6GmwMo5AdTGK9LFY0QA+bJ8GEHqZBC1RzIZm2yW0cBT+q
         NVftCjoApMD5TuS3o+xpYuIPZlIqnT6DC6t5ezLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vaishnavi Bhat <vaish123@in.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 175/323] ibmvnic: Process crqs after enabling interrupts
Date:   Wed, 24 Nov 2021 12:56:05 +0100
Message-Id: <20211124115724.855298970@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index d97641b9928bb..c52c26fc44e59 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4603,6 +4603,9 @@ static int init_crq_queue(struct ibmvnic_adapter *adapter)
 	crq->cur = 0;
 	spin_lock_init(&crq->lock);
 
+	/* process any CRQs that were queued before we enabled interrupts */
+	tasklet_schedule(&adapter->tasklet);
+
 	return retrc;
 
 req_irq_failed:
-- 
2.33.0



