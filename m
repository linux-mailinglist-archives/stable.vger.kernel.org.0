Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2740C608AAE
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 11:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbiJVJE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 05:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235091AbiJVJDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 05:03:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70DA2FA5CC;
        Sat, 22 Oct 2022 01:18:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FF7760B89;
        Sat, 22 Oct 2022 07:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F31C4314C;
        Sat, 22 Oct 2022 07:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425320;
        bh=d4xHh/EUCkCOVmUiHgDNQoi2lFnlAt1QKWLdSYAR6Ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hOjJVgEfrCMMqjzeoHIvcXTA1aW8xUgqnn7Cl50jmtEc3/tmWpaeAel2BxrRMCIdU
         b7zRulekcm5mHEwdbTNNjEzPnqObb6WqwsxxDeqsLx9vN0PzkrhzXaBXhcLtCFzZe3
         ozJYmWTj6smB3oil7MqQ/y8StrSmxRO8KYnOnqyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hacash Robot <hacashRobot@santino.com>,
        William Dean <williamsukatube@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 422/717] mtd: devices: docg3: check the return value of devm_ioremap() in the probe
Date:   Sat, 22 Oct 2022 09:25:01 +0200
Message-Id: <20221022072517.050464932@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Dean <williamsukatube@gmail.com>

[ Upstream commit 26e784433e6c65735cd6d93a8db52531970d9a60 ]

The function devm_ioremap() in docg3_probe() can fail, so
its return value should be checked.

Fixes: 82402aeb8c81e ("mtd: docg3: Use devm_*() functions")
Reported-by: Hacash Robot <hacashRobot@santino.com>
Signed-off-by: William Dean <williamsukatube@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220722091644.2937953-1-williamsukatube@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/devices/docg3.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index 5b0ae5ddad74..27c08f22dec8 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -1974,9 +1974,14 @@ static int __init docg3_probe(struct platform_device *pdev)
 		dev_err(dev, "No I/O memory resource defined\n");
 		return ret;
 	}
-	base = devm_ioremap(dev, ress->start, DOC_IOSPACE_SIZE);
 
 	ret = -ENOMEM;
+	base = devm_ioremap(dev, ress->start, DOC_IOSPACE_SIZE);
+	if (!base) {
+		dev_err(dev, "devm_ioremap dev failed\n");
+		return ret;
+	}
+
 	cascade = devm_kcalloc(dev, DOC_MAX_NBFLOORS, sizeof(*cascade),
 			       GFP_KERNEL);
 	if (!cascade)
-- 
2.35.1



