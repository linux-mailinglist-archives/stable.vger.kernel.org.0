Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26924657C55
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbiL1Pbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233838AbiL1PbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:31:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71DA15F35
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:31:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 430016154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFCEC433D2;
        Wed, 28 Dec 2022 15:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241482;
        bh=uY69BWEonealXJRxRIe5Mc0O8gFvWHAWmyGV5wrFU7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZCksEWsX7M/elAjk8XjQ2LPRHQULPZpJ4+y22qimgJyrNVmNxu0s3qnyG6Xljefr
         Lk3vmuQfU579CR5k92Z5tUnGs+nb1yfTl5zYzrLlm8WrptSsXPLRU3YiRlZt5wvqD+
         W/+Tw5rPtRLmgVV4wX9MTeNOol1HejtbM3DuufyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 487/731] staging: rtl8192u: Fix use after free in ieee80211_rx()
Date:   Wed, 28 Dec 2022 15:39:54 +0100
Message-Id: <20221228144310.665518976@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit bcc5e2dcf09089b337b76fc1a589f6ff95ca19ac ]

We cannot dereference the "skb" pointer after calling
ieee80211_monitor_rx(), because it is a use after free.

Fixes: 8fc8598e61f6 ("Staging: Added Realtek rtl8192u driver to staging")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/r/Y33BArx3k/aw6yv/@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index b58e75932ecd..3686b3c599ce 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -951,9 +951,11 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 #endif
 
 	if (ieee->iw_mode == IW_MODE_MONITOR) {
+		unsigned int len = skb->len;
+
 		ieee80211_monitor_rx(ieee, skb, rx_stats);
 		stats->rx_packets++;
-		stats->rx_bytes += skb->len;
+		stats->rx_bytes += len;
 		return 1;
 	}
 
-- 
2.35.1



