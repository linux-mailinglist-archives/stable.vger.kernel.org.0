Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33CA551D10
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbiFTNKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245430AbiFTNIr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:08:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0771C101;
        Mon, 20 Jun 2022 06:02:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB75CB811C5;
        Mon, 20 Jun 2022 13:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226D5C3411B;
        Mon, 20 Jun 2022 13:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730125;
        bh=2aLdP/aNbtKqn9jTpTpT0xifj7OJXFEgTqbU/YlfGfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKxUuKIAZ3JIx8HVJAnWrQ7m30Q95Ga8jZCUX2wldw9sz+2HLJgKJ+R88kpokoLHt
         2Bs1hkYFGawk5vAZkO9aH7Gq3rd+bxPytBt6t0y+x9TQtt7TElCI3+Bv1jQ3SeXiU7
         p7F4jmxUIKLvc6Ws/QVY/tG1ezRC/caoCBHMrS3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/84] nfc: nfcmrvl: Fix memory leak in nfcmrvl_play_deferred
Date:   Mon, 20 Jun 2022 14:50:50 +0200
Message-Id: <20220620124721.698311618@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
References: <20220620124720.882450983@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>

[ Upstream commit 8a4d480702b71184fabcf379b80bf7539716752e ]

Similar to the handling of play_deferred in commit 19cfe912c37b
("Bluetooth: btusb: Fix memory leak in play_deferred"), we thought
a patch might be needed here as well.

Currently usb_submit_urb is called directly to submit deferred tx
urbs after unanchor them.

So the usb_giveback_urb_bh would failed to unref it in usb_unanchor_urb
and cause memory leak.

Put those urbs in tx_anchor to avoid the leak, and also fix the error
handling.

Signed-off-by: Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220607083230.6182-1-xiaohuizhang@ruc.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/nfcmrvl/usb.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
index 888e298f610b..f26986eb53f1 100644
--- a/drivers/nfc/nfcmrvl/usb.c
+++ b/drivers/nfc/nfcmrvl/usb.c
@@ -401,13 +401,25 @@ static void nfcmrvl_play_deferred(struct nfcmrvl_usb_drv_data *drv_data)
 	int err;
 
 	while ((urb = usb_get_from_anchor(&drv_data->deferred))) {
+		usb_anchor_urb(urb, &drv_data->tx_anchor);
+
 		err = usb_submit_urb(urb, GFP_ATOMIC);
-		if (err)
+		if (err) {
+			kfree(urb->setup_packet);
+			usb_unanchor_urb(urb);
+			usb_free_urb(urb);
 			break;
+		}
 
 		drv_data->tx_in_flight++;
+		usb_free_urb(urb);
+	}
+
+	/* Cleanup the rest deferred urbs. */
+	while ((urb = usb_get_from_anchor(&drv_data->deferred))) {
+		kfree(urb->setup_packet);
+		usb_free_urb(urb);
 	}
-	usb_scuttle_anchored_urbs(&drv_data->deferred);
 }
 
 static int nfcmrvl_resume(struct usb_interface *intf)
-- 
2.35.1



