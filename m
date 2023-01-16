Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C4166CAE5
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbjAPRJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:09:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233691AbjAPRHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:07:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8322C45225
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:48:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18F3661042
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302D6C433F0;
        Mon, 16 Jan 2023 16:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887702;
        bh=7v3cmMxCjmgs7gH5N/AHDgReQ6WaIZ98GDLrwbUHyeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YXJ7htK5ZiecmbeNBMWvTdioAm/GwSAe5AZCjeFSzi26QZSlncpo/TZNvSopLliBP
         77FGbLnYFYNAE5+ZydXGe87jXshAJA9f16IYfalOASx+S7gZkPmIEeSPqSQKsiwgGz
         C5hn60YKTcHn3uI3wLR5ej8aYdwoXRNYGgdQgJJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 249/521] i2c: mux: reg: check return value after calling platform_get_resource()
Date:   Mon, 16 Jan 2023 16:48:31 +0100
Message-Id: <20230116154858.276318742@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 2d47b79d2bd39cc6369eccf94a06568d84c906ae ]

It will cause null-ptr-deref in resource_size(), if platform_get_resource()
returns NULL, move calling resource_size() after devm_ioremap_resource() that
will check 'res' to avoid null-ptr-deref.
And use devm_platform_get_and_ioremap_resource() to simplify code.

Fixes: b3fdd32799d8 ("i2c: mux: Add register-based mux i2c-mux-reg")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/muxes/i2c-mux-reg.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-mux-reg.c b/drivers/i2c/muxes/i2c-mux-reg.c
index 5653295b01cd..6d5cb40bfc96 100644
--- a/drivers/i2c/muxes/i2c-mux-reg.c
+++ b/drivers/i2c/muxes/i2c-mux-reg.c
@@ -191,13 +191,12 @@ static int i2c_mux_reg_probe(struct platform_device *pdev)
 	if (!mux->data.reg) {
 		dev_info(&pdev->dev,
 			"Register not set, using platform resource\n");
-		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-		mux->data.reg_size = resource_size(res);
-		mux->data.reg = devm_ioremap_resource(&pdev->dev, res);
+		mux->data.reg = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 		if (IS_ERR(mux->data.reg)) {
 			ret = PTR_ERR(mux->data.reg);
 			goto err_put_parent;
 		}
+		mux->data.reg_size = resource_size(res);
 	}
 
 	if (mux->data.reg_size != 4 && mux->data.reg_size != 2 &&
-- 
2.35.1



