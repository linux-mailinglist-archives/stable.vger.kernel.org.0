Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FBA59E103
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357292AbiHWLRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357603AbiHWLQL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:16:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60010BD102;
        Tue, 23 Aug 2022 02:20:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A96DDB81C65;
        Tue, 23 Aug 2022 09:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06CA9C433D6;
        Tue, 23 Aug 2022 09:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246347;
        bh=Dmx4oOnZlzw9wzNSiNks7f7+LAxIbZSjqe1MP8P4Bjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UPeoOCwfbykJFxR0EIUt1XkMO3TFICLZ2iO7wLXwsqewUQiPk/y+QXXEVLOtxFnbL
         xfDVsKOqNA8Gqgnbs75/13mRuopWaMya758FYja+lh68h4yaE+whuC3YRxYs2I+C/E
         1u6P8tObZkd0yV2ilTFZcliItECFEk2DqqnMSRHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Guo Mengqi <guomengqi3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 063/389] spi: synquacer: Add missing clk_disable_unprepare()
Date:   Tue, 23 Aug 2022 10:22:21 +0200
Message-Id: <20220823080118.241880247@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Mengqi <guomengqi3@huawei.com>

[ Upstream commit 917e43de2a56d9b82576f1cc94748261f1988458 ]

Add missing clk_disable_unprepare() in synquacer_spi_resume().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Guo Mengqi <guomengqi3@huawei.com>
Link: https://lore.kernel.org/r/20220624005614.49434-1-guomengqi3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-synquacer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-synquacer.c b/drivers/spi/spi-synquacer.c
index 785e7c445123..1e10af6e10a9 100644
--- a/drivers/spi/spi-synquacer.c
+++ b/drivers/spi/spi-synquacer.c
@@ -784,6 +784,7 @@ static int __maybe_unused synquacer_spi_resume(struct device *dev)
 
 		ret = synquacer_spi_enable(master);
 		if (ret) {
+			clk_disable_unprepare(sspi->clk);
 			dev_err(dev, "failed to enable spi (%d)\n", ret);
 			return ret;
 		}
-- 
2.35.1



