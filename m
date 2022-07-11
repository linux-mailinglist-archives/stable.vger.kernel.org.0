Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A061056FA24
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbiGKJNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbiGKJNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:13:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B84E2F3BB;
        Mon, 11 Jul 2022 02:09:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76BF26115B;
        Mon, 11 Jul 2022 09:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EEAC34115;
        Mon, 11 Jul 2022 09:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530577;
        bh=NZfE0H/w5NIGJFcWdjQPXZinzAVGglJvOVXLLc32h1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RmFclwm1L86PTEKxh9ZMAo7mKodTjndzDpJHhgOJdUzuhFmdcs1J8zY3yBdByb6Bq
         nYyvEY1xBqchXqb+lB0IDMp2Qhb1vkZh9yw0SB9xzSM3RksspQwDhKuehSjKCIXnPR
         IH52g+BYMkPInmvgigzr3ygnLk9EFVl5axE3RFhw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Child <nnac123@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Rick Lindsley <ricklind@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 19/31] ibmvnic: Properly dispose of all skbs during a failover.
Date:   Mon, 11 Jul 2022 11:06:58 +0200
Message-Id: <20220711090538.414969149@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090537.841305347@linuxfoundation.org>
References: <20220711090537.841305347@linuxfoundation.org>
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

From: Rick Lindsley <ricklind@us.ibm.com>

[ Upstream commit 1b18f09d31cfa7148df15a7d5c5e0e86f105f7d1 ]

During a reset, there may have been transmits in flight that are no
longer valid and cannot be fulfilled.  Resetting and clearing the
queues is insufficient; each skb also needs to be explicitly freed
so that upper levels are not left waiting for confirmation of a
transmit that will never happen.  If this happens frequently enough,
the apparent backlog will cause TCP to begin "congestion control"
unnecessarily, culminating in permanently decreased throughput.

Fixes: d7c0ef36bde03 ("ibmvnic: Free and re-allocate scrqs when tx/rx scrqs change")
Tested-by: Nick Child <nnac123@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Rick Lindsley <ricklind@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index ae3eea4a4213..1463cf4321a8 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4691,6 +4691,15 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter)
 			release_sub_crqs(adapter, 0);
 			rc = init_sub_crqs(adapter);
 		} else {
+			/* no need to reinitialize completely, but we do
+			 * need to clean up transmits that were in flight
+			 * when we processed the reset.  Failure to do so
+			 * will confound the upper layer, usually TCP, by
+			 * creating the illusion of transmits that are
+			 * awaiting completion.
+			 */
+			clean_tx_pools(adapter);
+
 			rc = reset_sub_crq_queues(adapter);
 		}
 	} else {
-- 
2.35.1



