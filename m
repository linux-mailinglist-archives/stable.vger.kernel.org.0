Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E9E49A9BE
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323384AbiAYD2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:28:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57096 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353146AbiAXVEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:04:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B9BBB811A9;
        Mon, 24 Jan 2022 21:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674D4C340E5;
        Mon, 24 Jan 2022 21:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058257;
        bh=Px/8V69LgBn1lpcu7IMMdtgNlAppZ3FW1twrHtuTLLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqJrYtDm5q7UQmvolC+Ts37A8wRAXxKyJ/Ljy+z8zDkN2XZ/73GmAqp4p4752IIm4
         tJHv8Ot9Zxa0cNrI+/Ldb4tytoL1IQGuaMWI2+oj5HtgrTKIOyopbJQKkvUMTkdWyU
         fzKbuz4XS7Z0zjRxcnKXzEBh8Oz7WLLPL+AAevL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0197/1039] media: venus: core: Fix a resource leak in the error handling path of venus_probe()
Date:   Mon, 24 Jan 2022 19:33:06 +0100
Message-Id: <20220124184131.950143884@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index fd32385485fa6..877eca1258037 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -350,11 +350,11 @@ static int venus_probe(struct platform_device *pdev)
 
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
@@ -386,6 +386,10 @@ err_dev_unregister:
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



