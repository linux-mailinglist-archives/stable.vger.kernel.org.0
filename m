Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C276AB634
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 07:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjCFGFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 01:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCFGFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 01:05:47 -0500
Received: from mail.pr-group.ru (mail.pr-group.ru [178.18.215.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C554DBCF;
        Sun,  5 Mar 2023 22:05:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-transfer-encoding;
        bh=c/4vBN3nQqBWLIIsDr6bAnmepObZf4pgFEzfOBLDMG0=;
        b=kyyTIpPE3XvCJ7L1R2x3j76VwU6GDJauqTMQSnPSl+GfeghsVSF2NbQM85Y4F9aovY14NRPdmrLi4
         ky5BO6y6f85B8AHFlwJqBTrOj+FjZTfL2Ax4CLY14HWBpLIjnCdC7p44oPOjv18dw0y/NKcMehf9j/
         B+mZbg8kABSVLBTr4JSoqK6vVPK8xyzJ1/fHTC5us47RwAd3VtnYMA4vT00U/JdcH6S1NLvvvqNMg3
         MRvP4OXj5RPSiha4x//yJ5zKwm+wCZqduUAY3vfoldKEuY7s8ocQUwMBNM/6/fkWbbe7eYwuMP9pdS
         asaU/lOxtgX3ZbPWlyz3g9IDabmG5/A==
X-Kerio-Anti-Spam:  Build: [Engines: 2.17.1.1470, Stamp: 3], Multi: [Enabled, t: (0.000009,0.007108)], BW: [Enabled, t: (0.000024,0.000001)], RTDA: [Enabled, t: (0.510061), Hit: No, Details: v2.48.0; Id: 15.gc9bg.1gqqocp1s.2i7; mclb], total: 0(700)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from localhost.localdomain ([78.37.166.219])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Mon, 6 Mar 2023 09:05:26 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     linux-imx@nxp.com
Cc:     Ivan Bornyakov <i.bornyakov@metrotek.ru>, shawnguo@kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH RESEND] bus: imx-weim: fix branch condition evaluates to a garbage value
Date:   Mon,  6 Mar 2023 09:05:05 +0300
Message-Id: <20230306060505.11657-1-i.bornyakov@metrotek.ru>
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


