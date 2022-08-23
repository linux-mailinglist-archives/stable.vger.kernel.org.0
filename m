Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2E659D9C5
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241270AbiHWKCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348269AbiHWKAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F21BA3;
        Tue, 23 Aug 2022 01:48:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4251A611DD;
        Tue, 23 Aug 2022 08:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE1BC433D6;
        Tue, 23 Aug 2022 08:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244493;
        bh=ZYTKFm1TtlDdH0qLKY2rE3EpgKLlGflmbBtmOBDDgVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FIwWlY6ttTDVz9nBQ2ekvRQjREhwMQ+qMfSXDzhj2fslgCPPnMcshZHEJJUeNh8h6
         vMA1dS0wVSVO7znAeVtiPfeu46Jtu7MeKs4A+bcqbTLt8c136e6Njbv3iXR1QYahwn
         8k3bwvpHkQAJtT1vqBBewBlR9NlZIjF4jvXbFBLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Lin <chen.lin5@zte.com.cn>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 102/244] dpaa2-eth: trace the allocated address instead of page struct
Date:   Tue, 23 Aug 2022 10:24:21 +0200
Message-Id: <20220823080102.434243625@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

From: Chen Lin <chen45464546@163.com>

commit e34f49348f8b7a53205b6f77707a3a6a40cf420b upstream.

We should trace the allocated address instead of page struct.

Fixes: 27c874867c4e ("dpaa2-eth: Use a single page per Rx buffer")
Signed-off-by: Chen Lin <chen.lin5@zte.com.cn>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20220811151651.3327-1-chen45464546@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1389,8 +1389,8 @@ static int dpaa2_eth_add_bufs(struct dpa
 		buf_array[i] = addr;
 
 		/* tracing point */
-		trace_dpaa2_eth_buf_seed(priv->net_dev,
-					 page, DPAA2_ETH_RX_BUF_RAW_SIZE,
+		trace_dpaa2_eth_buf_seed(priv->net_dev, page_address(page),
+					 DPAA2_ETH_RX_BUF_RAW_SIZE,
 					 addr, priv->rx_buf_size,
 					 bpid);
 	}


