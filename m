Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12374C634C
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 07:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbiB1Go7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 01:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbiB1Go7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 01:44:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB328443E6
        for <stable@vger.kernel.org>; Sun, 27 Feb 2022 22:44:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9ED70B80E26
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 06:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AC8C340E7;
        Mon, 28 Feb 2022 06:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646030658;
        bh=zYksyrHnhXv9yfQq8lfC7G3aeV0IUWGXXZOjHl7Mua8=;
        h=Subject:To:Cc:From:Date:From;
        b=rqKZyUoAlzYS8OMwvfGs+NzA/8RGIWVNoRfiV2LC41ZwSLC5Q/T3PK5zl0Y1ATfmb
         zWARd1ViGVf0XYqc+XV9OkS411sIx9t4UMuWWRqBZjnwJs+UqDDkBwb9vTWlLf9veU
         s/3ijPwgdJE1YO9eRZdosH/9LWbXVl2PUxWsgTEI=
Subject: FAILED: patch "[PATCH] mtd: core: Fix a conflict between MTD and NVMEM on wp-gpios" failed to apply to 5.10-stable tree
To:     christophe.kerello@foss.st.com, gregkh@linuxfoundation.org,
        miquel.raynal@bootlin.com, srinivas.kandagatla@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Feb 2022 07:44:15 +0100
Message-ID: <1646030655101243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6c7621890995d089a56a06d11580d185ede7c2f8 Mon Sep 17 00:00:00 2001
From: Christophe Kerello <christophe.kerello@foss.st.com>
Date: Sun, 20 Feb 2022 15:14:32 +0000
Subject: [PATCH] mtd: core: Fix a conflict between MTD and NVMEM on wp-gpios
 property

Wp-gpios property can be used on NVMEM nodes and the same property can
be also used on MTD NAND nodes. In case of the wp-gpios property is
defined at NAND level node, the GPIO management is done at NAND driver
level. Write protect is disabled when the driver is probed or resumed
and is enabled when the driver is released or suspended.

When no partitions are defined in the NAND DT node, then the NAND DT node
will be passed to NVMEM framework. If wp-gpios property is defined in
this node, the GPIO resource is taken twice and the NAND controller
driver fails to probe.

A new Boolean flag named ignore_wp has been added in nvmem_config.
In case ignore_wp is set, it means that the GPIO is handled by the
provider. Lets set this flag in MTD layer to avoid the conflict on
wp_gpios property.

Fixes: 2a127da461a9 ("nvmem: add support for the write-protect pin")
Cc: stable@vger.kernel.org
Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220220151432.16605-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 70f492dce158..eef87b28d6c8 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -546,6 +546,7 @@ static int mtd_nvmem_add(struct mtd_info *mtd)
 	config.stride = 1;
 	config.read_only = true;
 	config.root_only = true;
+	config.ignore_wp = true;
 	config.no_of_node = !of_device_is_compatible(node, "nvmem-cells");
 	config.priv = mtd;
 
@@ -833,6 +834,7 @@ static struct nvmem_device *mtd_otp_nvmem_register(struct mtd_info *mtd,
 	config.owner = THIS_MODULE;
 	config.type = NVMEM_TYPE_OTP;
 	config.root_only = true;
+	config.ignore_wp = true;
 	config.reg_read = reg_read;
 	config.size = size;
 	config.of_node = np;

