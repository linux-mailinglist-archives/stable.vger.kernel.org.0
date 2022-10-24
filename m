Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604CD60A467
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiJXMKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233089AbiJXMJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:09:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814127F269;
        Mon, 24 Oct 2022 04:52:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0B6EB8117E;
        Mon, 24 Oct 2022 11:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05096C43141;
        Mon, 24 Oct 2022 11:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612300;
        bh=BNOQsYZF/K2e4NRppXGPLidezNtKbq+7MS1OWtou5uY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fO+cGc82yzHIp69z1cmxUUyNCt95NcTevhzndod1IaPp7/edefo4YYE/TRXl0+KAV
         GOujpLcXByMGLuFRPQNojuDyWWvc9c5FKvVkbLM2enLYkK49TiY8MhGY8tytn7vIlI
         8p9OaHzjaSw/1Ytf42VYE1UtObkG8VbV5kAe5MYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 146/210] mfd: sm501: Add check for platform_driver_register()
Date:   Mon, 24 Oct 2022 13:31:03 +0200
Message-Id: <20221024113001.714031697@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 8325a6c24ad78b8c1acc3c42b098ee24105d68e5 ]

As platform_driver_register() can return error numbers,
it should be better to check platform_driver_register()
and deal with the exception.

Fixes: b6d6454fdb66 ("[PATCH] mfd: SM501 core driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20220913091112.1739138-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/sm501.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 4ca245518a19..d64bd28cc6b8 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1736,7 +1736,12 @@ static struct platform_driver sm501_plat_driver = {
 
 static int __init sm501_base_init(void)
 {
-	platform_driver_register(&sm501_plat_driver);
+	int ret;
+
+	ret = platform_driver_register(&sm501_plat_driver);
+	if (ret < 0)
+		return ret;
+
 	return pci_register_driver(&sm501_pci_driver);
 }
 
-- 
2.35.1



