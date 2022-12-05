Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C7464332A
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbiLETem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234375AbiLETeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:34:16 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096B228E12
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:29:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4D9AACE13A8
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25517C433C1;
        Mon,  5 Dec 2022 19:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268581;
        bh=BizvfJA1a54veZRiEAJhMZsBkutO+MxR/qhl/Ts29I0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v82bnDwqRi3dqBencMoqDi1tSTxCH7OHTtewdBLTKM05poPVubk3yxxRp7iH1lO/Q
         7gLSsinCaDXAN6X1TNriwwyBPJsdjAy9qbNSEiBGsdUFipZauZe9rxGz0kQbKl9CTu
         SBvrwoZCh4OkAcpxDBIwUdlJMKRQVHEO5QhG6MhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Hai <wanghai38@huawei.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 29/92] e100: Fix possible use after free in e100_xmit_prepare
Date:   Mon,  5 Dec 2022 20:09:42 +0100
Message-Id: <20221205190804.430816162@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 45605c75c52c7ae7bfe902214343aabcfe5ba0ff ]

In e100_xmit_prepare(), if we can't map the skb, then return -ENOMEM, so
e100_xmit_frame() will return NETDEV_TX_BUSY and the upper layer will
resend the skb. But the skb is already freed, which will cause UAF bug
when the upper layer resends the skb.

Remove the harmful free.

Fixes: 5e5d49422dfb ("e100: Release skb when DMA mapping is failed in e100_xmit_prepare")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e100.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 7ccf890ee735..001850d578e8 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -1742,11 +1742,8 @@ static int e100_xmit_prepare(struct nic *nic, struct cb *cb,
 	dma_addr = dma_map_single(&nic->pdev->dev, skb->data, skb->len,
 				  DMA_TO_DEVICE);
 	/* If we can't map the skb, have the upper layer try later */
-	if (dma_mapping_error(&nic->pdev->dev, dma_addr)) {
-		dev_kfree_skb_any(skb);
-		skb = NULL;
+	if (dma_mapping_error(&nic->pdev->dev, dma_addr))
 		return -ENOMEM;
-	}
 
 	/*
 	 * Use the last 4 bytes of the SKB payload packet as the CRC, used for
-- 
2.35.1



