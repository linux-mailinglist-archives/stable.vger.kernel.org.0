Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA40066CD29
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbjAPReM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234413AbjAPRdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:33:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467F13B65B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:09:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D771460F63
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FB1C433D2;
        Mon, 16 Jan 2023 17:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888990;
        bh=JSV+bosdVsEU1JV7xB+48Zt2N8adOG8M7/vALt+El/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YCXl+/7FrBtr7CsJw+ZPQzKuSRB0citk3pEAZvvKFFMw8Zj1mDNW9RxMq0/D/SVbZ
         QNECGG5U6VS/LLuRq+Jn7RNL+x1/H0TfhqUKi3+yu9IMeRbkRVyRWOAcqwFoc0vkRN
         Wa4ozSNQQgXR/8aV7Oh6kdsU3GLvdzjtbU9xzEc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 176/338] staging: rtl8192u: Fix use after free in ieee80211_rx()
Date:   Mon, 16 Jan 2023 16:50:49 +0100
Message-Id: <20230116154828.587314052@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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
index cbf8eb4a049d..6c529f349379 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -961,9 +961,11 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
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



