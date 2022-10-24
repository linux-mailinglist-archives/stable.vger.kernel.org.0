Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A49E60A308
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbiJXLuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiJXLtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:49:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697D439107;
        Mon, 24 Oct 2022 04:43:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75BBDB8118F;
        Mon, 24 Oct 2022 11:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1589C433C1;
        Mon, 24 Oct 2022 11:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611815;
        bh=BNOQsYZF/K2e4NRppXGPLidezNtKbq+7MS1OWtou5uY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZpVN1oUDym7o2eBDli4jCycKo4QNjhPrJAbEDxR4MoyncI5eZ34VZM4n5dKLgpCk
         qc96e5VcMFHk6yO448N9TQwi8YyFaUyVgJFyaMCCV1sGFYmvCCc/0MzHAcjBX0K9cT
         fPaTxg+Pnta4BdcGkOd3+VUqv2tqCoU8BBSbtox4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 114/159] mfd: sm501: Add check for platform_driver_register()
Date:   Mon, 24 Oct 2022 13:31:08 +0200
Message-Id: <20221024112953.644066781@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
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



