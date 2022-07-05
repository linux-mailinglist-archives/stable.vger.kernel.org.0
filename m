Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18183566D25
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236571AbiGEMVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237657AbiGEMTd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:19:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11D41D332;
        Tue,  5 Jul 2022 05:15:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DF9A61985;
        Tue,  5 Jul 2022 12:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E7BC341C8;
        Tue,  5 Jul 2022 12:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023357;
        bh=eMgQAijeT18dC49W4cKDYQ9S19R4cwyj5ZWYofwazjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sEAr1Evm8lPzXvwesgaSNNIAaQsyZzZ2Sg1rFMpUmZ1eECK/QSI7eWbGy2mo1mALs
         4bHhuU+TggLhEuVUY2cz4OjC1IQiGPgJZ0OceLKe2SBFopfNJDmgVtA6ceCokve4Ga
         y6SDRNdIZF4kvmtUdJAOs47RG6Z6evuwObnbOJXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.18 030/102] net: fix IFF_TX_SKB_NO_LINEAR definition
Date:   Tue,  5 Jul 2022 13:57:56 +0200
Message-Id: <20220705115619.271174544@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 3b89b511ea0c705cc418440e2abf9d692a556d84 upstream.

The "1<<31" shift has a sign extension bug so IFF_TX_SKB_NO_LINEAR is
0xffffffff80000000 instead of 0x0000000080000000.

Fixes: c2ff53d8049f ("net: Add priv_flags for allow tx skb without linear")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Link: https://lore.kernel.org/r/YrRrcGttfEVnf85Q@kili
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1653,7 +1653,7 @@ enum netdev_priv_flags {
 	IFF_FAILOVER_SLAVE		= 1<<28,
 	IFF_L3MDEV_RX_HANDLER		= 1<<29,
 	IFF_LIVE_RENAME_OK		= 1<<30,
-	IFF_TX_SKB_NO_LINEAR		= 1<<31,
+	IFF_TX_SKB_NO_LINEAR		= BIT_ULL(31),
 	IFF_CHANGE_PROTO_DOWN		= BIT_ULL(32),
 };
 


