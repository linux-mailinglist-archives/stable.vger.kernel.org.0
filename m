Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88FFD593F34
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243210AbiHOUwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346288AbiHOUuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:50:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC92B99FA;
        Mon, 15 Aug 2022 12:09:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D72E0CE12C4;
        Mon, 15 Aug 2022 19:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76F3C433C1;
        Mon, 15 Aug 2022 19:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590564;
        bh=3fm56voGlBMufrAF3Z9RjuxGbxgbRM8mf6liRp3l0UQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdnytPmzWAriUYc1/gIGLM7jsV2nxFI6IVulP00y/iGCVBQhDYwiEO0LDpPMB+uXC
         cET0Pi+1ny2w6uViasEqrhXGjXf9AvCg6eTRljnYy/1Dt/q0EcTATdcDGejLa0wI0j
         4wHw1th4BSE08h7fWHRje6uYOzITpqffCl43xVqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0269/1095] spi: Fix simplification of devm_spi_register_controller
Date:   Mon, 15 Aug 2022 19:54:28 +0200
Message-Id: <20220815180440.876024149@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 43cc5a0afe4184a7fafe1eba32b5a11bb69c9ce0 ]

This reverts commit 59ebbe40fb51 ("spi: simplify
devm_spi_register_controller").

If devm_add_action() fails in devm_add_action_or_reset(),
devm_spi_unregister() will be called, it decreases the
refcount of 'ctlr->dev' to 0, then it will cause uaf in
the drivers that calling spi_put_controller() in error path.

Fixes: 59ebbe40fb51 ("spi: simplify devm_spi_register_controller")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20220712135504.1055688-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index e1065768c537..6a8850e62078 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -3068,9 +3068,9 @@ int spi_register_controller(struct spi_controller *ctlr)
 }
 EXPORT_SYMBOL_GPL(spi_register_controller);
 
-static void devm_spi_unregister(void *ctlr)
+static void devm_spi_unregister(struct device *dev, void *res)
 {
-	spi_unregister_controller(ctlr);
+	spi_unregister_controller(*(struct spi_controller **)res);
 }
 
 /**
@@ -3089,13 +3089,22 @@ static void devm_spi_unregister(void *ctlr)
 int devm_spi_register_controller(struct device *dev,
 				 struct spi_controller *ctlr)
 {
+	struct spi_controller **ptr;
 	int ret;
 
+	ptr = devres_alloc(devm_spi_unregister, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
+
 	ret = spi_register_controller(ctlr);
-	if (ret)
-		return ret;
+	if (!ret) {
+		*ptr = ctlr;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
 
-	return devm_add_action_or_reset(dev, devm_spi_unregister, ctlr);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(devm_spi_register_controller);
 
-- 
2.35.1



