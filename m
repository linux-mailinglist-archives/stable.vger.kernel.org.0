Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD7360AA3E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiJXNbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236199AbiJXN35 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:29:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760A6AC4B2;
        Mon, 24 Oct 2022 05:33:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EC71B815BD;
        Mon, 24 Oct 2022 12:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A608AC433C1;
        Mon, 24 Oct 2022 12:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613427;
        bh=oYRhmtQE/klOFsQCHCsRhaWDY77M6fjbrOG794N8IJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lN+9P4cZCntknjUGfcRbTfsww9N6PoQYfl/7HL0Tsa6yfwKt1WYaatQRkliJx8eSX
         UgYDjZZiszSdJRQJj06R0NGP60CC1WWCOzzge6Xq3IZpS7lsMCvE6qeOmynlMuyKmm
         VbqjS+vfRICSK+50gRwd4yrLLMBF6Cq5nMiE+qm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 133/255] media: xilinx: vipp: Fix refcount leak in xvip_graph_dma_init
Date:   Mon, 24 Oct 2022 13:30:43 +0200
Message-Id: <20221024113007.001252156@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 1c78f19c3a0ea312a8178a6bfd8934eb93e9b10a ]

of_get_child_by_name() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: df3305156f98 ("[media] v4l: xilinx: Add Xilinx Video IP core")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/xilinx/xilinx-vipp.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index cc2856efea59..f2b0c490187c 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -472,7 +472,7 @@ static int xvip_graph_dma_init(struct xvip_composite_device *xdev)
 {
 	struct device_node *ports;
 	struct device_node *port;
-	int ret;
+	int ret = 0;
 
 	ports = of_get_child_by_name(xdev->dev->of_node, "ports");
 	if (ports == NULL) {
@@ -482,13 +482,14 @@ static int xvip_graph_dma_init(struct xvip_composite_device *xdev)
 
 	for_each_child_of_node(ports, port) {
 		ret = xvip_graph_dma_init_one(xdev, port);
-		if (ret < 0) {
+		if (ret) {
 			of_node_put(port);
-			return ret;
+			break;
 		}
 	}
 
-	return 0;
+	of_node_put(ports);
+	return ret;
 }
 
 static void xvip_graph_cleanup(struct xvip_composite_device *xdev)
-- 
2.35.1



