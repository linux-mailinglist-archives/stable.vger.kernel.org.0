Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 961EA4E7738
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352105AbiCYP12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377494AbiCYPYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:24:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF271606EF;
        Fri, 25 Mar 2022 08:18:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34DFCB828F6;
        Fri, 25 Mar 2022 15:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D573C340EE;
        Fri, 25 Mar 2022 15:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221487;
        bh=cm0RYyJQcXqUnVI7HNk8immc7/DDIPAlvRgVNobGzO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3LYNGfOnBrolFZz6Wh+ht05zncb9GlGyauSp8WRNyeywxWUoy2OM8tD2SiXhWX3X
         dhy6fJgSQ9qaGuiSAfkefeYcisa4QCEnSXUn3PnxSvunMWJFDOva1W5l4ImmTzmicm
         qpgfm+woE2ijIpqM5VLCjiaTGTtlOUYINOTa4pOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephane Graber <stgraber@ubuntu.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 21/37] drivers: net: xgene: Fix regression in CRC stripping
Date:   Fri, 25 Mar 2022 16:14:31 +0100
Message-Id: <20220325150420.651376257@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150420.046488912@linuxfoundation.org>
References: <20220325150420.046488912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Graber <stgraber@ubuntu.com>

commit e9e6faeafaa00da1851bcf47912b0f1acae666b4 upstream.

All packets on ingress (except for jumbo) are terminated with a 4-bytes
CRC checksum. It's the responsability of the driver to strip those 4
bytes. Unfortunately a change dating back to March 2017 re-shuffled some
code and made the CRC stripping code effectively dead.

This change re-orders that part a bit such that the datalen is
immediately altered if needed.

Fixes: 4902a92270fb ("drivers: net: xgene: Add workaround for errata 10GE_8/ENET_11")
Cc: stable@vger.kernel.org
Signed-off-by: Stephane Graber <stgraber@ubuntu.com>
Tested-by: Stephane Graber <stgraber@ubuntu.com>
Link: https://lore.kernel.org/r/20220322224205.752795-1-stgraber@ubuntu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -696,6 +696,12 @@ static int xgene_enet_rx_frame(struct xg
 	buf_pool->rx_skb[skb_index] = NULL;
 
 	datalen = xgene_enet_get_data_len(le64_to_cpu(raw_desc->m1));
+
+	/* strip off CRC as HW isn't doing this */
+	nv = GET_VAL(NV, le64_to_cpu(raw_desc->m0));
+	if (!nv)
+		datalen -= 4;
+
 	skb_put(skb, datalen);
 	prefetch(skb->data - NET_IP_ALIGN);
 	skb->protocol = eth_type_trans(skb, ndev);
@@ -717,12 +723,8 @@ static int xgene_enet_rx_frame(struct xg
 		}
 	}
 
-	nv = GET_VAL(NV, le64_to_cpu(raw_desc->m0));
-	if (!nv) {
-		/* strip off CRC as HW isn't doing this */
-		datalen -= 4;
+	if (!nv)
 		goto skip_jumbo;
-	}
 
 	slots = page_pool->slots - 1;
 	head = page_pool->head;


