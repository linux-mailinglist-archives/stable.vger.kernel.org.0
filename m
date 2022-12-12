Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 941CC64A193
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbiLLNmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbiLLNlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:41:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE5B14D1A
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:41:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 497A161089
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9636C433D2;
        Mon, 12 Dec 2022 13:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852468;
        bh=Ssi5CM6er/buYwwBkQa8pMnr45lXwybcTgdXz2EmpVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QdE5t4qWvOQ80Ka1I8bjk0YJsBltG0ZQHEDF1Dj6Z+m97HACOunJ0VaD+wEfV2tfZ
         5R20hhJIrFiXD+0CMm36GViY4l1ThYvIvadfTzGBZds1posvH1XL/5Ag4/Y+obdASd
         6nsMwfcUS25tFkxIraIgt+XckfvGMyBRjh+2uNlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Rosin <peda@axentia.se>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 086/157] ARM: at91: fix build for SAMA5D3 w/o L2 cache
Date:   Mon, 12 Dec 2022 14:17:14 +0100
Message-Id: <20221212130938.247917916@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: Peter Rosin <peda@axentia.se>

[ Upstream commit 6a3fc8c330d1c1fa3d8773d7d38a7c55c4900dfe ]

The L2 cache is present on the newer SAMA5D2 and SAMA5D4 families, but
apparently not for the older SAMA5D3.

Solves a build-time regression with the following symptom:

sama5.c:(.init.text+0x48): undefined reference to `outer_cache'

Fixes: 3b5a7ca7d252 ("ARM: at91: setup outer cache .write_sec() callback if needed")
Signed-off-by: Peter Rosin <peda@axentia.se>
[claudiu.beznea: delete "At least not always." from commit description]
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/b7f8dacc-5e1f-0eb2-188e-3ad9a9f7613d@axentia.se
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-at91/sama5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/sama5.c b/arch/arm/mach-at91/sama5.c
index 67ed68fbe3a5..bf2b5c6a18c6 100644
--- a/arch/arm/mach-at91/sama5.c
+++ b/arch/arm/mach-at91/sama5.c
@@ -26,7 +26,7 @@ static void sama5_l2c310_write_sec(unsigned long val, unsigned reg)
 static void __init sama5_secure_cache_init(void)
 {
 	sam_secure_init();
-	if (sam_linux_is_optee_available())
+	if (IS_ENABLED(CONFIG_OUTER_CACHE) && sam_linux_is_optee_available())
 		outer_cache.write_sec = sama5_l2c310_write_sec;
 }
 
-- 
2.35.1



