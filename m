Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBEF5653D1
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 13:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbiGDLg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 07:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234231AbiGDLg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 07:36:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE70D11A15
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 04:36:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C13F061660
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 11:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3E7C341CA;
        Mon,  4 Jul 2022 11:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656934575;
        bh=hNXb3pAyIRBP1cuNfBEpdtEgH+3t4kKBp0jwDQ6cP5M=;
        h=Subject:To:Cc:From:Date:From;
        b=uZM9B9zCCih3DBazJfuhEgOrf1A3Fqagk2jsCOjITWh4rpGvwPmbHy7tMQWA4f6RS
         ADWNVrcBlLyoKNr2YgjMqQNPRhRmVXAHTpnWy52ESlp4VGTsLpDCU7YKgGsFS3JNPp
         oOk4nd3SJanLOt/sNPfZ45D/rVzPJ48onN9yBHKo=
Subject: FAILED: patch "[PATCH] net: fix IFF_TX_SKB_NO_LINEAR definition" failed to apply to 5.15-stable tree
To:     dan.carpenter@oracle.com, kuba@kernel.org,
        xuanzhuo@linux.alibaba.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 13:36:12 +0200
Message-ID: <16569345724593@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3b89b511ea0c705cc418440e2abf9d692a556d84 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 23 Jun 2022 16:32:32 +0300
Subject: [PATCH] net: fix IFF_TX_SKB_NO_LINEAR definition

The "1<<31" shift has a sign extension bug so IFF_TX_SKB_NO_LINEAR is
0xffffffff80000000 instead of 0x0000000080000000.

Fixes: c2ff53d8049f ("net: Add priv_flags for allow tx skb without linear")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Link: https://lore.kernel.org/r/YrRrcGttfEVnf85Q@kili
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f615a66c89e9..2563d30736e9 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1671,7 +1671,7 @@ enum netdev_priv_flags {
 	IFF_FAILOVER_SLAVE		= 1<<28,
 	IFF_L3MDEV_RX_HANDLER		= 1<<29,
 	IFF_LIVE_RENAME_OK		= 1<<30,
-	IFF_TX_SKB_NO_LINEAR		= 1<<31,
+	IFF_TX_SKB_NO_LINEAR		= BIT_ULL(31),
 	IFF_CHANGE_PROTO_DOWN		= BIT_ULL(32),
 };
 

