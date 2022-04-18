Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E70E5052E3
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239721AbiDRMwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239700AbiDRMuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:50:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105852182B;
        Mon, 18 Apr 2022 05:34:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83F876118A;
        Mon, 18 Apr 2022 12:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796D2C385A9;
        Mon, 18 Apr 2022 12:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285256;
        bh=piDCdJIsOanLRbuPzjT1fciiBHfwiEVjteIk2mJjuNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsyOyr6nTi3POrtNbStL8Uh39LVQFIjHU7q8SQfdwwosS3d7T68Y3MtjY4CtneMiK
         TH3Gy9bg2oPkO0q/NYdHnez+jFxzQNw1n3lFOld8BVSvQIOHaatp8wQe5b9aXyLYKS
         xPzPe/sErAoEIM2Cz+bqB11tDX2Vrz8fYybg01Fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Johan Hovold <johan@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5.15 151/189] memory: renesas-rpc-if: fix platform-device leak in error path
Date:   Mon, 18 Apr 2022 14:12:51 +0200
Message-Id: <20220418121206.196511725@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit b452dbf24d7d9a990d70118462925f6ee287d135 upstream.

Make sure to free the flash platform device in the event that
registration fails during probe.

Fixes: ca7d8b980b67 ("memory: add Renesas RPC-IF driver")
Cc: stable@vger.kernel.org      # 5.8
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20220303180632.3194-1-johan@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memory/renesas-rpc-if.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -579,6 +579,7 @@ static int rpcif_probe(struct platform_d
 	struct platform_device *vdev;
 	struct device_node *flash;
 	const char *name;
+	int ret;
 
 	flash = of_get_next_child(pdev->dev.of_node, NULL);
 	if (!flash) {
@@ -602,7 +603,14 @@ static int rpcif_probe(struct platform_d
 		return -ENOMEM;
 	vdev->dev.parent = &pdev->dev;
 	platform_set_drvdata(pdev, vdev);
-	return platform_device_add(vdev);
+
+	ret = platform_device_add(vdev);
+	if (ret) {
+		platform_device_put(vdev);
+		return ret;
+	}
+
+	return 0;
 }
 
 static int rpcif_remove(struct platform_device *pdev)


