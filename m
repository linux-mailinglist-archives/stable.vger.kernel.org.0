Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF90C49942B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388583AbiAXUjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385532AbiAXUdd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:33:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E855C07E2A8;
        Mon, 24 Jan 2022 11:46:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F272A61482;
        Mon, 24 Jan 2022 19:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E01C340E5;
        Mon, 24 Jan 2022 19:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053596;
        bh=/2RqlihE1x2dCaNhiMm97oLev/9P+gs0JBMsdtsmUIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J5M67QxNf2wCRsEemlc7dCMAc3ly0VncIF6enz2gHYV3wpYhxUjd87CNKWXJ85gn7
         yrtOV5cXjSjm6HrmTNOB6Rex7GOWmEMd8bEvauGS9yI84CIq13rcFSBgWazw1PjUwm
         niGGHGfn0L5yyxDyNiotOCY5OXND7AeE9FTdNADs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/563] media: venus: core: Fix a resource leak in the error handling path of venus_probe()
Date:   Mon, 24 Jan 2022 19:38:01 +0100
Message-Id: <20220124184028.432876496@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 8cc7a1b2aca067397a016cdb971a5e6ad9b640c7 ]

A successful 'of_platform_populate()' call should be balanced by a
corresponding 'of_platform_depopulate()' call in the error handling path
of the probe, as already done in the remove function.

A successful 'venus_firmware_init()' call should be balanced by a
corresponding 'venus_firmware_deinit()' call in the error handling path
of the probe, as already done in the remove function.

Update the error handling path accordingly.

Fixes: f9799fcce4bb ("media: venus: firmware: register separate platform_device for firmware loader")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 791ed1b1bbbd3..1d621f7769035 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -294,11 +294,11 @@ static int venus_probe(struct platform_device *pdev)
 
 	ret = venus_firmware_init(core);
 	if (ret)
-		goto err_runtime_disable;
+		goto err_of_depopulate;
 
 	ret = venus_boot(core);
 	if (ret)
-		goto err_runtime_disable;
+		goto err_firmware_deinit;
 
 	ret = hfi_core_resume(core, true);
 	if (ret)
@@ -330,6 +330,10 @@ err_dev_unregister:
 	v4l2_device_unregister(&core->v4l2_dev);
 err_venus_shutdown:
 	venus_shutdown(core);
+err_firmware_deinit:
+	venus_firmware_deinit(core);
+err_of_depopulate:
+	of_platform_depopulate(dev);
 err_runtime_disable:
 	pm_runtime_put_noidle(dev);
 	pm_runtime_set_suspended(dev);
-- 
2.34.1



