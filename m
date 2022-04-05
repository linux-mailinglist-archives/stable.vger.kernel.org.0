Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8CA4F3AAD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381627AbiDELql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354198AbiDEKMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:12:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842B352E42;
        Tue,  5 Apr 2022 02:58:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A5116167E;
        Tue,  5 Apr 2022 09:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27038C385A1;
        Tue,  5 Apr 2022 09:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152696;
        bh=ILBucAii6L59KbluEJs9UfkSEPcuI0aO3O8zzJAmlug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MV/cFwM5bBNTByx7gt5rHCcAcYDJc8H3tkCx8uSMTUiPblgiSlKQ5YktrVSB20O7M
         a409zpj1Si2gtA8VZaEf7U/lpeeCjVuNQLFGvCEbVwXYxAOLJWSl5UdVpMGdvuBXPu
         V+1F415/EuJKna0tzqPTFKFDKwgHIyOdN7XTFxa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 832/913] can: mcba_usb: mcba_usb_start_xmit(): fix double dev_kfree_skb in error path
Date:   Tue,  5 Apr 2022 09:31:34 +0200
Message-Id: <20220405070404.770496313@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

commit 04c9b00ba83594a29813d6b1fb8fdc93a3915174 upstream.

There is no need to call dev_kfree_skb() when usb_submit_urb() fails
because can_put_echo_skb() deletes original skb and
can_free_echo_skb() deletes the cloned skb.

Fixes: 51f3baad7de9 ("can: mcba_usb: Add support for Microchip CAN BUS Analyzer")
Link: https://lore.kernel.org/all/20220311080208.45047-1-hbh25y@gmail.com
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/mcba_usb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -368,7 +368,6 @@ static netdev_tx_t mcba_usb_start_xmit(s
 xmit_failed:
 	can_free_echo_skb(priv->netdev, ctx->ndx, NULL);
 	mcba_usb_free_ctx(ctx);
-	dev_kfree_skb(skb);
 	stats->tx_dropped++;
 
 	return NETDEV_TX_OK;


