Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4B0499A00
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456429AbiAXVjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443767AbiAXV1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:27:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBACC073210;
        Mon, 24 Jan 2022 12:18:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABB2CB8122D;
        Mon, 24 Jan 2022 20:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C63C340E5;
        Mon, 24 Jan 2022 20:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055499;
        bh=ayuHdt44yiGjS+h8udiibZejaqg80hjNXckpKzmMaOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJZ6y0WLY52s0qiGwxGqnw8MXRzZP0OCuBFbFumf5iyMDgQONV3SjCOkaEBFqWwlk
         KvCOkthb/DVptEsyIGsQWRTlK753wXXIbpCuexzETRCDOg5JzEBqx/css5vwISQP5r
         i+zQSl/fwwdauCw0IVyIfUUcN7HeWM/5+LQZ4jhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 171/846] media: venus: core: Fix a resource leak in the error handling path of venus_probe()
Date:   Mon, 24 Jan 2022 19:34:48 +0100
Message-Id: <20220124184106.877285650@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 84cd92628cfdc..1f0181b6353c9 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -349,11 +349,11 @@ static int venus_probe(struct platform_device *pdev)
 
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
@@ -385,6 +385,10 @@ err_dev_unregister:
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



