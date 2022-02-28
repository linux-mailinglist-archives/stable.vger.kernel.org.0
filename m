Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB714C7728
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239919AbiB1SLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240615AbiB1SJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:09:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421035E745;
        Mon, 28 Feb 2022 09:48:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA037B81085;
        Mon, 28 Feb 2022 17:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252F1C340F0;
        Mon, 28 Feb 2022 17:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070513;
        bh=Mctlrf3HdcCTbx63QSjhn56D0LeSP5fiFh6Za9eOODA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N03bRiF7bf0sXFFa90cp86UofG7lpR/IuKkbDUL14Tlcxy3cLq7wLPgw6boan/1jJ
         lE2duhLDUlzOKg+eh/8Pf384N7l+o7z79CTudyPWh8mL0bjOz1n25rgtbBIQQ78iKj
         N+aQ64C+Xhq96p2kDUas8Ytys6qhAzFV02HxsRjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Kerello <christophe.kerello@foss.st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.16 135/164] nvmem: core: Fix a conflict between MTD and NVMEM on wp-gpios property
Date:   Mon, 28 Feb 2022 18:24:57 +0100
Message-Id: <20220228172412.262480435@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Kerello <christophe.kerello@foss.st.com>

commit f6c052afe6f802d87c74153b7a57c43b2e9faf07 upstream.

Wp-gpios property can be used on NVMEM nodes and the same property can
be also used on MTD NAND nodes. In case of the wp-gpios property is
defined at NAND level node, the GPIO management is done at NAND driver
level. Write protect is disabled when the driver is probed or resumed
and is enabled when the driver is released or suspended.

When no partitions are defined in the NAND DT node, then the NAND DT node
will be passed to NVMEM framework. If wp-gpios property is defined in
this node, the GPIO resource is taken twice and the NAND controller
driver fails to probe.

It would be possible to set config->wp_gpio at MTD level before calling
nvmem_register function but NVMEM framework will toggle this GPIO on
each write when this GPIO should only be controlled at NAND level driver
to ensure that the Write Protect has not been enabled.

A way to fix this conflict is to add a new boolean flag in nvmem_config
named ignore_wp. In case ignore_wp is set, the GPIO resource will
be managed by the provider.

Fixes: 2a127da461a9 ("nvmem: add support for the write-protect pin")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220220151432.16605-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c           |    2 +-
 include/linux/nvmem-provider.h |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -771,7 +771,7 @@ struct nvmem_device *nvmem_register(cons
 
 	if (config->wp_gpio)
 		nvmem->wp_gpio = config->wp_gpio;
-	else
+	else if (!config->ignore_wp)
 		nvmem->wp_gpio = gpiod_get_optional(config->dev, "wp",
 						    GPIOD_OUT_HIGH);
 	if (IS_ERR(nvmem->wp_gpio)) {
--- a/include/linux/nvmem-provider.h
+++ b/include/linux/nvmem-provider.h
@@ -70,7 +70,8 @@ struct nvmem_keepout {
  * @word_size:	Minimum read/write access granularity.
  * @stride:	Minimum read/write access stride.
  * @priv:	User context passed to read/write callbacks.
- * @wp-gpio:   Write protect pin
+ * @wp-gpio:	Write protect pin
+ * @ignore_wp:  Write Protect pin is managed by the provider.
  *
  * Note: A default "nvmem<id>" name will be assigned to the device if
  * no name is specified in its configuration. In such case "<id>" is
@@ -92,6 +93,7 @@ struct nvmem_config {
 	enum nvmem_type		type;
 	bool			read_only;
 	bool			root_only;
+	bool			ignore_wp;
 	struct device_node	*of_node;
 	bool			no_of_node;
 	nvmem_reg_read_t	reg_read;


