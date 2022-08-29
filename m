Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9575A4BC8
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 14:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbiH2M2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 08:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiH2M1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 08:27:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DCEAE207;
        Mon, 29 Aug 2022 05:11:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D81761245;
        Mon, 29 Aug 2022 11:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BFCC433D6;
        Mon, 29 Aug 2022 11:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771768;
        bh=JHEcHOHuYKv5fpWgw5Eb1DRF51P3IYRI0HKX1wpe9Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLFPljBTBqyLDkb0uC8Uk8Q84pS9q8+nAQsxR3eJXAWktuygKYMmIAdPJ3Zvw2EcT
         0w1K3QNSEMtqO7l93912NvVCYKTcartL8DykjbeQMPCPeZEz1utF5KRQ1UsHHZxqa/
         ZkRFbCqD4+BmiD3biyEECoUaq7v4Ydhc5UBXtNTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksander Jan Bajkowski <olek2@wp.pl>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 092/158] net: lantiq_xrx200: fix lock under memory pressure
Date:   Mon, 29 Aug 2022 12:59:02 +0200
Message-Id: <20220829105812.921874621@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit c4b6e9341f930e4dd089231c0414758f5f1f9dbd ]

When the xrx200_hw_receive() function returns -ENOMEM, the NAPI poll
function immediately returns an error.
This is incorrect for two reasons:
* the function terminates without enabling interrupts or scheduling NAPI,
* the error code (-ENOMEM) is returned instead of the number of received
packets.

After the first memory allocation failure occurs, packet reception is
locked due to disabled interrupts from DMA..

Fixes: fe1a56420cf2 ("net: lantiq: Add Lantiq / Intel VRX200 Ethernet driver")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/lantiq_xrx200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 89314b645c822..25adce7f0c7c0 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -294,7 +294,7 @@ static int xrx200_poll_rx(struct napi_struct *napi, int budget)
 			if (ret == XRX200_DMA_PACKET_IN_PROGRESS)
 				continue;
 			if (ret != XRX200_DMA_PACKET_COMPLETE)
-				return ret;
+				break;
 			rx++;
 		} else {
 			break;
-- 
2.35.1



