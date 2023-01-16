Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044CE66CD14
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbjAPRdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234863AbjAPRco (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:32:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6082E0D7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:09:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E3C2B810A1
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3949C4339C;
        Mon, 16 Jan 2023 17:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888943;
        bh=0qYRCxNp3oqgKWE4HrTO3ZC/wlJzFWBHHsUY+kfT8xE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CzUFa4Gu+zDot7/6y4heoVGui8LgK2iBOpOyVx7v98BD/DYV48GoJjAjnp3+/9RvI
         YPQ1CIDNtpXSqNn3KP8kyxSJNnWeURx2Oczzh4RpGCv2XsdT0e0wvJG57qtRC7DzsY
         v7RapNKA/14NlPMfvtPHr7R4x6wRHUsAroZQwbRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 198/338] powerpc/xive: add missing iounmap() in error path in xive_spapr_populate_irq_data()
Date:   Mon, 16 Jan 2023 16:51:11 +0100
Message-Id: <20230116154829.596074890@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 8b49670f3bb3f10cd4d5a6dca17f5a31b173ecdc ]

If remapping 'data->trig_page' fails, the 'data->eoi_mmio' need be unmapped
before returning from xive_spapr_populate_irq_data().

Fixes: eac1e731b59e ("powerpc/xive: guest exploitation of the XIVE interrupt controller")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221017032333.1852406-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xive/spapr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/sysdev/xive/spapr.c b/arch/powerpc/sysdev/xive/spapr.c
index e9b8e06c9dce..be1619c9b726 100644
--- a/arch/powerpc/sysdev/xive/spapr.c
+++ b/arch/powerpc/sysdev/xive/spapr.c
@@ -323,6 +323,7 @@ static int xive_spapr_populate_irq_data(u32 hw_irq, struct xive_irq_data *data)
 
 	data->trig_mmio = ioremap(data->trig_page, 1u << data->esb_shift);
 	if (!data->trig_mmio) {
+		iounmap(data->eoi_mmio);
 		pr_err("Failed to map trigger page for irq 0x%x\n", hw_irq);
 		return -ENOMEM;
 	}
-- 
2.35.1



