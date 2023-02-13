Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D54694A0A
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjBMPEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbjBMPET (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:04:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F461CAF8
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:03:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A4D86CE1BA1
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15CCC433D2;
        Mon, 13 Feb 2023 15:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300635;
        bh=AiN/WcsJAbp8dOzlKIJ1WO1WXc0pLDS+sTPFN74s+v0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1NsVkXlpxoWhvHURANvRXfvvCxIdsOZXGdlD7O/byvRZyt/Mz/SwTjX6C1vCyP4qD
         nZCu6kkxHS4ejWqUhk6MttI8sJqMU1ztnst7JNXg1OJNd8WNVv0RW8xu+FruiwRp0h
         9T1YVOBYWb/fj1YfydbFq7/Jur82Mz/U0Zcwr7g0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe Kerello <christophe.kerello@foss.st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/139] nvmem: core: Fix a conflict between MTD and NVMEM on wp-gpios property
Date:   Mon, 13 Feb 2023 15:50:34 +0100
Message-Id: <20230213144750.528935596@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
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

From: Christophe Kerello <christophe.kerello@foss.st.com>

[ Upstream commit f6c052afe6f802d87c74153b7a57c43b2e9faf07 ]

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
Stable-dep-of: ab3428cfd9aa ("nvmem: core: fix registration vs use race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c           | 2 +-
 include/linux/nvmem-provider.h | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 7b281ae540ad8..48fbe49e3772b 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -629,7 +629,7 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 
 	if (config->wp_gpio)
 		nvmem->wp_gpio = config->wp_gpio;
-	else
+	else if (!config->ignore_wp)
 		nvmem->wp_gpio = gpiod_get_optional(config->dev, "wp",
 						    GPIOD_OUT_HIGH);
 	if (IS_ERR(nvmem->wp_gpio)) {
diff --git a/include/linux/nvmem-provider.h b/include/linux/nvmem-provider.h
index 06409a6c40bcb..39ec67689898b 100644
--- a/include/linux/nvmem-provider.h
+++ b/include/linux/nvmem-provider.h
@@ -49,7 +49,8 @@ enum nvmem_type {
  * @word_size:	Minimum read/write access granularity.
  * @stride:	Minimum read/write access stride.
  * @priv:	User context passed to read/write callbacks.
- * @wp-gpio:   Write protect pin
+ * @wp-gpio:	Write protect pin
+ * @ignore_wp:  Write Protect pin is managed by the provider.
  *
  * Note: A default "nvmem<id>" name will be assigned to the device if
  * no name is specified in its configuration. In such case "<id>" is
@@ -69,6 +70,7 @@ struct nvmem_config {
 	enum nvmem_type		type;
 	bool			read_only;
 	bool			root_only;
+	bool			ignore_wp;
 	bool			no_of_node;
 	nvmem_reg_read_t	reg_read;
 	nvmem_reg_write_t	reg_write;
-- 
2.39.0



