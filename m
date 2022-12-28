Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43BFB657ED2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbiL1P57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbiL1P56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:57:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A0A1839E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:57:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F2AEB8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5534C433D2;
        Wed, 28 Dec 2022 15:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243075;
        bh=jA5Lh04MvNxyrxnmTEl1cwIoiZqzyvMPI9M/23RBUKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r0E0WpKyRr4zYMqKmN3wVs+6XYGdgqY+2K3RFUdnCkh5BJ2/EJWcpXTWRt0/i9Fh9
         BCNBbnyJgYoT982Jg2Ixk7l1nTvCcJ6JONAwmTVi8f/d6kSoYrIVKw1jFQjuaY9GTC
         TLmb47gJghs3kQRsN9Vt2a3jHyVoQc5ggW4DgIAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gabriel Somlo <gsomlo@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0487/1073] mmc: litex_mmc: ensure `host->irq == 0` if polling
Date:   Wed, 28 Dec 2022 15:34:35 +0100
Message-Id: <20221228144341.264206021@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel Somlo <gsomlo@gmail.com>

[ Upstream commit 5c1a2b77cd1b59112cf22b3e338f7e416797ad32 ]

Ensure the flag is explicitly set to 0 if we determine that polling is
needed during driver probe, to cover all possible cases.

Fixes: 92e099104729 ("mmc: Add driver for LiteX's LiteSDCard interface")
Signed-off-by: Gabriel Somlo <gsomlo@gmail.com>
Link: https://lore.kernel.org/r/20221107155516.2535912-1-gsomlo@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/litex_mmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/litex_mmc.c b/drivers/mmc/host/litex_mmc.c
index 6ba0d63b8c07..39c6707fdfdb 100644
--- a/drivers/mmc/host/litex_mmc.c
+++ b/drivers/mmc/host/litex_mmc.c
@@ -502,6 +502,7 @@ static int litex_mmc_irq_init(struct platform_device *pdev,
 
 use_polling:
 	host->mmc->caps |= MMC_CAP_NEEDS_POLL;
+	host->irq = 0;
 	return 0;
 }
 
-- 
2.35.1



