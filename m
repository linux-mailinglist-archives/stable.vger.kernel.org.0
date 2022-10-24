Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D09060A2C4
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbiJXLrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiJXLqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:46:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CBF75FED;
        Mon, 24 Oct 2022 04:42:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7DE8612B1;
        Mon, 24 Oct 2022 11:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB10EC433D7;
        Mon, 24 Oct 2022 11:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611676;
        bh=BGNZK/cB2kFggn5itPQ393cYoDcWc44Ku6wOYLbv6xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ep3w1nA6KEnmDNPtj1ehOionWcNcVzqUVn0aS6ZR040Uizz2hmpXQKbo3CqdeGD1X
         Lx+HcMq1/Yrhzu1EO/s87ttbAH6ZgUaf3vzS5YUxrThrCVGrZjuUBibfi7mO9a+52z
         5im7mZrPBjFDj7oes6/uJ92Mnz9qwF7GNdtgLwRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Qiang <xuqiang36@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 068/159] spi: qup: add missing clk_disable_unprepare on error in spi_qup_resume()
Date:   Mon, 24 Oct 2022 13:30:22 +0200
Message-Id: <20221024112951.953277693@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
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
index 88b108e1c85f..431cb184595f 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -1003,14 +1003,25 @@ static int spi_qup_resume(struct device *device)
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



