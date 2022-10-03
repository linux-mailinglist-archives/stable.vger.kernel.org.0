Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FD15F2A0A
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbiJCH3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiJCH3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:29:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AB917592;
        Mon,  3 Oct 2022 00:19:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFE20B80E8A;
        Mon,  3 Oct 2022 07:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E4FC433D7;
        Mon,  3 Oct 2022 07:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781507;
        bh=rbGALLdGpMoXn3faPKL8k519MdGxpF/HHBObKz4rX/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ii6xqogbUcOnkAgRMuie84Jyk47LKE8p91IJzn0vERb6DL2OH2wzT8xMhucal5O/d
         OlKlMIaboCI6eNAy+8njaqbm4AC6mLq4pTLZEGJDg3Y1B+Etg9ZyNq4vVuHpAoHUEP
         1Hpv8YaJHNXirZqorKhnSZ8YkpHbYkJB0OXezPa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 46/83] soc: sunxi: sram: Fix debugfs info for A64 SRAM C
Date:   Mon,  3 Oct 2022 09:11:11 +0200
Message-Id: <20221003070723.148776309@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
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

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit e3c95edb1bd8b9c2cb0caa6ae382fc8080f6a0ed ]

The labels were backward with respect to the register values. The SRAM
is mapped to the CPU when the register value is 1.

Fixes: 5e4fb6429761 ("drivers: soc: sunxi: add support for A64 and its SRAM C")
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20220815041248.53268-7-samuel@sholland.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/sunxi/sunxi_sram.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/sunxi/sunxi_sram.c b/drivers/soc/sunxi/sunxi_sram.c
index 52d07bed7664..09754cd1d57d 100644
--- a/drivers/soc/sunxi/sunxi_sram.c
+++ b/drivers/soc/sunxi/sunxi_sram.c
@@ -78,8 +78,8 @@ static struct sunxi_sram_desc sun4i_a10_sram_d = {
 
 static struct sunxi_sram_desc sun50i_a64_sram_c = {
 	.data	= SUNXI_SRAM_DATA("C", 0x4, 24, 1,
-				  SUNXI_SRAM_MAP(0, 1, "cpu"),
-				  SUNXI_SRAM_MAP(1, 0, "de2")),
+				  SUNXI_SRAM_MAP(1, 0, "cpu"),
+				  SUNXI_SRAM_MAP(0, 1, "de2")),
 };
 
 static const struct of_device_id sunxi_sram_dt_ids[] = {
-- 
2.35.1



