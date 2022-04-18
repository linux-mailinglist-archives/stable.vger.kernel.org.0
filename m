Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4245057A3
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243986AbiDRNzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245401AbiDRNx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:53:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6403146140;
        Mon, 18 Apr 2022 06:02:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BF39B80E59;
        Mon, 18 Apr 2022 13:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEB9C385A7;
        Mon, 18 Apr 2022 13:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286964;
        bh=A4b2a4onVwfZ3Z/PUXwNCCP2ru+RSO2yvt2SPsiVLO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iK4+8E5BiawUrWP69WuV52Cz9PAdfcYVuPCKhuQioWEju5ukQ0zGtupLuL5+Z541R
         0m8iZpgiaVR7reevALJuzVWpyoJUAAwd6+RfcOX2z2pN6kkRDZhHLMN8fBNYYdIVBA
         b9LEGX2tKqVzFapNctHDsRWsRRbBOcKqwI/Yi450=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sebastian Haas <haas@ems-wuensche.com>,
        Hangyu Hua <hbh25y@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.9 017/218] can: ems_usb: ems_usb_start_xmit(): fix double dev_kfree_skb() in error path
Date:   Mon, 18 Apr 2022 14:11:23 +0200
Message-Id: <20220418121159.589629050@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
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

From: Hangyu Hua <hbh25y@gmail.com>

commit c70222752228a62135cee3409dccefd494a24646 upstream.

There is no need to call dev_kfree_skb() when usb_submit_urb() fails
beacause can_put_echo_skb() deletes the original skb and
can_free_echo_skb() deletes the cloned skb.

Link: https://lore.kernel.org/all/20220228083639.38183-1-hbh25y@gmail.com
Fixes: 702171adeed3 ("ems_usb: Added support for EMS CPC-USB/ARM7 CAN/USB interface")
Cc: stable@vger.kernel.org
Cc: Sebastian Haas <haas@ems-wuensche.com>
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/ems_usb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -834,7 +834,6 @@ static netdev_tx_t ems_usb_start_xmit(st
 
 		usb_unanchor_urb(urb);
 		usb_free_coherent(dev->udev, size, buf, urb->transfer_dma);
-		dev_kfree_skb(skb);
 
 		atomic_dec(&dev->active_tx_urbs);
 


