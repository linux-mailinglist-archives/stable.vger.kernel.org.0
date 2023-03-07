Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0236AF02B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbjCGS3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbjCGS2e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:28:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6EC9EF75
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:21:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAE1AB819D1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA54C433D2;
        Tue,  7 Mar 2023 18:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213285;
        bh=IgAoI9427T+gYYcZbwy8LGbidteJ248lklD8EmzOeLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+J8WFRjjyvFrU+P6dqEBHeTyRXXmB8SVwJ/xy7kf3WTDQcOKCWwdbP0tnrrC1/rl
         MBWEBKIZlhHEkZD9G/k0G0cM7OCZi8aWkb1F3J8/RMkv3nxwsgYsuDg31+pHABE+EA
         R+iwF6APedXoNWi/43rnfdn8t6i2calEur0Rln00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sven Peter <sven@svenpeter.dev>,
        Hector Martin <marcan@marcan.st>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 458/885] iommu: dart: Add suspend/resume support
Date:   Tue,  7 Mar 2023 17:56:32 +0100
Message-Id: <20230307170022.398259145@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 3d68bbb81b1a64e279180eee1ed0e2c590b5029e ]

We need to save/restore the TCR/TTBR registers, since they are lost
on power gate.

Reviewed-by: Sven Peter <sven@svenpeter.dev>
Signed-off-by: Hector Martin <marcan@marcan.st>
Link: https://lore.kernel.org/r/20230113105029.26654-3-marcan@marcan.st
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: cf5c1c87c239 ("iommu/dart: Fix apple_dart_device_group for PCI groups")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/apple-dart.c | 43 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/iommu/apple-dart.c b/drivers/iommu/apple-dart.c
index 4f4a323be0d0f..2458416122f8d 100644
--- a/drivers/iommu/apple-dart.c
+++ b/drivers/iommu/apple-dart.c
@@ -121,6 +121,9 @@ struct apple_dart {
 
 	struct iommu_group *sid2group[DART_MAX_STREAMS];
 	struct iommu_device iommu;
+
+	u32 save_tcr[DART_MAX_STREAMS];
+	u32 save_ttbr[DART_MAX_STREAMS][DART_MAX_TTBR];
 };
 
 /*
@@ -932,6 +935,45 @@ static const struct apple_dart_hw apple_dart_hw_t6000 = {
 	.fmt = APPLE_DART2,
 };
 
+static __maybe_unused int apple_dart_suspend(struct device *dev)
+{
+	struct apple_dart *dart = dev_get_drvdata(dev);
+	unsigned int sid, idx;
+
+	for (sid = 0; sid < DART_MAX_STREAMS; sid++) {
+		dart->save_tcr[sid] = readl_relaxed(dart->regs + DART_TCR(sid));
+		for (idx = 0; idx < DART_MAX_TTBR; idx++)
+			dart->save_ttbr[sid][idx] =
+				readl(dart->regs + DART_TTBR(sid, idx));
+	}
+
+	return 0;
+}
+
+static __maybe_unused int apple_dart_resume(struct device *dev)
+{
+	struct apple_dart *dart = dev_get_drvdata(dev);
+	unsigned int sid, idx;
+	int ret;
+
+	ret = apple_dart_hw_reset(dart);
+	if (ret) {
+		dev_err(dev, "Failed to reset DART on resume\n");
+		return ret;
+	}
+
+	for (sid = 0; sid < DART_MAX_STREAMS; sid++) {
+		for (idx = 0; idx < DART_MAX_TTBR; idx++)
+			writel(dart->save_ttbr[sid][idx],
+			       dart->regs + DART_TTBR(sid, idx));
+		writel(dart->save_tcr[sid], dart->regs + DART_TCR(sid));
+	}
+
+	return 0;
+}
+
+DEFINE_SIMPLE_DEV_PM_OPS(apple_dart_pm_ops, apple_dart_suspend, apple_dart_resume);
+
 static const struct of_device_id apple_dart_of_match[] = {
 	{ .compatible = "apple,t8103-dart", .data = &apple_dart_hw_t8103 },
 	{ .compatible = "apple,t6000-dart", .data = &apple_dart_hw_t6000 },
@@ -944,6 +986,7 @@ static struct platform_driver apple_dart_driver = {
 		.name			= "apple-dart",
 		.of_match_table		= apple_dart_of_match,
 		.suppress_bind_attrs    = true,
+		.pm			= pm_sleep_ptr(&apple_dart_pm_ops),
 	},
 	.probe	= apple_dart_probe,
 	.remove	= apple_dart_remove,
-- 
2.39.2



