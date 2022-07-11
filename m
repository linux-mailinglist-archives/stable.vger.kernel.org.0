Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57C856FDF1
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbiGKKCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234336AbiGKKCG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:02:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042C12BDB;
        Mon, 11 Jul 2022 02:28:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FDEBB80E6D;
        Mon, 11 Jul 2022 09:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E050AC34115;
        Mon, 11 Jul 2022 09:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531715;
        bh=vWqdF/QbE599LGS+3jp14cUHjUuyTGGqsN3uKJFlhX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BISEjTt7U6nHgeyNI7YOqNU9uatGFXTU+YMNVFgSwgQf+4mPzqZCK9KcGWqbqobGg
         +m+m9fbW29EOQmv7BDijLdI1Q2mer7ls/SpCHckMfz1g/wji7/MRgc5GQIfGNnBW66
         dL79/4BdW4f4uQGVz+2QJKGxM8HPyw/WbmQyfeaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        Yi Zhang <yi.zhang@redhat.com>,
        Terry Bowman <terry.bowman@amd.com>,
        Terry Bowman <Terry.Bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 204/230] i2c: piix4: Fix a memory leak in the EFCH MMIO support
Date:   Mon, 11 Jul 2022 11:07:40 +0200
Message-Id: <20220711090609.891213114@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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



