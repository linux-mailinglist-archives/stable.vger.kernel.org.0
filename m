Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00372353E19
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237762AbhDEJDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:03:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237758AbhDEJDt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:03:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B829461002;
        Mon,  5 Apr 2021 09:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613422;
        bh=QcNXnSVmXrXkWqBMo8aKIO5UO5URExCFruvGfncUgoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MiBScH/vCYStDWzztROSFU9HRIgx6s5HR2AisoZrDzpkdxbmivN+n4sbKcWLV4Oz5
         175/rwJEPfNI85JzIzTq6gbcQPZKZJwpw49j3sGFkUxQSr4vvJSo7TqfX8K7sN4w8c
         cexcjrnGHdgQyOwOcx1+yt0Bj4FH/ivQDcivPiHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Stefan Chulski <stefanc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 30/74] net: mvpp2: fix interrupt mask/unmask skip condition
Date:   Mon,  5 Apr 2021 10:53:54 +0200
Message-Id: <20210405085025.721941176@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085024.703004126@linuxfoundation.org>
References: <20210405085024.703004126@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7867299cde34e9c2d2c676f2a384a9d5853b914d ]

The condition should be skipped if CPU ID equal to nthreads.
The patch doesn't fix any actual issue since
nthreads = min_t(unsigned int, num_present_cpus(), MVPP2_MAX_THREADS).
On all current Armada platforms, the number of CPU's is
less than MVPP2_MAX_THREADS.

Fixes: e531f76757eb ("net: mvpp2: handle cases where more CPUs are available than s/w threads")
Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 9a77b70ad601..491bcfd36ac2 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1073,7 +1073,7 @@ static void mvpp2_interrupts_unmask(void *arg)
 	u32 val;
 
 	/* If the thread isn't used, don't do anything */
-	if (smp_processor_id() > port->priv->nthreads)
+	if (smp_processor_id() >= port->priv->nthreads)
 		return;
 
 	val = MVPP2_CAUSE_MISC_SUM_MASK |
@@ -2078,7 +2078,7 @@ static void mvpp2_txq_sent_counter_clear(void *arg)
 	int queue;
 
 	/* If the thread isn't used, don't do anything */
-	if (smp_processor_id() > port->priv->nthreads)
+	if (smp_processor_id() >= port->priv->nthreads)
 		return;
 
 	for (queue = 0; queue < port->ntxqs; queue++) {
-- 
2.30.1



