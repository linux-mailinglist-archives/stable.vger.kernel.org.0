Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268354832AB
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbiACOaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:30:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60116 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234342AbiACO2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:28:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 326FEB80EF6;
        Mon,  3 Jan 2022 14:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E68CC36AEB;
        Mon,  3 Jan 2022 14:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220123;
        bh=sc5DPwU+l2GQloPVMmLyaws1M/V/9eBczfwPNjl1ZOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2iy29AJ93beySy0ia7Kq/6w52/b7lQzEwFWuNSLe1MTfF3hOvCYzTgqPj7NAWNeN
         +WY27SzjZDnXX1Na8GccpV6FZHGVyPcd4v8GJJkpfdGPnP/kp+dDbI3XsKSYN53WB4
         D5FGJPnPVpQ33G3EGqkJNz7Fa3Ta3NNZioIQVAdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 18/48] net/smc: fix using of uninitialized completions
Date:   Mon,  3 Jan 2022 15:23:55 +0100
Message-Id: <20220103142054.093098564@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
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
index 9dbe4804853e0..a71c9631f1ad3 100644
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



