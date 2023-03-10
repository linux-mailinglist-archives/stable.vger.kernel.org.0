Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD5A6B4550
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbjCJOdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbjCJOcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:32:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6981219E0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:31:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB102B822DA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46682C433D2;
        Fri, 10 Mar 2023 14:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458707;
        bh=8Mn9WFMsr8HqliZn3JEuqHyTcWqqmoXVhAv+VXJ8HEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytkRsjGSEwDYpHMlpXGcVXTv8YMX9sqRTKJvZYbz6BWwQnPrlmy45kTGxipJ7tBbY
         aYGkxRMsj0dE2kVS3HxoSiXzZ0m9fXxO0oYeW5ZoJZMM9nXrmkKp4Odbzjf/hO1//j
         Zc6ck2vZQ07qh6QiXBKasseKa5IFKymg7crQ9FDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/357] wifi: mwifiex: fix loop iterator in mwifiex_update_ampdu_txwinsize()
Date:   Fri, 10 Mar 2023 14:36:16 +0100
Message-Id: <20230310133737.831201180@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 3cfb7df24cee0f5fdc4cc5d3176cab9aadfcb430 ]

This code re-uses "i" to be the iterator for both the inside and outside
loops.  It means the outside loop will exit earlier than intended.

Fixes: d219b7eb3792 ("mwifiex: handle BT coex event to adjust Rx BA window size")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/Y+ERnaDaZD7RtLvX@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/11n.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n.c b/drivers/net/wireless/marvell/mwifiex/11n.c
index acbef9f1a83b6..b397a7e85e6b0 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n.c
@@ -890,7 +890,7 @@ mwifiex_send_delba_txbastream_tbl(struct mwifiex_private *priv, u8 tid)
  */
 void mwifiex_update_ampdu_txwinsize(struct mwifiex_adapter *adapter)
 {
-	u8 i;
+	u8 i, j;
 	u32 tx_win_size;
 	struct mwifiex_private *priv;
 
@@ -921,8 +921,8 @@ void mwifiex_update_ampdu_txwinsize(struct mwifiex_adapter *adapter)
 		if (tx_win_size != priv->add_ba_param.tx_win_size) {
 			if (!priv->media_connected)
 				continue;
-			for (i = 0; i < MAX_NUM_TID; i++)
-				mwifiex_send_delba_txbastream_tbl(priv, i);
+			for (j = 0; j < MAX_NUM_TID; j++)
+				mwifiex_send_delba_txbastream_tbl(priv, j);
 		}
 	}
 }
-- 
2.39.2



