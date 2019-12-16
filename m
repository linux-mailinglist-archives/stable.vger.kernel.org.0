Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5549F12124E
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfLPRvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:51:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbfLPRvk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:51:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A4DF20717;
        Mon, 16 Dec 2019 17:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518700;
        bh=6xX4GUpXtBOhRworb/C4nNl8y/xDjDpnXdqXg5c/DNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MxHilmdwXOJkBpbBIK7DxTikC9K0F8klEYkk2DjnUC4kbr5dTieACJxyAxA8vjMUN
         /2/PScPSjko8cJP5jLmj78NUBcIoiYdut/PeW9VO6aHRrwX0J5c4h9G2a8LcxwTvQT
         qI8cCZjITgSHw+qEOFZQvPujxFwAeEAQXXLRbg8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 031/267] net: ethernet: ti: cpts: correct debug for expired txq skb
Date:   Mon, 16 Dec 2019 18:45:57 +0100
Message-Id: <20191216174852.348367061@linuxfoundation.org>
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

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

[ Upstream commit d0e14c4d9bcef0d4aa1057d2959adaa6f18d4a17 ]

The msgtype and seqid that is smth that belongs to event for
comparison but not for staled txq skb.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpts.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 7d1281d812480..23c953496a0d1 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -116,9 +116,7 @@ static bool cpts_match_tx_ts(struct cpts *cpts, struct cpts_event *event)
 				mtype, seqid);
 		} else if (time_after(jiffies, skb_cb->tmo)) {
 			/* timeout any expired skbs over 1s */
-			dev_dbg(cpts->dev,
-				"expiring tx timestamp mtype %u seqid %04x\n",
-				mtype, seqid);
+			dev_dbg(cpts->dev, "expiring tx timestamp from txq\n");
 			__skb_unlink(skb, &cpts->txq);
 			dev_consume_skb_any(skb);
 		}
-- 
2.20.1



