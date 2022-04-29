Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7907514723
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357729AbiD2Kpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357693AbiD2KpS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:45:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8880C6EEB;
        Fri, 29 Apr 2022 03:41:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F90B6235C;
        Fri, 29 Apr 2022 10:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B298C385A4;
        Fri, 29 Apr 2022 10:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651228915;
        bh=VtJerBDQCYbUCgpxXLdGU8t1nlWfii6eDosdmY9hF0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qsIvg/8koiR/jibFaflGX+sd8V0/R6CX0ojZ3EUhf6ZesaWD3PI8z2SFe1I4M7177
         f6XSLQJsNsmzYwLVcNpt0OO5ZMIUePOCNKF2/0lrbzRLTk0T6Vvo7SeNQgna7g7CB6
         KWEOttgo4BN8/+Mk1C1lQW1NCDRKmFKdEIbZWeP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 04/12] hamradio: remove needs_free_netdev to avoid UAF
Date:   Fri, 29 Apr 2022 12:41:21 +0200
Message-Id: <20220429104048.588599421@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429104048.459089941@linuxfoundation.org>
References: <20220429104048.459089941@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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


