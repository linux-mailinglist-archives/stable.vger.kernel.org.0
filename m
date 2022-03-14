Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959394D8160
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239249AbiCNLlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239250AbiCNLk4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:40:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958AB48E54;
        Mon, 14 Mar 2022 04:38:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B080B80D96;
        Mon, 14 Mar 2022 11:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7167FC340E9;
        Mon, 14 Mar 2022 11:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647257915;
        bh=2z3sHLbs3i+JwZqjq1YXDQcvL9PzzebynVKwSZ/U2TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSou5CLfHwjKsWhP9K9nuvL4xODnV/TZgS9lP1JctNxW7mDSb/YdSWrqheWavTGxy
         8OmSXqH/8kHJSQK+rhzyLJ4v18M8DujwRhTvUU5J6YmsjtaSecmvZzUIUyn3djZIQg
         q8uCoN93JJagXWiVRTyvD2x5JFfQkZDL3W9/qGJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4.19 19/30] staging: gdm724x: fix use after free in gdm_lte_rx()
Date:   Mon, 14 Mar 2022 12:34:37 +0100
Message-Id: <20220314112732.330374679@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112731.785042288@linuxfoundation.org>
References: <20220314112731.785042288@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit fc7f750dc9d102c1ed7bbe4591f991e770c99033 upstream.

The netif_rx_ni() function frees the skb so we can't dereference it to
save the skb->len.

Fixes: 61e121047645 ("staging: gdm7240: adding LTE USB driver")
Cc: stable <stable@vger.kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20220228074331.GA13685@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/gdm724x/gdm_lte.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/staging/gdm724x/gdm_lte.c
+++ b/drivers/staging/gdm724x/gdm_lte.c
@@ -76,14 +76,15 @@ static void tx_complete(void *arg)
 
 static int gdm_lte_rx(struct sk_buff *skb, struct nic *nic, int nic_type)
 {
-	int ret;
+	int ret, len;
 
+	len = skb->len + ETH_HLEN;
 	ret = netif_rx_ni(skb);
 	if (ret == NET_RX_DROP) {
 		nic->stats.rx_dropped++;
 	} else {
 		nic->stats.rx_packets++;
-		nic->stats.rx_bytes += skb->len + ETH_HLEN;
+		nic->stats.rx_bytes += len;
 	}
 
 	return 0;


