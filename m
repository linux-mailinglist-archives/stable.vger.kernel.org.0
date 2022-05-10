Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9658521A42
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244521AbiEJNyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243912AbiEJNwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:52:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28C36B7F6;
        Tue, 10 May 2022 06:38:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5023BB81DA2;
        Tue, 10 May 2022 13:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8867BC385C2;
        Tue, 10 May 2022 13:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189893;
        bh=fD6Jlo6f0v17/XDRJr9vpfwAbCvFuWwFNPMB2SyCkc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LEssuADzVa9gbaK3dJoQApjUKEIPqRjVuT17l5lvkm7HRtenKec2VWdzCe5T6yS3Q
         RD7A+uBFuXrjeGYYFAscqtSwxQrjA0Na7yP7BVVvYtwLBVLuf6e9+RhQ9ivc6s+pd8
         u1J6kA4azTLNiJZe6M2xGB8cEXptVolLHYOCZiZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Sven Peter <sven@svenpeter.dev>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.17 062/140] iommu/dart: check return value after calling platform_get_resource()
Date:   Tue, 10 May 2022 15:07:32 +0200
Message-Id: <20220510130743.391631635@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
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
@@ -857,16 +857,15 @@ static int apple_dart_probe(struct platf
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


