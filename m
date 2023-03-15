Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1C8A6BB035
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbjCOMQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbjCOMQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:16:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FD68FBDE
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:16:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DE3461D44
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F49C433D2;
        Wed, 15 Mar 2023 12:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882566;
        bh=9jBS7MIpL6+m9brClPSSCvHFrvezPWT/iN0VihTnzSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QcF3HaD88PcoHDqKnMluRs1tLzUUmC3TNcL+vyHcNX/jawV0oqSbl+gFGQdXjgKhq
         EahQNpNMqiarWqy7/EuJCbtHarfN9XDyPne6bkNHAS/6kxtm8Qhrfgoal1iWbaYPqs
         N+9wjYv9k5tPXh0UrjGDvZR7LxU80FeYwVXLNPx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.19 27/39] Revert "spi: mt7621: Fix an error message in mt7621_spi_probe()"
Date:   Wed, 15 Mar 2023 13:12:41 +0100
Message-Id: <20230315115722.239035576@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/mt7621-spi/spi-mt7621.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/staging/mt7621-spi/spi-mt7621.c
+++ b/drivers/staging/mt7621-spi/spi-mt7621.c
@@ -442,9 +442,11 @@ static int mt7621_spi_probe(struct platf
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


