Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9C1657A68
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbiL1PLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbiL1PKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:10:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F0412D25
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:10:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D50D8B8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D419C433EF;
        Wed, 28 Dec 2022 15:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240245;
        bh=Ce5wsrwXVklwECNR+An862ZImLkfgMufqhCRFkyt+Go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nf/OYQasjECnTCvbCNja9FUgmDMPAUHAhLOJrc5dieWqw4LkJb7rdptKmrFwHM37h
         fZNugyBNYbwiGC/pAiS25hhBSqNUW3JQCgXxSD5VDtYA/9fXkfY9LeMZ5iLofTDoGc
         JDZMsZNzr/xMx8c0/XCxEtd5zA8RvRCsP/ETlw94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liu Peibao <liupeibao@loongson.cn>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0138/1073] irqchip/loongson-liointc: Fix improper error handling in liointc_init()
Date:   Wed, 28 Dec 2022 15:28:46 +0100
Message-Id: <20221228144331.779202147@linuxfoundation.org>
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

From: Liu Peibao <liupeibao@loongson.cn>

[ Upstream commit 4a60a3cdcf1875c965095eb9e22c3d12bbc5a53d ]

For cores less than 4, eg, loongson2k1000 with 2 cores, the
of_property_match_string() may return with an error value,
which causes that liointc could not work. At least isr0 is
what should be checked like previous commit b2c4c3969fd7
("irqchip/loongson-liointc: irqchip add 2.0 version") did.

Fixes: 0858ed035a85 ("irqchip/loongson-liointc: Add ACPI init support")
Signed-off-by: Liu Peibao <liupeibao@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221104110712.23300-1-liupeibao@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-loongson-liointc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-loongson-liointc.c b/drivers/irqchip/irq-loongson-liointc.c
index 0da8716f8f24..c4584e2f0ad3 100644
--- a/drivers/irqchip/irq-loongson-liointc.c
+++ b/drivers/irqchip/irq-loongson-liointc.c
@@ -207,10 +207,13 @@ static int liointc_init(phys_addr_t addr, unsigned long size, int revision,
 					"reg-names", core_reg_names[i]);
 
 			if (index < 0)
-				goto out_iounmap;
+				continue;
 
 			priv->core_isr[i] = of_iomap(node, index);
 		}
+
+		if (!priv->core_isr[0])
+			goto out_iounmap;
 	}
 
 	/* Setup IRQ domain */
-- 
2.35.1



