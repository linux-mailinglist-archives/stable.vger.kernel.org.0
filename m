Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A30D6AC0CB
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 14:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjCFN01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 08:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCFN00 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 08:26:26 -0500
Received: from mail.pr-group.ru (mail.pr-group.ru [178.18.215.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FCF2A6C4;
        Mon,  6 Mar 2023 05:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-transfer-encoding:
         in-reply-to:references;
        bh=82L4rewpG2uOVMVD/V2rJNYXu1V6/Kk/AXQ5nwFZis4=;
        b=Qf1gsh12D3AUCtrRvSFF4wwXtvJahU5rtctPk5vU8J3rZsyrsUekZa7tu+ZswfsHBd3OOiEhtrZrA
         i0gn8MAPu85QlTZiV+Q/svH5qclVzxru2FERgHcDdSdDKZTNkUW6yGjbSI+0p/1LOxLNEAxg4hbFMD
         OQ9gohfpEol9jQNR8R9nWxpAKnSAiIrtJml41RqUyUU95ZLUkCX5GRCghl3ffokBhhOiopxR0MVGoY
         fDjjRDDxrOWppNtKD10qAj648ypnD7P4L72MrtX+63+VEmcACsjU9SleAiHJBy/SPUmv5+zIfs+w/B
         G58t6JL74xi2akSUgNyeLGkO2IIauRA==
X-Kerio-Anti-Spam:  Build: [Engines: 2.17.1.1470, Stamp: 3], Multi: [Enabled, t: (0.000009,0.008115)], BW: [Enabled, t: (0.000025,0.000001)], RTDA: [Enabled, t: (0.091709), Hit: No, Details: v2.48.0; Id: 15.jzm45.1gqrhjk9o.h54; mclb], total: 0(700)
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLACK autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from localhost.localdomain ([78.37.166.219])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Mon, 6 Mar 2023 16:26:05 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     linux-imx@nxp.com
Cc:     Ivan Bornyakov <i.bornyakov@metrotek.ru>, shawnguo@kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] bus: imx-weim: fix branch condition evaluates to a garbage value
Date:   Mon,  6 Mar 2023 16:25:26 +0300
Message-Id: <20230306132526.8763-1-i.bornyakov@metrotek.ru>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230306060505.11657-1-i.bornyakov@metrotek.ru>
References: 
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

Fixes: 52c47b63412b ("bus: imx-weim: improve error handling upon child probe-failure")
Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc: stable@vger.kernel.org
Reviewed-by: Fabio Estevam <festevam@gmail.com>
---
 drivers/bus/imx-weim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

ChangeLog:
  v1:
[https://lore.kernel.org/all/20230306060505.11657-1-i.bornyakov@metrotek.ru/]
  v2:
    * add "Fixes" tag
    * add Fabio's "Reviewed-by" tag

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


