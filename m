Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB1064A2A3
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbiLLN5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiLLN4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:56:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF39140AC
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:56:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CCF561072
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CC5C433EF;
        Mon, 12 Dec 2022 13:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670853391;
        bh=0pi/XAVZUGOzlKeZtVbwOonFwg6L1ZpZDTRnv9HS09s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ME7k3KCyHW2WvaCtdRyTkoakddKLTSQbpNr/TgqhGewKQu6q3Qoh4G67qGUF99KX7
         C+3Mhfx3CUw0ltMCTRKSHEf9jxbdIt2l6UvHGTJrjSbxD0I+QM3h7vGqeca2RGk71y
         ytiuMs8nGZaRZ4fSgs/SY/yQMhBt/j4Ih5VXpSlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Valentina Goncharenko <goncharenko.vp@ispras.ru>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 22/31] net: encx24j600: Fix invalid logic in reading of MISTAT register
Date:   Mon, 12 Dec 2022 14:19:40 +0100
Message-Id: <20221212130911.215765558@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130909.943483205@linuxfoundation.org>
References: <20221212130909.943483205@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentina Goncharenko <goncharenko.vp@ispras.ru>

[ Upstream commit 25f427ac7b8d89b0259f86c0c6407b329df742b2 ]

A loop for reading MISTAT register continues while regmap_read() fails
and (mistat & BUSY), but if regmap_read() fails a value of mistat is
undefined.

The patch proposes to check for BUSY flag only when regmap_read()
succeed. Compile test only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: d70e53262f5c ("net: Microchip encx24j600 driver")
Signed-off-by: Valentina Goncharenko <goncharenko.vp@ispras.ru>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/encx24j600-regmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/encx24j600-regmap.c b/drivers/net/ethernet/microchip/encx24j600-regmap.c
index 44e656048c51..668a63abe0cb 100644
--- a/drivers/net/ethernet/microchip/encx24j600-regmap.c
+++ b/drivers/net/ethernet/microchip/encx24j600-regmap.c
@@ -363,7 +363,7 @@ static int regmap_encx24j600_phy_reg_read(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) == 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
@@ -401,7 +401,7 @@ static int regmap_encx24j600_phy_reg_write(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) == 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
-- 
2.35.1



