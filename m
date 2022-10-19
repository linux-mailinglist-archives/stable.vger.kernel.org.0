Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF446043E4
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbiJSLxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbiJSLwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:52:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8081ACA84;
        Wed, 19 Oct 2022 04:31:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A4F2ECE2170;
        Wed, 19 Oct 2022 09:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C502CC433C1;
        Wed, 19 Oct 2022 09:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170291;
        bh=AIPgOlTw2C29CZW+Rcr36Sfqvrn2uqvWjCZRKazOqQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPyOXGHKxg13vb4UmrEf0/Ue6S6nsUQ82IOUsKUTTnC+Xw0fe1fzPgjIHSTez7OD6
         V68xrBimGBocJrKx65NZQuXHC1YQdgcvzKJiYpt1rXMLpk8xrrPfSo25+VRvt8ruTc
         O1Ugx5uVEWhiGjm7wkT3xf3vdNGnyvQCupPsqQIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <neil.armstrong@linaro.org>,
        Lin Yujun <linyujun809@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 562/862] slimbus: qcom-ngd: Add error handling in of_qcom_slim_ngd_register
Date:   Wed, 19 Oct 2022 10:30:49 +0200
Message-Id: <20221019083314.815961935@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



