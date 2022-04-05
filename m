Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D624F2C80
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235489AbiDEJAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237369AbiDEIly (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:41:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD7B2615;
        Tue,  5 Apr 2022 01:34:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68D7061470;
        Tue,  5 Apr 2022 08:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A117C385A1;
        Tue,  5 Apr 2022 08:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147668;
        bh=C6RXfa9OTsIPDL1qL6BYaWRZzDFmkNBH0ycgJlH2syU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ckGnrJ4chEjpwaXCdQyA8Bm/B4bv+e3qke4GR0rvDnUlNTiIa6t3gGK/vrAb0ZXI9
         omHqOsLzdvjO5W9MLUe+E73GPr00l3bDPxzpSQAA+Xw6UTRVUo8K6dM7h1RtHS/40R
         TAFCV3LgUKK5fGTrCYSZn3a9W+34eyWRZUYXqoBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sebastian Haas <haas@ems-wuensche.com>,
        Hangyu Hua <hbh25y@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.16 0080/1017] can: ems_usb: ems_usb_start_xmit(): fix double dev_kfree_skb() in error path
Date:   Tue,  5 Apr 2022 09:16:33 +0200
Message-Id: <20220405070356.565651847@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -821,7 +821,6 @@ static netdev_tx_t ems_usb_start_xmit(st
 
 		usb_unanchor_urb(urb);
 		usb_free_coherent(dev->udev, size, buf, urb->transfer_dma);
-		dev_kfree_skb(skb);
 
 		atomic_dec(&dev->active_tx_urbs);
 


