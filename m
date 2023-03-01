Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32CD6A761F
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 22:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjCAVY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 16:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCAVY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 16:24:56 -0500
Received: from mo-csw.securemx.jp (mo-csw1116-1.securemx.jp [210.130.202.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D322647408
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 13:24:54 -0800 (PST)
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 321LOcA5006431; Thu, 2 Mar 2023 06:24:38 +0900
X-Iguazu-Qid: 2wHHvlq2zywcQs1VrM
X-Iguazu-QSIG: v=2; s=0; t=1677705878; q=2wHHvlq2zywcQs1VrM; m=rDtM7410V7baTtf0AP9H0giEqLbsRBB555/T/lKqw8w=
Received: from imx12-a.toshiba.co.jp ([38.106.60.135])
        by relay.securemx.jp (mx-mr1110) id 321LObPq026785
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 2 Mar 2023 06:24:37 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.19] Revert "spi: mt7621: Fix an error message in mt7621_spi_probe()"
Date:   Thu,  2 Mar 2023 06:23:50 +0900
X-TSB-HOP2: ON
Message-Id: <20230301212350.4182867-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,HEXHASH_WORD,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 269f650a0b26067092873308117e0bf0c6ec8289 which is
commit 2b2bf6b7faa9010fae10dc7de76627a3fdb525b3 upstream.

dev_err_probe() does not suppot in 4.19.y. So this driver will fail to
build.

```
  CC      drivers/staging/mt7621-spi/spi-mt7621.o
drivers/staging/mt7621-spi/spi-mt7621.c: In function 'mt7621_spi_probe':
drivers/staging/mt7621-spi/spi-mt7621.c:446:24: error: implicit declaration of function 'dev_err_probe'; did you mean 'device_reprobe'? [-Werror=implicit-function-declaration]
  446 |                 return dev_err_probe(&pdev->dev, PTR_ERR(clk),
      |                        ^~~~~~~~~~~~~
      |                        device_reprobe
```

Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/staging/mt7621-spi/spi-mt7621.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/mt7621-spi/spi-mt7621.c b/drivers/staging/mt7621-spi/spi-mt7621.c
index b73823830e3a73..75ed48f60c8c7f 100644
--- a/drivers/staging/mt7621-spi/spi-mt7621.c
+++ b/drivers/staging/mt7621-spi/spi-mt7621.c
@@ -442,9 +442,11 @@ static int mt7621_spi_probe(struct platform_device *pdev)
 		return PTR_ERR(base);
 
 	clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(clk))
-		return dev_err_probe(&pdev->dev, PTR_ERR(clk),
-				     "unable to get SYS clock\n");
+	if (IS_ERR(clk)) {
+		dev_err(&pdev->dev, "unable to get SYS clock, err=%d\n",
+			status);
+		return PTR_ERR(clk);
+	}
 
 	status = clk_prepare_enable(clk);
 	if (status)
-- 
2.36.1


