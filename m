Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B295EA37B
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236153AbiIZL0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238156AbiIZLYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:24:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7446754640;
        Mon, 26 Sep 2022 03:40:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB38B60C62;
        Mon, 26 Sep 2022 10:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF918C433D6;
        Mon, 26 Sep 2022 10:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188785;
        bh=RCBk86iN1b+owOCdt3/R4g3NcyOcUokW7oWPcJfFX24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gkdhD+PK90efh41rv1NfCZly2KzoNGwNv9ZpxXkjDdU5gtVLy3R/2I+ajoqKT7prZ
         5faFmL/aj+f/dolw+USzzGwG4PJcFK8hvNnQySw+g+AzT/WGrG5GjLEU/0oqjH3Xe7
         dWHq4tUaDnNZjaBiGjJ4scfgnUOEw3juJBvqs6kI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tianhao Zhao <tizhao@redhat.com>,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/148] sfc: fix null pointer dereference in efx_hard_start_xmit
Date:   Mon, 26 Sep 2022 12:12:03 +0200
Message-Id: <20220926100759.401809146@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
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

[ Upstream commit 0a242eb2913a4aa3d6fbdb86559f27628e9466f3 ]

Trying to get the channel from the tx_queue variable here is wrong
because we can only be here if tx_queue is NULL, so we shouldn't
dereference it. As the above comment in the code says, this is very
unlikely to happen, but it's wrong anyway so let's fix it.

I hit this issue because of a different bug that caused tx_queue to be
NULL. If that happens, this is the error message that we get here:
  BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
  [...]
  RIP: 0010:efx_hard_start_xmit+0x153/0x170 [sfc]

Fixes: 12804793b17c ("sfc: decouple TXQ type from label")
Reported-by: Tianhao Zhao <tizhao@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
Link: https://lore.kernel.org/r/20220914111135.21038-1-ihuguet@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 6983799e1c05..e0bc2c1dc81a 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -548,7 +548,7 @@ netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
 		 * previous packets out.
 		 */
 		if (!netdev_xmit_more())
-			efx_tx_send_pending(tx_queue->channel);
+			efx_tx_send_pending(efx_get_tx_channel(efx, index));
 		return NETDEV_TX_OK;
 	}
 
-- 
2.35.1



