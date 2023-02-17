Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7803A69AF88
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 16:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjBQPbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 10:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjBQPbe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 10:31:34 -0500
X-Greylist: delayed 3623 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 17 Feb 2023 07:31:30 PST
Received: from mail.pr-group.ru (mail.pr-group.ru [178.18.215.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC116F3E7;
        Fri, 17 Feb 2023 07:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-transfer-encoding;
        bh=c/4vBN3nQqBWLIIsDr6bAnmepObZf4pgFEzfOBLDMG0=;
        b=R/tER2zMUKHtPFfCpbDT3N+K0DGf2KcDXFSKxn6892pcYpCzd6VjpnOYAc1SL+/JZKR3r5TnyAKO8
         J+XRZcVeJcfdRu9ylMJSwi2AmmrdERZtXCiBNvHzfpgCt/22lKcupFMCjJYKyjVwXiosC9qJ4tqyrO
         9YEVjHl+pPujGfQbKf3wZtqnQGhq5tWM9wmDYikTujayK0sa/quATXYrqySXDCh7zr174S3yOANuRY
         14lEzroCsH33HbuVmUQuivEbk0iPoVjcU1UYdgSCx5toFRewBMU6W8uR3QuTaavzw8OJeDJ1o4jnx3
         X3d5dmMKfX8jJTBHaIzuw5FKh2keMzw==
X-Kerio-Anti-Spam:  Build: [Engines: 2.17.1.1470, Stamp: 3], Multi: [Enabled, t: (0.000009,0.008089)], BW: [Enabled, t: (0.000023,0.000001)], RTDA: [Enabled, t: (0.410493), Hit: No, Details: v2.47.0; Id: 15.bhp4c.1gpfqqp4j.2fr; mclb], total: 0(700)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from localhost.localdomain ([78.37.166.219])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Fri, 17 Feb 2023 17:00:41 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     linux-imx@nxp.com
Cc:     Ivan Bornyakov <i.bornyakov@metrotek.ru>, shawnguo@kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] bus: imx-weim: fix branch condition evaluates to a garbage value
Date:   Fri, 17 Feb 2023 16:59:50 +0300
Message-Id: <20230217135950.19469-1-i.bornyakov@metrotek.ru>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If bus type is other than imx50_weim_devtype and have no child devices,
variable 'ret' in function weim_parse_dt() will not be initialized, but
will be used as branch condition and return value. Fix this by
initializing 'ret' with 0.

This was discovered with help of clang-analyzer, but the situation is
quite possible in real life.

Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc: stable@vger.kernel.org
---
 drivers/bus/imx-weim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/imx-weim.c b/drivers/bus/imx-weim.c
index 828c66bbaa67..55d917bd1f3f 100644
--- a/drivers/bus/imx-weim.c
+++ b/drivers/bus/imx-weim.c
@@ -204,8 +204,8 @@ static int weim_parse_dt(struct platform_device *pdev)
 	const struct of_device_id *of_id = of_match_device(weim_id_table,
 							   &pdev->dev);
 	const struct imx_weim_devtype *devtype = of_id->data;
+	int ret = 0, have_child = 0;
 	struct device_node *child;
-	int ret, have_child = 0;
 	struct weim_priv *priv;
 	void __iomem *base;
 	u32 reg;
-- 
2.39.2


