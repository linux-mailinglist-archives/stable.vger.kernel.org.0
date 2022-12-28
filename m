Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE5E657871
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbiL1OvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbiL1Oub (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:50:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B211311C28
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:50:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0ADE0CE1337
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03032C433D2;
        Wed, 28 Dec 2022 14:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239027;
        bh=WKv8zFcSKSXuZRIJ8FZVNeNpus1f0H31HopYeYN6o8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ny6Wy2wiJeseNtuPf4nwSlS9p/N8EeFjiUjz5kfVH8U6ix8VnSbR3cHOaO5FLYLcG
         alCwPOsrNNc50UaMkZ53PKlxgrsmbBfOutLL0NbR1/cOYWICK4BLUz8T5cK3jljgSN
         BjkdFtIVJRaODdrV9OiAUUbhHx196ijFoRd2NKEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Yongjun <weiyongjun1@huawei.com>,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/731] irqchip/wpcm450: Fix memory leak in wpcm450_aic_of_init()
Date:   Wed, 28 Dec 2022 15:33:27 +0100
Message-Id: <20221228144259.450635751@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 4208d4faf36573a507b5e5de17abe342e9276759 ]

If of_iomap() failed, 'aic' should be freed before return. Otherwise
there is a memory leak.

Fixes: fead4dd49663 ("irqchip: Add driver for WPCM450 interrupt controller")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221115092532.1704032-1-weiyongjun@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-wpcm450-aic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-wpcm450-aic.c b/drivers/irqchip/irq-wpcm450-aic.c
index f3ac392d5bc8..36d0d0cf3fa2 100644
--- a/drivers/irqchip/irq-wpcm450-aic.c
+++ b/drivers/irqchip/irq-wpcm450-aic.c
@@ -146,6 +146,7 @@ static int __init wpcm450_aic_of_init(struct device_node *node,
 	aic->regs = of_iomap(node, 0);
 	if (!aic->regs) {
 		pr_err("Failed to map WPCM450 AIC registers\n");
+		kfree(aic);
 		return -ENOMEM;
 	}
 
-- 
2.35.1



