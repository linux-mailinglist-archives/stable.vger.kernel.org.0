Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E287566D02
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236281AbiGEMUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237491AbiGEMTR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:19:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BF11D0ED;
        Tue,  5 Jul 2022 05:14:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAE8DB8170A;
        Tue,  5 Jul 2022 12:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6E3C341C7;
        Tue,  5 Jul 2022 12:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023288;
        bh=3qEmsLJXqFekBedASALHJHcy6eqcwMkrlqiBSTjM+BI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rGFJn1UXx7MRyD32CrCo515ZT43nlkJhy/ar3W1/kOTwqEjQ/+5gihTfmSsTvtvLi
         6O36/FKrXC0Q5NvS3F5kVk7T7OY1ve+EHrvdXw9UFk+ywJdRapIyZ5MVtG4hadtU59
         EYKFgcLhSUhVzGWMTdoQaf2QS6AKcw8Dw6VdQWkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 86/98] net: fix IFF_TX_SKB_NO_LINEAR definition
Date:   Tue,  5 Jul 2022 13:58:44 +0200
Message-Id: <20220705115620.011655239@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
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

[ Upstream commit 3b89b511ea0c705cc418440e2abf9d692a556d84 ]

The "1<<31" shift has a sign extension bug so IFF_TX_SKB_NO_LINEAR is
0xffffffff80000000 instead of 0x0000000080000000.

Fixes: c2ff53d8049f ("net: Add priv_flags for allow tx skb without linear")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Link: https://lore.kernel.org/r/YrRrcGttfEVnf85Q@kili
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 39f1893ecac0..f8d46dc62d65 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1645,7 +1645,7 @@ enum netdev_priv_flags {
 	IFF_FAILOVER_SLAVE		= 1<<28,
 	IFF_L3MDEV_RX_HANDLER		= 1<<29,
 	IFF_LIVE_RENAME_OK		= 1<<30,
-	IFF_TX_SKB_NO_LINEAR		= 1<<31,
+	IFF_TX_SKB_NO_LINEAR		= BIT_ULL(31),
 };
 
 #define IFF_802_1Q_VLAN			IFF_802_1Q_VLAN
-- 
2.35.1



