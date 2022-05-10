Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27F7521920
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243816AbiEJNmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244687AbiEJNmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:42:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6926663E3;
        Tue, 10 May 2022 06:30:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56ED861763;
        Tue, 10 May 2022 13:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D193C385A6;
        Tue, 10 May 2022 13:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189423;
        bh=Y5enQchBqWtPw3dWMTz3w6z5H0ksi/HU71mEpy8zCqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oj8NDw556+FfubpMIcTwT6U0t7dE4Ub+3LORegS/xVpMueWTUg07t53D4np+HeFea
         g17cp5j9cJSM4l0bWOsUtHjHzZ4rGk7GCrZUDEDMxvpQzb7FL8sQDKHJicVQj0TGqV
         2uEoSSmOoXbz/SUtp86z2eibCNTHqbB4zOIrLE2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Sven Peter <sven@svenpeter.dev>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.15 047/135] iommu/dart: check return value after calling platform_get_resource()
Date:   Tue, 10 May 2022 15:07:09 +0200
Message-Id: <20220510130741.748749921@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit a15932f4377062364d22096afe25bc579134a1c3 upstream.

It will cause null-ptr-deref in resource_size(), if platform_get_resource()
returns NULL, move calling resource_size() after devm_ioremap_resource() that
will check 'res' to avoid null-ptr-deref.
And use devm_platform_get_and_ioremap_resource() to simplify code.

Fixes: 46d1fb072e76 ("iommu/dart: Add DART iommu driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Sven Peter <sven@svenpeter.dev>
Link: https://lore.kernel.org/r/20220425090826.2532165-1-yangyingliang@huawei.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/apple-dart.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/iommu/apple-dart.c
+++ b/drivers/iommu/apple-dart.c
@@ -832,16 +832,15 @@ static int apple_dart_probe(struct platf
 	dart->dev = dev;
 	spin_lock_init(&dart->lock);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	dart->regs = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
+	if (IS_ERR(dart->regs))
+		return PTR_ERR(dart->regs);
+
 	if (resource_size(res) < 0x4000) {
 		dev_err(dev, "MMIO region too small (%pr)\n", res);
 		return -EINVAL;
 	}
 
-	dart->regs = devm_ioremap_resource(dev, res);
-	if (IS_ERR(dart->regs))
-		return PTR_ERR(dart->regs);
-
 	dart->irq = platform_get_irq(pdev, 0);
 	if (dart->irq < 0)
 		return -ENODEV;


