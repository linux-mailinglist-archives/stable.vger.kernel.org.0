Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA4B50F62C
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239196AbiDZIls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345843AbiDZIji (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:39:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C792E793B8;
        Tue, 26 Apr 2022 01:32:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08485617D2;
        Tue, 26 Apr 2022 08:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C87C385AC;
        Tue, 26 Apr 2022 08:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961926;
        bh=aN26knkQ3uIvvm0WQL2I229Lj/DG+/cm/IpczxzF+LU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6/rD1ZgKo2ggXD0UIOJzU5bwnuZ3cLpgzFhh6WBH1k1qAXfT27CrH8jZmcM5+C3C
         oSacURcDxTOO7bAwpxK7qPqRzoAk8O7kH/EVyc4kBeZl6IjK8FLeynw2Oj7OE0BPfP
         ltaFANwArIn3wRHjIhxqzQDvCHzPWSazu1puo1R0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Allen-KH Cheng <allen-kh.cheng@mediatek.com>,
        Rex-BC Chen <rex-bc.chen@mediatek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 15/86] spi: spi-mtk-nor: initialize spi controller after resume
Date:   Tue, 26 Apr 2022 10:20:43 +0200
Message-Id: <20220426081741.645860860@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allen-KH Cheng <allen-kh.cheng@mediatek.com>

[ Upstream commit 317c2045618cc1f8d38beb8c93a7bdb6ad8638c6 ]

After system resumes, the registers of nor controller are
initialized with default values. The nor controller will
not function properly.

To handle both issues above, we add mtk_nor_init() in
mtk_nor_resume after pm_runtime_force_resume().

Fixes: 3bfd9103c7af ("spi: spi-mtk-nor: Add power management support")

Signed-off-by: Allen-KH Cheng <allen-kh.cheng@mediatek.com>
Reviewed-by: Rex-BC Chen <rex-bc.chen@mediatek.com>
Link: https://lore.kernel.org/r/20220412115743.22641-1-allen-kh.cheng@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mtk-nor.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-mtk-nor.c b/drivers/spi/spi-mtk-nor.c
index 288f6c2bbd57..106e3cacba4c 100644
--- a/drivers/spi/spi-mtk-nor.c
+++ b/drivers/spi/spi-mtk-nor.c
@@ -895,7 +895,17 @@ static int __maybe_unused mtk_nor_suspend(struct device *dev)
 
 static int __maybe_unused mtk_nor_resume(struct device *dev)
 {
-	return pm_runtime_force_resume(dev);
+	struct spi_controller *ctlr = dev_get_drvdata(dev);
+	struct mtk_nor *sp = spi_controller_get_devdata(ctlr);
+	int ret;
+
+	ret = pm_runtime_force_resume(dev);
+	if (ret)
+		return ret;
+
+	mtk_nor_init(sp);
+
+	return 0;
 }
 
 static const struct dev_pm_ops mtk_nor_pm_ops = {
-- 
2.35.1



