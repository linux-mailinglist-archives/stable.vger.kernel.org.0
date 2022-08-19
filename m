Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7857559A337
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353315AbiHSQmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354022AbiHSQlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:41:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB88D12844B;
        Fri, 19 Aug 2022 09:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 456D9B82826;
        Fri, 19 Aug 2022 16:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAC9C433C1;
        Fri, 19 Aug 2022 16:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925335;
        bh=VZBqk/YBd786B+HpOYTIMwbhmJyz3N1sfksTkvq66aU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2FwpgEV4DIZEl8oshCMHD82ebxt4t6i+569fWh7PZR2vNjfkF9prnY5CMVrHw4Fk
         ZMeohQ20RltaIxXUyGvw7til55MkhE/cLi9XLU2uBi5qUP9b0lfvnQsgRuE+3Vi031
         veFZUJ+c3WHio6byYCD5JtmUX9a8G99omLRSl2nU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 458/545] mtd: rawnand: Add a helper to clarify the interface configuration
Date:   Fri, 19 Aug 2022 17:43:48 +0200
Message-Id: <20220819153849.875336174@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 961965c45c706175b24227868b1c12d72775e446 ]

Name it nand_interface_is_sdr() which will make even more sense when
nand_interface_is_nvddr() will be introduced.

Use it when relevant.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210505213750.257417-2-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/atmel/nand-controller.c |  2 +-
 include/linux/mtd/rawnand.h                  | 11 ++++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/atmel/nand-controller.c b/drivers/mtd/nand/raw/atmel/nand-controller.c
index c048e826746a..2228c34f3dea 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -1246,7 +1246,7 @@ static int atmel_smc_nand_prepare_smcconf(struct atmel_nand *nand,
 	nc = to_nand_controller(nand->base.controller);
 
 	/* DDR interface not supported. */
-	if (conf->type != NAND_SDR_IFACE)
+	if (!nand_interface_is_sdr(conf))
 		return -ENOTSUPP;
 
 	/*
diff --git a/include/linux/mtd/rawnand.h b/include/linux/mtd/rawnand.h
index db2eaff77f41..75535036b126 100644
--- a/include/linux/mtd/rawnand.h
+++ b/include/linux/mtd/rawnand.h
@@ -499,6 +499,15 @@ struct nand_interface_config {
 	} timings;
 };
 
+/**
+ * nand_interface_is_sdr - get the interface type
+ * @conf:	The data interface
+ */
+static bool nand_interface_is_sdr(const struct nand_interface_config *conf)
+{
+	return conf->type == NAND_SDR_IFACE;
+}
+
 /**
  * nand_get_sdr_timings - get SDR timing from data interface
  * @conf:	The data interface
@@ -506,7 +515,7 @@ struct nand_interface_config {
 static inline const struct nand_sdr_timings *
 nand_get_sdr_timings(const struct nand_interface_config *conf)
 {
-	if (conf->type != NAND_SDR_IFACE)
+	if (!nand_interface_is_sdr(conf))
 		return ERR_PTR(-EINVAL);
 
 	return &conf->timings.sdr;
-- 
2.35.1



