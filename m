Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C264D810D
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239244AbiCNLin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239487AbiCNLiI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:38:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC42424A9;
        Mon, 14 Mar 2022 04:36:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F09CFB80DB9;
        Mon, 14 Mar 2022 11:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321A3C340E9;
        Mon, 14 Mar 2022 11:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647257814;
        bh=YAFDBS0Bw/lGubt3dUbE8i0o7QpFx6n12xGTpFJ+emA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BPefH662BmCPDu9escGQ8GU3D9kxr4bu7lrhezZVX8VuLgDGQnRkL5sxraSRmDohG
         zZbVgacfpeZmIniWfR6LfTm3m1WgJ+ZHkTQZuMLT2ohrZx06sqUdVRXsxp0gUia/53
         mZNM48MnnZFWzv6LXqGLjdz0AwfNNZ/X3I3sugHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 03/23] ethernet: Fix error handling in xemaclite_of_probe
Date:   Mon, 14 Mar 2022 12:34:16 +0100
Message-Id: <20220314112731.154029612@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112731.050583127@linuxfoundation.org>
References: <20220314112731.050583127@linuxfoundation.org>
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
index 5261796ce708..d83e6743f156 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1161,7 +1161,7 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 	if (rc) {
 		dev_err(dev,
 			"Cannot register network device, aborting\n");
-		goto error;
+		goto put_node;
 	}
 
 	dev_info(dev,
@@ -1169,6 +1169,8 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 		 (unsigned int __force)ndev->mem_start, lp->base_addr, ndev->irq);
 	return 0;
 
+put_node:
+	of_node_put(lp->phy_node);
 error:
 	free_netdev(ndev);
 	return rc;
-- 
2.34.1



