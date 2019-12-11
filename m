Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9BEE11B582
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731266AbfLKPR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:17:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731391AbfLKPRY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:17:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B2DB2073D;
        Wed, 11 Dec 2019 15:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077443;
        bh=aeJN9iD2dFfWHJYWyfxdk8+zHVMsBoio6kyTZ0brv3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUrYAt6Si/Ej0BPborKQZj5QXIHgI4/9xTDoRH8yWCaIA43iVPJ+plrTc1X7S51Eo
         FmCjASuwdz8PZu2R3xRm2/lHi2YPPP4K4Jtx+wyurQvH4tNuT/hqEwcsrDQduXpkaB
         YuYfc5dVkCS5Agyyoyts5Hexo1cEVMflx937sphQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 042/243] net: ethernet: ti: cpts: correct debug for expired txq skb
Date:   Wed, 11 Dec 2019 16:03:24 +0100
Message-Id: <20191211150341.984159300@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
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
index 4f644ac314fe8..d7543811dfae2 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -119,9 +119,7 @@ static bool cpts_match_tx_ts(struct cpts *cpts, struct cpts_event *event)
 
 		if (time_after(jiffies, skb_cb->tmo)) {
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



