Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02C75935AF
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241348AbiHOS2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241375AbiHOS1S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:27:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8584832046;
        Mon, 15 Aug 2022 11:20:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60A58B81076;
        Mon, 15 Aug 2022 18:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE90EC433D6;
        Mon, 15 Aug 2022 18:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587593;
        bh=Shks8rDUt6fwvZCiVNN+z/KX40yACmnhgAaxaywLQ9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBswlEHJsq0eFf67LZO0LC2+9OK0a25/G+9Rtxv8QjyI0YCnkuIE8khGhnCrFh5iS
         sKcBQbVjvs0pTXTwgPfKkK3l9zmuzhBm9v2HCJCDOSAfuurYcQTVcmQrrsS0N8MTFJ
         xWRnGqkH2V5Tuo1U80Ora+YUuZhTUqOUEcFi44Qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Guo Mengqi <guomengqi3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/779] spi: synquacer: Add missing clk_disable_unprepare()
Date:   Mon, 15 Aug 2022 19:56:17 +0200
Message-Id: <20220815180342.963400297@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index ea706d9629cb..47cbe73137c2 100644
--- a/drivers/spi/spi-synquacer.c
+++ b/drivers/spi/spi-synquacer.c
@@ -783,6 +783,7 @@ static int __maybe_unused synquacer_spi_resume(struct device *dev)
 
 		ret = synquacer_spi_enable(master);
 		if (ret) {
+			clk_disable_unprepare(sspi->clk);
 			dev_err(dev, "failed to enable spi (%d)\n", ret);
 			return ret;
 		}
-- 
2.35.1



