Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D31483326
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234834AbiACOdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:33:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33094 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234859AbiACOb6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:31:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 343B461126;
        Mon,  3 Jan 2022 14:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12082C36AEB;
        Mon,  3 Jan 2022 14:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220317;
        bh=n6jPLSxdOzbikOJxPA3lUjzlbLyL0NTN+ATFBMuNdTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PxusFyle1UuHfL9TFxIrq78iUgoTn4L26YLONav/HnL4lHLGrtdLANtCQQkW5Mtke
         H7CK//+8bDSyQm3WWHyQbus63u3+qjVkVUcE7zZu7V0ENE0YlzrMBjbFoTPqCh8Eqm
         qpW80WhsREAdwSwKmHFTQ11idTJwWB4Cdj4EOR24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 30/73] net/smc: fix using of uninitialized completions
Date:   Mon,  3 Jan 2022 15:23:51 +0100
Message-Id: <20220103142057.876890217@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

[ Upstream commit 6d7373dabfd3933ee30c40fc8c09d2a788f6ece1 ]

In smc_wr_tx_send_wait() the completion on index specified by
pend->idx is initialized and after smc_wr_tx_send() was called the wait
for completion starts. pend->idx is used to get the correct index for
the wait, but the pend structure could already be cleared in
smc_wr_tx_process_cqe().
Introduce pnd_idx to hold and use a local copy of the correct index.

Fixes: 09c61d24f96d ("net/smc: wait for departure of an IB message")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_wr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index a419e9af36b98..c9cd7a4c5acfc 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -288,18 +288,20 @@ int smc_wr_tx_send_wait(struct smc_link *link, struct smc_wr_tx_pend_priv *priv,
 			unsigned long timeout)
 {
 	struct smc_wr_tx_pend *pend;
+	u32 pnd_idx;
 	int rc;
 
 	pend = container_of(priv, struct smc_wr_tx_pend, priv);
 	pend->compl_requested = 1;
-	init_completion(&link->wr_tx_compl[pend->idx]);
+	pnd_idx = pend->idx;
+	init_completion(&link->wr_tx_compl[pnd_idx]);
 
 	rc = smc_wr_tx_send(link, priv);
 	if (rc)
 		return rc;
 	/* wait for completion by smc_wr_tx_process_cqe() */
 	rc = wait_for_completion_interruptible_timeout(
-					&link->wr_tx_compl[pend->idx], timeout);
+					&link->wr_tx_compl[pnd_idx], timeout);
 	if (rc <= 0)
 		rc = -ENODATA;
 	if (rc > 0)
-- 
2.34.1



