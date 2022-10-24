Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C0960BB1E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbiJXUrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235154AbiJXUqe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:46:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B45A1D0C7;
        Mon, 24 Oct 2022 11:54:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61C3761295;
        Mon, 24 Oct 2022 12:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746BFC433D7;
        Mon, 24 Oct 2022 12:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613497;
        bh=oYcz0CeD1bLDLIcWSYmweAHkK+Sk99SWfYn/Sl9KipI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H90afxO+F/yU06bm8N2Y6M4tnJIVKxmsAAf4SXYx9n+dMp4nfKBWk6UX3S4xBFNLg
         1LTQ3Y7pCJO9AektYgs/rJXSr4y9CEu1IKqfI0CPqN+B4/ZDONkf5MKw/CFK7u5Chj
         AWrKabGKB7uGCAS3yBqAz/bLpq1ITUtCXZRuJWWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 129/255] HSI: omap_ssi: Fix refcount leak in ssi_probe
Date:   Mon, 24 Oct 2022 13:30:39 +0200
Message-Id: <20221024113006.859257762@linuxfoundation.org>
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
index f36036be7f03..5aa6955b609f 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -524,6 +524,7 @@ static int ssi_probe(struct platform_device *pd)
 		if (!childpdev) {
 			err = -ENODEV;
 			dev_err(&pd->dev, "failed to create ssi controller port\n");
+			of_node_put(child);
 			goto out3;
 		}
 	}
-- 
2.35.1



