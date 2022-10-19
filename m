Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42AB160485B
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbiJSN4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233703AbiJSNxQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:53:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4771C8816;
        Wed, 19 Oct 2022 06:36:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A86FB8238B;
        Wed, 19 Oct 2022 08:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1EE7C433D6;
        Wed, 19 Oct 2022 08:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169432;
        bh=Rz9rDCBJAQ2vRjx+afllaCE7dQcrdHH6ja7SalU0vXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWvluceJ4+KdQ8KQbcJMblJB18QlYqKR9G3Ejz/gPAoU6tI2b5Fl8VPK4FTcu7ZwN
         PIFjC/BOvgm7pJKf5JYQrBjuJxIFK9xb8SplI/BIOjthOWsWl2vLemDrvLCwoXd07t
         zn5PmcT/IrLdsl/y9qQJ14iPjvW4zYyCGxdWZz+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Qiang <xuqiang36@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 267/862] spi: qup: add missing clk_disable_unprepare on error in spi_qup_resume()
Date:   Wed, 19 Oct 2022 10:25:54 +0200
Message-Id: <20221019083301.819748343@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 00d6084306b4..ae4e67f152ec 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -1245,14 +1245,25 @@ static int spi_qup_resume(struct device *device)
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



