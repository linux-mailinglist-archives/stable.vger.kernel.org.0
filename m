Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0BF6D475F
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbjDCOTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbjDCOTd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:19:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEC52C9DA
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:19:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E570B81BA8
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD344C433EF;
        Mon,  3 Apr 2023 14:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531570;
        bh=+V+Ilnr9LS2aoqD/w3u5bAWrNwMTbMlAKgoPRSBrphs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oDqUsy9lzSlBHAvl8nXaVBgK6kxwvMHfoNOusKKEjdKDzDdSSb9Oj5/MLxUYhobGn
         6Xxw6sB2oPMIHXEGjXNEDfg2V5VlhS/RlMLjxzo8iLJ0PCGnVe5UMyH1S0busNnKPZ
         NlyvMtsEmkvgtvcqQKEGPfdmBcJ0RYNKi+dZF0zs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 005/104] intel/igbvf: free irq on the error path in igbvf_request_msix()
Date:   Mon,  3 Apr 2023 16:07:57 +0200
Message-Id: <20230403140404.290507573@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 85eb39bb39cbb5c086df1e19ba67cc1366693a77 ]

In igbvf_request_msix(), irqs have not been freed on the err path,
we need to free it. Fix it.

Fixes: d4e0fe01a38a ("igbvf: add new driver to support 82576 virtual functions")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igbvf/netdev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 1082e49ea0560..5bf1c9d847271 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -1070,7 +1070,7 @@ static int igbvf_request_msix(struct igbvf_adapter *adapter)
 			  igbvf_intr_msix_rx, 0, adapter->rx_ring->name,
 			  netdev);
 	if (err)
-		goto out;
+		goto free_irq_tx;
 
 	adapter->rx_ring->itr_register = E1000_EITR(vector);
 	adapter->rx_ring->itr_val = adapter->current_itr;
@@ -1079,10 +1079,14 @@ static int igbvf_request_msix(struct igbvf_adapter *adapter)
 	err = request_irq(adapter->msix_entries[vector].vector,
 			  igbvf_msix_other, 0, netdev->name, netdev);
 	if (err)
-		goto out;
+		goto free_irq_rx;
 
 	igbvf_configure_msix(adapter);
 	return 0;
+free_irq_rx:
+	free_irq(adapter->msix_entries[--vector].vector, netdev);
+free_irq_tx:
+	free_irq(adapter->msix_entries[--vector].vector, netdev);
 out:
 	return err;
 }
-- 
2.39.2



