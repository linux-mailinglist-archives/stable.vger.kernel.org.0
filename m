Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB1060A2CF
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiJXLsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbiJXLrU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:47:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F7E6EF2B;
        Mon, 24 Oct 2022 04:42:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DA69B8113E;
        Mon, 24 Oct 2022 11:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA666C433C1;
        Mon, 24 Oct 2022 11:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611755;
        bh=//JnKSgNXoTTrTg8+1UvYR3LNAJAPNMWNCUL101lLtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pS66SZsWho/Beon/docKm8TKVwjjORn5wrV1hUc0HqmQpfMKNoYwp93O3j2jH5yAF
         RgI5sDwIa1TA/jlsrfkoGNQ/bkXa/yNyFhpThuJIDtfvl8CaTZ1jfP0fef8jjQCBDh
         v69xZnlic19KmXS3D36xYM7jjc5xBtSbwIK3duPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 099/159] media: xilinx: vipp: Fix refcount leak in xvip_graph_dma_init
Date:   Mon, 24 Oct 2022 13:30:53 +0200
Message-Id: <20221024112953.053104501@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
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
index feb3b2f1d874..df21646ef9fa 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -462,7 +462,7 @@ static int xvip_graph_dma_init(struct xvip_composite_device *xdev)
 {
 	struct device_node *ports;
 	struct device_node *port;
-	int ret;
+	int ret = 0;
 
 	ports = of_get_child_by_name(xdev->dev->of_node, "ports");
 	if (ports == NULL) {
@@ -472,13 +472,14 @@ static int xvip_graph_dma_init(struct xvip_composite_device *xdev)
 
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



