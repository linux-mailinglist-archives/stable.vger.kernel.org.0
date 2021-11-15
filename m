Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E04452624
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358466AbhKPCCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:02:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240018AbhKOSF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B88A863375;
        Mon, 15 Nov 2021 17:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998083;
        bh=tMuV80espppP2j5B2Px7CGxs5nboqBef83dpNjidzZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KoSJ/XxMvApBMunxZJLesEM+I7OHTjqk0BhRwBw6H5kIzfo2g6teTzcyd3E1MwRlo
         66F8lBd1zKDE4Y7KYes7jrzwguWsL9rOqgJ2xm/1os/wIXEaYBM8EklDBdbz2fWDsw
         tj6ZUbBQerR0dwRma3sCCgMUmj0j0tOUL1XG1klc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vaishnavi Bhat <vaish123@in.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 381/575] ibmvnic: Process crqs after enabling interrupts
Date:   Mon, 15 Nov 2021 18:01:46 +0100
Message-Id: <20211115165356.961532205@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index c470dbc03a23e..4f99d97638248 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5185,6 +5185,9 @@ static int init_crq_queue(struct ibmvnic_adapter *adapter)
 	crq->cur = 0;
 	spin_lock_init(&crq->lock);
 
+	/* process any CRQs that were queued before we enabled interrupts */
+	tasklet_schedule(&adapter->tasklet);
+
 	return retrc;
 
 req_irq_failed:
-- 
2.33.0



