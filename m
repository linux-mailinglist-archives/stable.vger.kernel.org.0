Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C94AB121928
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbfLPRwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:52:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:44650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727522AbfLPRwg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:52:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F3752166E;
        Mon, 16 Dec 2019 17:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518755;
        bh=hps69Q6C6MR2HFsUkhbANDIaSAymGxUcBs/tQ6ONvhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h50/8cdz5GZDMSoXg4MU8iKN2j8habWJ6L4eSES8fyjnGchuCPnE20X4pYzQwoKQa
         HqVl8Z2H+tMwVnyfnyRW+yTXpmTrxoIVMth61cqBKgSdXmTxdJ4TddvCZ7HJySQW5n
         1tN/xU8arJBy5Lwl9mVIWU0my4dtJWBTr2+GiChQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 052/267] net/smc: use after free fix in smc_wr_tx_put_slot()
Date:   Mon, 16 Dec 2019 18:46:18 +0100
Message-Id: <20191216174854.223332850@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ursula Braun <ursula.braun@linux.ibm.com>

[ Upstream commit e438bae43c1e08e688c09c410407b59fc1c173b4 ]

In smc_wr_tx_put_slot() field pend->idx is used after being
cleared. That means always idx 0 is cleared in the wr_tx_mask.
This results in a broken administration of available WR send
payload buffers.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_wr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index de4537f66832a..ed6736a1a112e 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -223,12 +223,14 @@ int smc_wr_tx_put_slot(struct smc_link *link,
 
 	pend = container_of(wr_pend_priv, struct smc_wr_tx_pend, priv);
 	if (pend->idx < link->wr_tx_cnt) {
+		u32 idx = pend->idx;
+
 		/* clear the full struct smc_wr_tx_pend including .priv */
 		memset(&link->wr_tx_pends[pend->idx], 0,
 		       sizeof(link->wr_tx_pends[pend->idx]));
 		memset(&link->wr_tx_bufs[pend->idx], 0,
 		       sizeof(link->wr_tx_bufs[pend->idx]));
-		test_and_clear_bit(pend->idx, link->wr_tx_mask);
+		test_and_clear_bit(idx, link->wr_tx_mask);
 		return 1;
 	}
 
-- 
2.20.1



