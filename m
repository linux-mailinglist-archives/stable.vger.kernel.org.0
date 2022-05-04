Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D22C51A5ED
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353656AbiEDQv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353644AbiEDQv4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:51:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66D746B03;
        Wed,  4 May 2022 09:48:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 790526174B;
        Wed,  4 May 2022 16:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDC1C385A4;
        Wed,  4 May 2022 16:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682896;
        bh=VtJerBDQCYbUCgpxXLdGU8t1nlWfii6eDosdmY9hF0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=utthZ9CZETq++VVWtdVAXfYSkj14Xieers63trhoj4q/ITccm1B44xTneu4qADs1d
         F+Ri0BmpLHpU82dlu3nSc1ON49h9bztPuU+6NfiPwuwySC8Ubk5bQrXTrT6V6+1o47
         OqR70mK7rcplVXf6htRIU0SkPGni9iBggvZq8cm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 03/84] hamradio: remove needs_free_netdev to avoid UAF
Date:   Wed,  4 May 2022 18:43:44 +0200
Message-Id: <20220504152927.990766404@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
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

From: Lin Ma <linma@zju.edu.cn>

commit 81b1d548d00bcd028303c4f3150fa753b9b8aa71 upstream.

The former patch "defer 6pack kfree after unregister_netdev" reorders
the kfree of two buffer after the unregister_netdev to prevent the race
condition. It also adds free_netdev() function in sixpack_close(), which
is a direct copy from the similar code in mkiss_close().

However, in sixpack driver, the flag needs_free_netdev is set to true in
sp_setup(), hence the unregister_netdev() will free the netdev
automatically. Therefore, as the sp is netdev_priv, use-after-free
occurs.

This patch removes the needs_free_netdev = true and just let the
free_netdev to finish this deallocation task.

Fixes: 0b9111922b1f ("hamradio: defer 6pack kfree after unregister_netdev")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Link: https://lore.kernel.org/r/20211111141402.7551-1-linma@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hamradio/6pack.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -311,7 +311,6 @@ static void sp_setup(struct net_device *
 {
 	/* Finish setting up the DEVICE info. */
 	dev->netdev_ops		= &sp_netdev_ops;
-	dev->needs_free_netdev	= true;
 	dev->mtu		= SIXP_MTU;
 	dev->hard_header_len	= AX25_MAX_HEADER_LEN;
 	dev->header_ops 	= &ax25_header_ops;


