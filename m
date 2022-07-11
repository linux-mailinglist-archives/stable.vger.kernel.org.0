Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CBB56FBBA
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbiGKJew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232835AbiGKJeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:34:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E697B34E;
        Mon, 11 Jul 2022 02:18:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4DE56111F;
        Mon, 11 Jul 2022 09:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F76C34115;
        Mon, 11 Jul 2022 09:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531095;
        bh=vWqdF/QbE599LGS+3jp14cUHjUuyTGGqsN3uKJFlhX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m9o6/gZVaidwP++YmzV/qhvp7kRX1eV0uPCByezbZvjNQMBz6TjBfoyC7UHrEwiL6
         KU9XbqcuIirluX5SjGqbKlgb4WMPGb90FuYcqmYgLlXCAbNdyefMYtYy7pNnWXkGWr
         zgDhr5U2jA0xxw5jIOA8JrausH/Hp+zzAbCHwUm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        Yi Zhang <yi.zhang@redhat.com>,
        Terry Bowman <terry.bowman@amd.com>,
        Terry Bowman <Terry.Bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 077/112] i2c: piix4: Fix a memory leak in the EFCH MMIO support
Date:   Mon, 11 Jul 2022 11:07:17 +0200
Message-Id: <20220711090551.756719392@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean Delvare <jdelvare@suse.de>

[ Upstream commit 8ad59b397f86a4d8014966fdc0552095a0c4fb2b ]

The recently added support for EFCH MMIO regions introduced a memory
leak in that code path. The leak is caused by the fact that
release_resource() merely removes the resource from the tree but does
not free its memory. We need to call release_mem_region() instead,
which does free the memory. As a nice side effect, this brings back
some symmetry between the legacy and MMIO paths.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Reviewed-by: Terry Bowman <terry.bowman@amd.com>
Tested-by: Terry Bowman <Terry.Bowman@amd.com>
Fixes: 7c148722d074 ("i2c: piix4: Add EFCH MMIO support to region request and release")
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-piix4.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index ac8e7d60672a..39cb1b7bb865 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -161,7 +161,6 @@ static const char *piix4_aux_port_name_sb800 = " port 1";
 
 struct sb800_mmio_cfg {
 	void __iomem *addr;
-	struct resource *res;
 	bool use_mmio;
 };
 
@@ -179,13 +178,11 @@ static int piix4_sb800_region_request(struct device *dev,
 				      struct sb800_mmio_cfg *mmio_cfg)
 {
 	if (mmio_cfg->use_mmio) {
-		struct resource *res;
 		void __iomem *addr;
 
-		res = request_mem_region_muxed(SB800_PIIX4_FCH_PM_ADDR,
-					       SB800_PIIX4_FCH_PM_SIZE,
-					       "sb800_piix4_smb");
-		if (!res) {
+		if (!request_mem_region_muxed(SB800_PIIX4_FCH_PM_ADDR,
+					      SB800_PIIX4_FCH_PM_SIZE,
+					      "sb800_piix4_smb")) {
 			dev_err(dev,
 				"SMBus base address memory region 0x%x already in use.\n",
 				SB800_PIIX4_FCH_PM_ADDR);
@@ -195,12 +192,12 @@ static int piix4_sb800_region_request(struct device *dev,
 		addr = ioremap(SB800_PIIX4_FCH_PM_ADDR,
 			       SB800_PIIX4_FCH_PM_SIZE);
 		if (!addr) {
-			release_resource(res);
+			release_mem_region(SB800_PIIX4_FCH_PM_ADDR,
+					   SB800_PIIX4_FCH_PM_SIZE);
 			dev_err(dev, "SMBus base address mapping failed.\n");
 			return -ENOMEM;
 		}
 
-		mmio_cfg->res = res;
 		mmio_cfg->addr = addr;
 
 		return 0;
@@ -222,7 +219,8 @@ static void piix4_sb800_region_release(struct device *dev,
 {
 	if (mmio_cfg->use_mmio) {
 		iounmap(mmio_cfg->addr);
-		release_resource(mmio_cfg->res);
+		release_mem_region(SB800_PIIX4_FCH_PM_ADDR,
+				   SB800_PIIX4_FCH_PM_SIZE);
 		return;
 	}
 
-- 
2.35.1



