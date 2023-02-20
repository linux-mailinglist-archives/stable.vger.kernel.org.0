Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA9F69CDF6
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbjBTNyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbjBTNyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:54:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA92818B39
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:54:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8610060EA5
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935F5C433EF;
        Mon, 20 Feb 2023 13:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901275;
        bh=E4J1SfPrQ9PzXUqPoKTxAnSnXCn/cEr1/Lq0M7vCXek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtiUMNq+SUYpgIVpchss+9mu6jgQrK+TiV635/4dOE70CO/Sf7WbGFv8Li6QlTsMm
         EEJX8zNOBdGaVh5mkz0B2B0GrxrHRoU4bEmxnPtCFYvQYscHW+nW5J26iFyTBsPXkT
         UIGtnNGqiXFKssFXQ+vMOLrDLatntqmfz9OvW6yU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/57] nvmem: core: remove nvmem_config wp_gpio
Date:   Mon, 20 Feb 2023 14:36:21 +0100
Message-Id: <20230220133549.833227674@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
References: <20230220133549.360169435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 569653f022a29a1a44ea9de5308b657228303fa5 ]

No one provides wp_gpio, so let's remove it to avoid issues with
the nvmem core putting this gpio.

Cc: stable@vger.kernel.org
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230127104015.23839-5-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: ab3428cfd9aa ("nvmem: core: fix registration vs use race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c           | 4 +---
 include/linux/nvmem-provider.h | 2 --
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 9da4edbabfe75..38c05fce7d740 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -627,9 +627,7 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 
 	nvmem->id = rval;
 
-	if (config->wp_gpio)
-		nvmem->wp_gpio = config->wp_gpio;
-	else if (!config->ignore_wp)
+	if (!config->ignore_wp)
 		nvmem->wp_gpio = gpiod_get_optional(config->dev, "wp",
 						    GPIOD_OUT_HIGH);
 	if (IS_ERR(nvmem->wp_gpio)) {
diff --git a/include/linux/nvmem-provider.h b/include/linux/nvmem-provider.h
index 39ec67689898b..5e07f3cfad301 100644
--- a/include/linux/nvmem-provider.h
+++ b/include/linux/nvmem-provider.h
@@ -49,7 +49,6 @@ enum nvmem_type {
  * @word_size:	Minimum read/write access granularity.
  * @stride:	Minimum read/write access stride.
  * @priv:	User context passed to read/write callbacks.
- * @wp-gpio:	Write protect pin
  * @ignore_wp:  Write Protect pin is managed by the provider.
  *
  * Note: A default "nvmem<id>" name will be assigned to the device if
@@ -64,7 +63,6 @@ struct nvmem_config {
 	const char		*name;
 	int			id;
 	struct module		*owner;
-	struct gpio_desc	*wp_gpio;
 	const struct nvmem_cell_info	*cells;
 	int			ncells;
 	enum nvmem_type		type;
-- 
2.39.0



