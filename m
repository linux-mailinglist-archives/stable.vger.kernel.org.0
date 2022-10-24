Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94BCF60B1DF
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbiJXQje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbiJXQjF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:39:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFE7101E8;
        Mon, 24 Oct 2022 08:26:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B92FBB81988;
        Mon, 24 Oct 2022 12:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1580AC433C1;
        Mon, 24 Oct 2022 12:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615298;
        bh=3p0ypaTB4ah/NxQ3Z63w0/JXH4OE6rh9UQQyxKabtwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQe4sl8SbpQuHHU9H6CpyE42o5WONCxTGtAi2wZ1xOZYdo3Gwng/BibZKj6gNGg3M
         nDO6UNlASX0EB5VeptTrsw30ImyUL7qADDms0w8EQDYfj1WHa7V7Mmsrmp3wuG1G7V
         2jCG/f8Dd0WvSI2im5GDE3HybJN60Y28AczmKU2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Qiang <xuqiang36@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 167/530] spi: qup: add missing clk_disable_unprepare on error in spi_qup_resume()
Date:   Mon, 24 Oct 2022 13:28:31 +0200
Message-Id: <20221024113052.618886582@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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

[ Upstream commit 70034320fdc597b8f58b4a43bb547f17c4c5557a ]

Add the missing clk_disable_unprepare() before return
from spi_qup_resume() in the error handling case.

Fixes: 64ff247a978f (“spi: Add Qualcomm QUP SPI controller support”)
Signed-off-by: Xu Qiang <xuqiang36@huawei.com>
Link: https://lore.kernel.org/r/20220825065324.68446-1-xuqiang36@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qup.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
index d39dec6d1c91..668d79922fac 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -1246,14 +1246,25 @@ static int spi_qup_resume(struct device *device)
 		return ret;
 
 	ret = clk_prepare_enable(controller->cclk);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(controller->iclk);
 		return ret;
+	}
 
 	ret = spi_qup_set_state(controller, QUP_STATE_RESET);
 	if (ret)
-		return ret;
+		goto disable_clk;
+
+	ret = spi_master_resume(master);
+	if (ret)
+		goto disable_clk;
 
-	return spi_master_resume(master);
+	return 0;
+
+disable_clk:
+	clk_disable_unprepare(controller->cclk);
+	clk_disable_unprepare(controller->iclk);
+	return ret;
 }
 #endif /* CONFIG_PM_SLEEP */
 
-- 
2.35.1



