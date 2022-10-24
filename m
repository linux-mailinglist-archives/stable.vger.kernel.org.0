Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E89F60A501
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbiJXMUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbiJXMTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:19:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AED982775;
        Mon, 24 Oct 2022 04:58:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E574612A0;
        Mon, 24 Oct 2022 11:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B20C433C1;
        Mon, 24 Oct 2022 11:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611846;
        bh=ZM8KwLzQMU6Z+0eJcv/Gy/7anpAdhPECPWXhIWxPZPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TutMja1FKraUaEqw/6lgjY1zVXghJvHmZJaxEMlh6zC6xAqMooETO8iR8+vArGAJY
         FZkchDehEsI+Cnba2s1JQhxKejua0J4t78zrI/CUqx0MTqnxH73oiRVjwnC8SaA5tW
         9wE7NC6tirggYfTd9kIIjJD9hm+AwJXfq3xxShaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 133/159] can: bcm: check the result of can_send() in bcm_can_tx()
Date:   Mon, 24 Oct 2022 13:31:27 +0200
Message-Id: <20221024112954.335214620@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 3fd7bfd28cfd68ae80a2fe92ea1615722cc2ee6e ]

If can_send() fail, it should not update frames_abs counter
in bcm_can_tx(). Add the result check for can_send() in bcm_can_tx().

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Suggested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Link: https://lore.kernel.org/all/9851878e74d6d37aee2f1ee76d68361a46f89458.1663206163.git.william.xuanziyang@huawei.com
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/bcm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index bfb507223468..ece04ad50348 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -285,6 +285,7 @@ static void bcm_can_tx(struct bcm_op *op)
 	struct sk_buff *skb;
 	struct net_device *dev;
 	struct canfd_frame *cf = op->frames + op->cfsiz * op->currframe;
+	int err;
 
 	/* no target device? => exit */
 	if (!op->ifindex)
@@ -309,11 +310,11 @@ static void bcm_can_tx(struct bcm_op *op)
 	/* send with loopback */
 	skb->dev = dev;
 	can_skb_set_owner(skb, op->sk);
-	can_send(skb, 1);
+	err = can_send(skb, 1);
+	if (!err)
+		op->frames_abs++;
 
-	/* update statistics */
 	op->currframe++;
-	op->frames_abs++;
 
 	/* reached last frame? */
 	if (op->currframe >= op->nframes)
-- 
2.35.1



