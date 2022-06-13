Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C673D548748
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354541AbiFMLdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355157AbiFMLat (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:30:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426B641335;
        Mon, 13 Jun 2022 03:46:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01ECFB80D3B;
        Mon, 13 Jun 2022 10:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9ECC34114;
        Mon, 13 Jun 2022 10:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117193;
        bh=0+3cOnk2z3C+1fmNZLPemFHmvE1ZEFxh/Sv4oC37mqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+JuXegmVMiJmUn6lXPrx8tDTD0c04sX7lnrPWqVD9q3hdZObSUAXRc8g527ZosAe
         wiVa916vAIjKrcqh5vz+vKfzNSWgHXiXNr1sTfeDalmpTtSoLQ6Peqy5mQ1qZ0VI/C
         PpnrwDJOSNcaiw2yJCrs/xb3UVo2cTWPNH2yMxeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 319/411] watchdog: ts4800_wdt: Fix refcount leak in ts4800_wdt_probe
Date:   Mon, 13 Jun 2022 12:09:52 +0200
Message-Id: <20220613094938.303388610@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 5d24df3d690809952528e7a19a43d84bc5b99d44 ]

of_parse_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.
Add  missing of_node_put() in some error paths.

Fixes: bf9006399939 ("watchdog: ts4800: add driver for TS-4800 watchdog")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20220511114203.47420-1-linmq006@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/ts4800_wdt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/ts4800_wdt.c b/drivers/watchdog/ts4800_wdt.c
index c137ad2bd5c3..0ea554c7cda5 100644
--- a/drivers/watchdog/ts4800_wdt.c
+++ b/drivers/watchdog/ts4800_wdt.c
@@ -125,13 +125,16 @@ static int ts4800_wdt_probe(struct platform_device *pdev)
 	ret = of_property_read_u32_index(np, "syscon", 1, &reg);
 	if (ret < 0) {
 		dev_err(dev, "no offset in syscon\n");
+		of_node_put(syscon_np);
 		return ret;
 	}
 
 	/* allocate memory for watchdog struct */
 	wdt = devm_kzalloc(dev, sizeof(*wdt), GFP_KERNEL);
-	if (!wdt)
+	if (!wdt) {
+		of_node_put(syscon_np);
 		return -ENOMEM;
+	}
 
 	/* set regmap and offset to know where to write */
 	wdt->feed_offset = reg;
-- 
2.35.1



