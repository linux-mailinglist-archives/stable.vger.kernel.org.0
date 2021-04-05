Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41763353F0E
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238326AbhDEJKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238770AbhDEJJE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:09:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A185861002;
        Mon,  5 Apr 2021 09:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613738;
        bh=GNebsQ0RmuIdCTd34ox0MGOrj7dx/zOs46EZTK8u5oE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7bLm8866xfweyTP5NEf8xyTn8+MPBfiNNv6WsmsuL47hHF+PabgAGfdhC+AO58Mp
         N7zKvOvH/S0vvlqnd7ZMImzVDCJ0UgcW2O10bHHCHAJLu7We/xeV9gBHJMiTu39UGb
         vTmv9Nh4rSOccBf+fCxaCo5bxeyMGwNmsFS5RphU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Stefan Chulski <stefanc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/126] net: mvpp2: fix interrupt mask/unmask skip condition
Date:   Mon,  5 Apr 2021 10:53:19 +0200
Message-Id: <20210405085032.277628334@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
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
index d1f7b51cab62..f5333fc27e14 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1153,7 +1153,7 @@ static void mvpp2_interrupts_unmask(void *arg)
 	u32 val;
 
 	/* If the thread isn't used, don't do anything */
-	if (smp_processor_id() > port->priv->nthreads)
+	if (smp_processor_id() >= port->priv->nthreads)
 		return;
 
 	val = MVPP2_CAUSE_MISC_SUM_MASK |
@@ -2287,7 +2287,7 @@ static void mvpp2_txq_sent_counter_clear(void *arg)
 	int queue;
 
 	/* If the thread isn't used, don't do anything */
-	if (smp_processor_id() > port->priv->nthreads)
+	if (smp_processor_id() >= port->priv->nthreads)
 		return;
 
 	for (queue = 0; queue < port->ntxqs; queue++) {
-- 
2.30.1



