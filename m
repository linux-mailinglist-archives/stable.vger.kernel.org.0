Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C491621511
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235139AbiKHOH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235137AbiKHOHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:07:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF4B748D1
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:07:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD3AB615AF
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC73C433D6;
        Tue,  8 Nov 2022 14:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916472;
        bh=Ep/y4/cstCgemSwJV0Uds14xdtYuEZhoWjh9FLshEdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G85Ax/8JjmuiqpCxj3d8Tj9FHy9GW8PP8NKFnVtXh2BpZHpuKURwLyc6L7+8DZKVY
         ogj+Yqj8jR0fr4+D3SMxSpD2/JgeU1ExB61hunKjV7XTZPBX3O0dkuk+Afs1P5o8/I
         PKwou9lTnsztQ+Q8dkKZBa+1Wj50vuOqnWeQOFUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 032/197] sfc: Fix an error handling path in efx_pci_probe()
Date:   Tue,  8 Nov 2022 14:37:50 +0100
Message-Id: <20221108133356.269035212@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 6c412da54c80a54b1a8b7f89677f6e82f0fabec4 ]

If an error occurs after the first kzalloc() the corresponding memory
allocation is never freed.

Add the missing kfree() in the error handling path, as already done in the
remove() function.

Fixes: 7e773594dada ("sfc: Separate efx_nic memory from net_device memory")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
Link: https://lore.kernel.org/r/dc114193121c52c8fa3779e49bdd99d4b41344a9.1667077009.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/efx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 153d68e29b8b..68a68477ab7b 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1059,8 +1059,10 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 
 	/* Allocate and initialise a struct net_device */
 	net_dev = alloc_etherdev_mq(sizeof(probe_data), EFX_MAX_CORE_TX_QUEUES);
-	if (!net_dev)
-		return -ENOMEM;
+	if (!net_dev) {
+		rc = -ENOMEM;
+		goto fail0;
+	}
 	probe_ptr = netdev_priv(net_dev);
 	*probe_ptr = probe_data;
 	efx->net_dev = net_dev;
@@ -1132,6 +1134,8 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 	WARN_ON(rc > 0);
 	netif_dbg(efx, drv, efx->net_dev, "initialisation failed. rc=%d\n", rc);
 	free_netdev(net_dev);
+ fail0:
+	kfree(probe_data);
 	return rc;
 }
 
-- 
2.35.1



