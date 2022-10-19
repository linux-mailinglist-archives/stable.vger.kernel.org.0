Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76356603D2C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbiJSI6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbiJSI5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:57:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC92A15FC3;
        Wed, 19 Oct 2022 01:53:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 750CB6181D;
        Wed, 19 Oct 2022 08:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B50C433D6;
        Wed, 19 Oct 2022 08:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169540;
        bh=qfRkPOfBXEFDRbBTB/Q/Jpv5q9piXIqG1CnSctn/W4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vmCu7S4geP7VtF91JBYzMEkikmhCXk1uW4RJa0lP+gbPdstsaJaHF9luWTMRYzArf
         6X5S7fEXSGR6exgLgTcHfLexNqYfy2w3xqfq+Szob122GL/pUBw+PdVMdPmrjbWI+c
         3mq76vMVEqs5iEjENXKq+kP8Ia0B3SllgEvSVSn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 316/862] spi/omap100k:Fix PM disable depth imbalance in omap1_spi100k_probe
Date:   Wed, 19 Oct 2022 10:26:43 +0200
Message-Id: <20221019083303.993259120@linuxfoundation.org>
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

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 29f65f2171c85a9633daa380df14009a365f42f2 ]

The pm_runtime_enable will increase power disable depth. Thus
a pairing decrement is needed on the error handling path to
keep it balanced according to context.

Fixes:db91841b58f9a ("spi/omap100k: Convert to runtime PM")

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20220924121310.78331-4-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap-100k.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
index 20b047172965..061f7394e5b9 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -412,6 +412,7 @@ static int omap1_spi100k_probe(struct platform_device *pdev)
 	return status;
 
 err_fck:
+	pm_runtime_disable(&pdev->dev);
 	clk_disable_unprepare(spi100k->fck);
 err_ick:
 	clk_disable_unprepare(spi100k->ick);
-- 
2.35.1



