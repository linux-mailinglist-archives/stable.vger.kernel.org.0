Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05B158C0DB
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243480AbiHHBzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243408AbiHHBxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:53:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700551AF06;
        Sun,  7 Aug 2022 18:38:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81B0760DF3;
        Mon,  8 Aug 2022 01:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89E0C43140;
        Mon,  8 Aug 2022 01:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922736;
        bh=Dmx4oOnZlzw9wzNSiNks7f7+LAxIbZSjqe1MP8P4Bjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZEaoTyaOx02LB8FdNZggkh2oo/T1MiVMm8fzwgNktU7aez7uw6v1sydJr4wxUz3r
         Yk80ZUdt0fxd5vz/+hf5UNkS/z+Cnd8Ias6VOQiBTyMjTacFUSyeGhu8OAEv5KoHOA
         vlLsr8igsDl4xWJHrr1w3iyZ8z1llHKe1GP10rGOyJHqcLSChsaAn0ty6ksnNM2jyh
         ob//EoX0DpyBXHKlhjyQr8+3m4MiMhvPBRz0qIRCSJ7RDVfPy6TqCi8s3zYfLzltr5
         XbmJQzEjYmJd7D0ltY4QFOMhBPXjdZZbY6ImDgme7q5BO1o5uKnO+UbxwOmhjl/0ZI
         vDjjEji5c+SVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guo Mengqi <guomengqi3@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, masahisa.kojima@linaro.org,
        jaswinder.singh@linaro.org, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/23] spi: synquacer: Add missing clk_disable_unprepare()
Date:   Sun,  7 Aug 2022 21:38:20 -0400
Message-Id: <20220808013832.316381-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013832.316381-1-sashal@kernel.org>
References: <20220808013832.316381-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

