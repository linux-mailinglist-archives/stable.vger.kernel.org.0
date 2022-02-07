Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290614ABCD2
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353867AbiBGLjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386091AbiBGLde (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:33:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655C0C043181;
        Mon,  7 Feb 2022 03:33:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECF2460B20;
        Mon,  7 Feb 2022 11:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD72FC004E1;
        Mon,  7 Feb 2022 11:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233612;
        bh=0G4mg7JrTwEv++ARZxUJpNZ1oLOwrJ8UNREcb0ZZ/f8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1fTyPHCa7ONPxbl19duLpzzj7yqyatT2z35ElYvoNxnwXrfYRZbeix9syhTFF/Tv
         1AXJ77aLkCBAKZme5KqVKWXGsGPmVm7r7wb8wPFVH/u98GrR78Mav0FIhQzu/8lgLy
         Ka9n5JgvP6c+cqxL/eKBSJzB6pqE13nSRHDyKxMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 5.16 067/126] net: ieee802154: ca8210: Stop leaking skbs
Date:   Mon,  7 Feb 2022 12:06:38 +0100
Message-Id: <20220207103806.426048917@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 621b24b09eb61c63f262da0c9c5f0e93348897e5 upstream.

Upon error the ieee802154_xmit_complete() helper is not called. Only
ieee802154_wake_queue() is called manually. We then leak the skb
structure.

Free the skb structure upon error before returning.

Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20220125121426.848337-5-miquel.raynal@bootlin.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ieee802154/ca8210.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -1771,6 +1771,7 @@ static int ca8210_async_xmit_complete(
 			status
 		);
 		if (status != MAC_TRANSACTION_OVERFLOW) {
+			dev_kfree_skb_any(priv->tx_skb);
 			ieee802154_wake_queue(priv->hw);
 			return 0;
 		}


