Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCDE657D37
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbiL1Pkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233948AbiL1Pkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:40:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC76108
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:40:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CECC6155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D915C433D2;
        Wed, 28 Dec 2022 15:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242041;
        bh=IdNOCukQi4WqQbNJ8DBWaJ9xqZqO2hb2IG8hlx24j1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2tHIRn9XcfcP/rFzAzBpJeqQe0wY2p2WUbIW/2Vv3mv78WGIp39rZouHt9R2smF1
         mwUoz0p+dyZWm5uIkRLDn4Y9V0Mgbpx5ANCmSW4rQYnBP4wjZ91TsuMkycbhb6oVag
         mFNjsIkccALJonkqJX5tWTYNuufjRt7rb/2D/zaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 556/731] powerpc/xive: add missing iounmap() in error path in xive_spapr_populate_irq_data()
Date:   Wed, 28 Dec 2022 15:41:03 +0100
Message-Id: <20221228144312.653685105@linuxfoundation.org>
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
index 2bf78a30238b..43bd2579d942 100644
--- a/arch/powerpc/sysdev/xive/spapr.c
+++ b/arch/powerpc/sysdev/xive/spapr.c
@@ -437,6 +437,7 @@ static int xive_spapr_populate_irq_data(u32 hw_irq, struct xive_irq_data *data)
 
 	data->trig_mmio = ioremap(data->trig_page, 1u << data->esb_shift);
 	if (!data->trig_mmio) {
+		iounmap(data->eoi_mmio);
 		pr_err("Failed to map trigger page for irq 0x%x\n", hw_irq);
 		return -ENOMEM;
 	}
-- 
2.35.1



