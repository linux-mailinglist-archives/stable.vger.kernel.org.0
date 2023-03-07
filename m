Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8DC76AEE3B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbjCGSK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbjCGSKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:10:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEA7A4032
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:04:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F7AE61526
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A05FC433D2;
        Tue,  7 Mar 2023 18:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212282;
        bh=zGHRFoAzOqbZoTr8Eb9g8FmawEQ02ZQvdjQ+SCzP5lI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5iYn5sUnvPyTjUMqnMMxPJXeIAoASESySi9M0CuppOV66ooDIVk+nYrz+jpraGxJ
         cVY6VETKxCDfkhZaU4x4iFospQOEoqYwjyPcFHqsIx5PSuS5CKpQpojucwcKODFZSB
         GMKMz+tVPXzT1rMQyWPiC4zQI71/I+q7K0L1julg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/885] wifi: libertas: if_usb: dont call kfree_skb() under spin_lock_irqsave()
Date:   Tue,  7 Mar 2023 17:51:09 +0100
Message-Id: <20230307170007.730236178@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 3968e81ba644f10a7d45bae2539560db9edac501 ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So replace kfree_skb()
with dev_kfree_skb_irq() under spin_lock_irqsave(). Compile
tested only.

Fixes: a3128feef6d5 ("libertas: use irqsave() in USB's complete callback")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221207150008.111743-3-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/if_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
index 32fdc4150b605..2240b4db8c036 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -637,7 +637,7 @@ static inline void process_cmdrequest(int recvlength, uint8_t *recvbuff,
 	priv->resp_len[i] = (recvlength - MESSAGE_HEADER_LEN);
 	memcpy(priv->resp_buf[i], recvbuff + MESSAGE_HEADER_LEN,
 		priv->resp_len[i]);
-	kfree_skb(skb);
+	dev_kfree_skb_irq(skb);
 	lbs_notify_command_response(priv, i);
 
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
-- 
2.39.2



