Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBA225EA4A2
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235086AbiIZLtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238773AbiIZLrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:47:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E3B74DF4;
        Mon, 26 Sep 2022 03:47:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 914FB60A37;
        Mon, 26 Sep 2022 10:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05CEC433D7;
        Mon, 26 Sep 2022 10:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189263;
        bh=ZmKY2Sdv8dFo4Uiq2WCxXNdpELsTk6liyF6+9D2rwtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KfRlPvmW6vWuNnxcQaNANvcRx1lzIDASPOUaQBKWagv5muZynrNE363GLD93lvwCm
         AZnJ7cYfiFSPwfljD77QbYen9Yu6oWd2QPDqD86e7DPm8UWa8aeXbz5z41N0PTd1iB
         eOFRmxUuk2YMrbF595AAN1U7rhvAJ+X5V52FJw6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tianhao Zhao <tizhao@redhat.com>,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 127/207] sfc/siena: fix null pointer dereference in efx_hard_start_xmit
Date:   Mon, 26 Sep 2022 12:11:56 +0200
Message-Id: <20220926100812.239218464@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Íñigo Huguet <ihuguet@redhat.com>

[ Upstream commit 589c6eded10c77a12b7b2cf235b6b19a2bdb91fa ]

Like in previous patch for sfc, prevent potential (but unlikely) NULL
pointer dereference.

Fixes: 12804793b17c ("sfc: decouple TXQ type from label")
Reported-by: Tianhao Zhao <tizhao@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
Link: https://lore.kernel.org/r/20220915141958.16458-1-ihuguet@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/siena/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/siena/tx.c b/drivers/net/ethernet/sfc/siena/tx.c
index e166dcb9b99c..91e87594ed1e 100644
--- a/drivers/net/ethernet/sfc/siena/tx.c
+++ b/drivers/net/ethernet/sfc/siena/tx.c
@@ -336,7 +336,7 @@ netdev_tx_t efx_siena_hard_start_xmit(struct sk_buff *skb,
 		 * previous packets out.
 		 */
 		if (!netdev_xmit_more())
-			efx_tx_send_pending(tx_queue->channel);
+			efx_tx_send_pending(efx_get_tx_channel(efx, index));
 		return NETDEV_TX_OK;
 	}
 
-- 
2.35.1



