Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58011608AFE
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 11:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiJVJSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 05:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiJVJSF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 05:18:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B382830A0DB;
        Sat, 22 Oct 2022 01:32:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ED5B3CE2CAD;
        Sat, 22 Oct 2022 07:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA5BC433D6;
        Sat, 22 Oct 2022 07:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425295;
        bh=AIPgOlTw2C29CZW+Rcr36Sfqvrn2uqvWjCZRKazOqQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yli5Fmwh6McwGdFLAXZ/NGXzjWhJlkYbKjtKw9TKSQFxrqVTUXgVIXc0Po+qQS7+d
         0nbCc0mX0zVC4bvkE18Btfusdri1prqDqbUyNNePWlQbgb1mG9mlNXSo2QQn07Rdi2
         Z7nNkBHAbmqXQIfuUTG346TQw28mhUDqABX/eeL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <neil.armstrong@linaro.org>,
        Lin Yujun <linyujun809@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 453/717] slimbus: qcom-ngd: Add error handling in of_qcom_slim_ngd_register
Date:   Sat, 22 Oct 2022 09:25:32 +0200
Message-Id: <20221022072518.316510505@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Yujun <linyujun809@huawei.com>

[ Upstream commit 42992cf187e4e4bcfe3c58f8fc7b1832c5652d9f ]

No error handling is performed when platform_device_add()
return fails. Refer to the error handling of driver_set_override(),
add error handling for platform_device_add().

Fixes: 917809e2280b ("slimbus: ngd: Add qcom SLIMBus NGD driver")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Lin Yujun <linyujun809@huawei.com>
Link: https://lore.kernel.org/r/20220914031953.94061-1-linyujun809@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index bacc6af1d51e..d29a1a9cf12f 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1470,7 +1470,13 @@ static int of_qcom_slim_ngd_register(struct device *parent,
 		ngd->pdev->dev.of_node = node;
 		ctrl->ngd = ngd;
 
-		platform_device_add(ngd->pdev);
+		ret = platform_device_add(ngd->pdev);
+		if (ret) {
+			platform_device_put(ngd->pdev);
+			kfree(ngd);
+			of_node_put(node);
+			return ret;
+		}
 		ngd->base = ctrl->base + ngd->id * data->offset +
 					(ngd->id - 1) * data->size;
 
-- 
2.35.1



