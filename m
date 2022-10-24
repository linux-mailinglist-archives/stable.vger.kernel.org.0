Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5D360A429
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiJXMFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbiJXMEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:04:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A81ED73;
        Mon, 24 Oct 2022 04:50:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82626612B2;
        Mon, 24 Oct 2022 11:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96674C433D7;
        Mon, 24 Oct 2022 11:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612237;
        bh=CW8gk3mYFvAel/RUsGWu75S5tMb8UzsMZGE5o3hFPAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CP319DYXqlbPd4IGdPVTvW3rY6rEiiQ0ARfl0m9Tp7nFHewtGU6PJIysqu+TFb2+o
         6cDgouG6chlRvRhd4kkKLDvBrpHC/LlxOwlvZrLd+XyVnZ0FvLPhGxT5aBsD+SXWCZ
         9M/hLnL5k5WwkVh844f7Lh+/HiakcKcmsA8hvOTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 121/210] HSI: omap_ssi: Fix refcount leak in ssi_probe
Date:   Mon, 24 Oct 2022 13:30:38 +0200
Message-Id: <20221024113000.907205001@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
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

[ Upstream commit 9a2ea132df860177b33c9fd421b26c4e9a0a9396 ]

When returning or breaking early from a
for_each_available_child_of_node() loop, we need to explicitly call
of_node_put() on the child node to possibly release the node.

Fixes: b209e047bc74 ("HSI: Introduce OMAP SSI driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/controllers/omap_ssi_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hsi/controllers/omap_ssi_core.c b/drivers/hsi/controllers/omap_ssi_core.c
index 3554443a609c..6e9d88d9d471 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -560,6 +560,7 @@ static int ssi_probe(struct platform_device *pd)
 		if (!childpdev) {
 			err = -ENODEV;
 			dev_err(&pd->dev, "failed to create ssi controller port\n");
+			of_node_put(child);
 			goto out3;
 		}
 	}
-- 
2.35.1



