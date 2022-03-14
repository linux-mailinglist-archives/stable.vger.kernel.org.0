Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66924D80F3
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239109AbiCNLgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239142AbiCNLgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:36:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4357427E3;
        Mon, 14 Mar 2022 04:35:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A52BB80DBF;
        Mon, 14 Mar 2022 11:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CFFC340E9;
        Mon, 14 Mar 2022 11:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647257730;
        bh=rMXLndDmc7z4opN8JBWPViU4T/+3mvaGTkLvnAXD9+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hoi1/IvA0a4qnYzFCX1G/9O5QkPzMEEPNqfF3ipPbVLdsmAhbWNbKVd8o68vtGKp1
         CMyewCUJzD3KjxpD4yHqnr/rUk4f/m8M/cUlICxTxZC7Gl8ox6LZ6tZ6eeWJ/5QBTb
         q3SChkM6pE58hhxmuqHMdgPn0Cp+Uksr7ru0jBnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 03/20] ethernet: Fix error handling in xemaclite_of_probe
Date:   Mon, 14 Mar 2022 12:34:04 +0100
Message-Id: <20220314112730.491046749@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112730.388955049@linuxfoundation.org>
References: <20220314112730.388955049@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit b19ab4b38b06aae12442b2de95ccf58b5dc53584 ]

This node pointer is returned by of_parse_phandle() with refcount
incremented in this function. Calling of_node_put() to avoid the
refcount leak. As the remove function do.

Fixes: 5cdaaa12866e ("net: emaclite: adding MDIO and phy lib support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220308024751.2320-1-linmq006@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index df3b3384984c..1f9a6ea356b0 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1175,7 +1175,7 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 	if (rc) {
 		dev_err(dev,
 			"Cannot register network device, aborting\n");
-		goto error;
+		goto put_node;
 	}
 
 	dev_info(dev,
@@ -1183,6 +1183,8 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 		 (unsigned int __force)ndev->mem_start, lp->base_addr, ndev->irq);
 	return 0;
 
+put_node:
+	of_node_put(lp->phy_node);
 error:
 	xemaclite_remove_ndev(ndev);
 	return rc;
-- 
2.34.1



