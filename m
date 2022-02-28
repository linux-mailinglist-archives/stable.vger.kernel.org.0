Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176204C76FD
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbiB1SKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240726AbiB1SJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:09:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7033F5EDD3;
        Mon, 28 Feb 2022 09:49:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB7A26098A;
        Mon, 28 Feb 2022 17:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CFDC340E7;
        Mon, 28 Feb 2022 17:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070516;
        bh=ZeUaeCJFJ4bWJ2ejkrzVSGb9kDF1BPevUpezIc/prvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c22YwA0eENFTd/Q1pimEApjiv6hh9JoOu+pDLUcoZOVwRZ4oq8tJ2aeM+CeB/WMQ7
         z0Kkpsh8BKAPk5mUudmu778Kh46iZbK57kHDEP2lsQsVEwkS86JXx49nhb5uPtb29p
         lWgcceIVmjESnjek6a7tZMCzwO5fByQ2Tz0yjj5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Christophe Kerello <christophe.kerello@foss.st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.16 136/164] mtd: core: Fix a conflict between MTD and NVMEM on wp-gpios property
Date:   Mon, 28 Feb 2022 18:24:58 +0100
Message-Id: <20220228172412.339466039@linuxfoundation.org>
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

commit 6c7621890995d089a56a06d11580d185ede7c2f8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdcore.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -546,6 +546,7 @@ static int mtd_nvmem_add(struct mtd_info
 	config.stride = 1;
 	config.read_only = true;
 	config.root_only = true;
+	config.ignore_wp = true;
 	config.no_of_node = !of_device_is_compatible(node, "nvmem-cells");
 	config.priv = mtd;
 
@@ -830,6 +831,7 @@ static struct nvmem_device *mtd_otp_nvme
 	config.owner = THIS_MODULE;
 	config.type = NVMEM_TYPE_OTP;
 	config.root_only = true;
+	config.ignore_wp = true;
 	config.reg_read = reg_read;
 	config.size = size;
 	config.of_node = np;


