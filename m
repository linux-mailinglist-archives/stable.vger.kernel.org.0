Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0EC59A184
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350965AbiHSQAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350960AbiHSP71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:59:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4201108FBB;
        Fri, 19 Aug 2022 08:52:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D922B82812;
        Fri, 19 Aug 2022 15:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415A3C433D7;
        Fri, 19 Aug 2022 15:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924321;
        bh=qFtJTFkGXlUimLZQdQpb9oM5fPuVizHi3ChcOSFqcV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vo8WdwDufZTnndvifm71IZTHUylGGybiLfNLbLSiXDpYk2AHyiZIih2GUw45okp/i
         ImlHbdZNAPUFT+OeqkcJGJX+/6ZTiuqSAtheiZY96G0sNVVmiOAoHKNoijxnKx8rtD
         tFXwQkBFg9MQ4YtGc45wXj+MFscsLPlHYxY8mu3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Brian Masney <masneyb@onstation.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/545] soc: qcom: ocmem: Fix refcount leak in of_get_ocmem
Date:   Fri, 19 Aug 2022 17:38:22 +0200
Message-Id: <20220819153835.238280205@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 92a563fcf14b3093226fb36f12e9b5cf630c5a5d ]

of_parse_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.
of_node_put() will check NULL pointer.

Fixes: 88c1e9404f1d ("soc: qcom: add OCMEM driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Brian Masney <masneyb@onstation.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220602042430.1114-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/ocmem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/soc/qcom/ocmem.c b/drivers/soc/qcom/ocmem.c
index 85f82e195ef8..1dfdd0b9ba24 100644
--- a/drivers/soc/qcom/ocmem.c
+++ b/drivers/soc/qcom/ocmem.c
@@ -194,14 +194,17 @@ struct ocmem *of_get_ocmem(struct device *dev)
 	devnode = of_parse_phandle(dev->of_node, "sram", 0);
 	if (!devnode || !devnode->parent) {
 		dev_err(dev, "Cannot look up sram phandle\n");
+		of_node_put(devnode);
 		return ERR_PTR(-ENODEV);
 	}
 
 	pdev = of_find_device_by_node(devnode->parent);
 	if (!pdev) {
 		dev_err(dev, "Cannot find device node %s\n", devnode->name);
+		of_node_put(devnode);
 		return ERR_PTR(-EPROBE_DEFER);
 	}
+	of_node_put(devnode);
 
 	ocmem = platform_get_drvdata(pdev);
 	if (!ocmem) {
-- 
2.35.1



