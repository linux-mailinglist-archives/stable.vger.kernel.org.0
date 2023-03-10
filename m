Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93586B47CD
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbjCJOyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbjCJOxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:53:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9538912A165
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:49:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1D4661987
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C578C4339B;
        Fri, 10 Mar 2023 14:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459775;
        bh=ShX24Vj/5ByzE2UgYPj2pMWhe3ijvPJyhD/AfafFcdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l5v8L0iIciRmumfsiQBK4cOVyFtxIKAY5qacsdIX1QwwsuwLdxroUECasi/M8eLYy
         TmhSafBg5Ggp8SSbuBCB716iPSZrGXokd/EnVv9s7tXmJBkj6w84bE2dGgOjho64xY
         jdkE2wAUH3EUut91ua0aAjEHnSDRyfhavVR5iPcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Erhard F." <erhard_f@mailbox.org>,
        Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/529] wifi: rtl8xxxu: Fix memory leaks with RTL8723BU, RTL8192EU
Date:   Fri, 10 Mar 2023 14:33:48 +0100
Message-Id: <20230310133808.907519204@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit b39f662ce1648db0b9de32e6a849b098480793cb ]

The wifi + bluetooth combo chip RTL8723BU can leak memory (especially?)
when it's connected to a bluetooth audio device. The busy bluetooth
traffic generates lots of C2H (card to host) messages, which are not
freed correctly.

To fix this, move the dev_kfree_skb() call in rtl8xxxu_c2hcmd_callback()
inside the loop where skb_dequeue() is called.

The RTL8192EU leaks memory because the C2H messages are added to the
queue and left there forever. (This was fine in the past because it
probably wasn't sending any C2H messages until commit e542e66b7c2e
("wifi: rtl8xxxu: gen2: Turn on the rate control"). Since that commit
it sends a C2H message when the TX rate changes.)

To fix this, delete the check for rf_paths > 1 and the goto. Let the
function process the C2H messages from RTL8192EU like the ones from
the other chips.

Theoretically the RTL8188FU could also leak like RTL8723BU, but it
most likely doesn't send C2H messages frequently enough.

This change was tested with RTL8723BU by Erhard F. I tested it with
RTL8188FU and RTL8192EU.

Reported-by: Erhard F. <erhard_f@mailbox.org>
Tested-by: Erhard F. <erhard_f@mailbox.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215197
Fixes: e542e66b7c2e ("rtl8xxxu: add bluetooth co-existence support for single antenna")
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/03b099c1-c671-d252-36f4-57b70d721f9d@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index f8b1871fe290a..376782b7aba81 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5491,9 +5491,6 @@ static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
 	btcoex = &priv->bt_coex;
 	rarpt = &priv->ra_report;
 
-	if (priv->rf_paths > 1)
-		goto out;
-
 	while (!skb_queue_empty(&priv->c2hcmd_queue)) {
 		spin_lock_irqsave(&priv->c2hcmd_lock, flags);
 		skb = __skb_dequeue(&priv->c2hcmd_queue);
@@ -5547,10 +5544,9 @@ static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
 		default:
 			break;
 		}
-	}
 
-out:
-	dev_kfree_skb(skb);
+		dev_kfree_skb(skb);
+	}
 }
 
 static void rtl8723bu_handle_c2h(struct rtl8xxxu_priv *priv,
-- 
2.39.2



