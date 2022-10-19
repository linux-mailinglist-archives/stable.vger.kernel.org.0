Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED2960473C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbiJSNf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbiJSNed (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:34:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442781DB898;
        Wed, 19 Oct 2022 06:23:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BA5DB82470;
        Wed, 19 Oct 2022 09:03:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0C4C433C1;
        Wed, 19 Oct 2022 09:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170238;
        bh=/HIERa100lh8MOJ+VnEm9GMQEByn7+Vm+HFFy4N/aVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gYkU8cKV9C2WyBw9VlhISJV8LsRwTuKAtA4do4DE8Kh0Ubw4EmUUOLBGcikaU5lo5
         Ys3f98mY2cP6YE0EeOYxxP+JicW3Q5KEJvZjvw1gpC+wUvAHxJBmtxwgmJ/6YLo/2c
         5nMIQprWEL9s6FlhTSf9NPWwF/9EDK9AQK50voms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 579/862] mfd: sm501: Add check for platform_driver_register()
Date:   Wed, 19 Oct 2022 10:31:06 +0200
Message-Id: <20221019083315.537366902@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index bc0a2c38653e..3ac4508a6742 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1720,7 +1720,12 @@ static struct platform_driver sm501_plat_driver = {
 
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



