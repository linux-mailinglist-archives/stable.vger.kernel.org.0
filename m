Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4FD560A80B
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234834AbiJXNA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235258AbiJXM7q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:59:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05A48274E;
        Mon, 24 Oct 2022 05:19:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42D46612E7;
        Mon, 24 Oct 2022 12:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5347AC433C1;
        Mon, 24 Oct 2022 12:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613258;
        bh=xk1T27BF9PaH7xxK/iE4NlW4zOBlJKTpUnWvV3WYC5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QvMXN0ZiLp5lySt3PAC/4qoalIqqd2iStlx2ac/bGve5xdLgYH6VdCEMiC1GEh4n5
         xBnfhvOTqj3axIa59yEbb76LXFyalkHjZWRvp9mDVto0BpY17czZ7mxaW7zopG2T9m
         7og3V6j6iCK5s2a5vjN8K8owjuCwzJqbDKMeN9ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Qiang <xuqiang36@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/255] spi: qup: add missing clk_disable_unprepare on error in spi_qup_pm_resume_runtime()
Date:   Mon, 24 Oct 2022 13:29:39 +0200
Message-Id: <20221024113004.816616499@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
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
index 6da49705a10a..ead6c211047d 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -1199,8 +1199,10 @@ static int spi_qup_pm_resume_runtime(struct device *device)
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



