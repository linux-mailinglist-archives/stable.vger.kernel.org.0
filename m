Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2688D60A512
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbiJXMUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbiJXMTn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:19:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B058982D02;
        Mon, 24 Oct 2022 04:58:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E58E661280;
        Mon, 24 Oct 2022 11:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01680C433D6;
        Mon, 24 Oct 2022 11:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612144;
        bh=1dNVR3X2IySjniVZceBtGxiJ2W3mMOjlJ9Z7yNLlviY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LNVavv5WrR7OeYuLXPbo6uypjWfDIxZvKbTBq/6ik0/cX6Ex2Vx8ukiaaYECcKKUV
         ZUBfLTCOnd/mkirCHLEHZ+9h5ypg7hZAKb6mGIRfNaON6oE4GQ/IPtR/wTzkLUF/5w
         Hfy2PlbweD/FyzDzlrHoTyuWTit0Q1JoZhWYKFjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Qiang <xuqiang36@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 086/210] spi: qup: add missing clk_disable_unprepare on error in spi_qup_pm_resume_runtime()
Date:   Mon, 24 Oct 2022 13:30:03 +0200
Message-Id: <20221024112959.840946811@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Qiang <xuqiang36@huawei.com>

[ Upstream commit 494a22765ce479c9f8ad181c5d24cffda9f534bb ]

Add the missing clk_disable_unprepare() before return
from spi_qup_pm_resume_runtime() in the error handling case.

Fixes: dae1a7700b34 (“spi: qup: Handle clocks in pm_runtime suspend and resume”)
Signed-off-by: Xu Qiang <xuqiang36@huawei.com>
Link: https://lore.kernel.org/r/20220825065324.68446-2-xuqiang36@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
index c5c727274814..1ca678bcb527 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -1172,8 +1172,10 @@ static int spi_qup_pm_resume_runtime(struct device *device)
 		return ret;
 
 	ret = clk_prepare_enable(controller->cclk);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(controller->iclk);
 		return ret;
+	}
 
 	/* Disable clocks auto gaiting */
 	config = readl_relaxed(controller->base + QUP_CONFIG);
-- 
2.35.1



