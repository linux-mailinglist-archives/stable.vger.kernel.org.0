Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2264627FAB
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237704AbiKNNBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:01:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237697AbiKNNBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:01:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93EFA28728
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:01:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3219D6117F
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:01:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35872C433D6;
        Mon, 14 Nov 2022 13:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430873;
        bh=GiXsIVZkPqj39HarEFzBXApxd7K4n4aBnfxJ0v2s8eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KzwiU5fko+q2ON23uyyvBkbTeKRZ4QdN6Rg6r9RBDpG8SBtdpPOKnTg2uLmPxYUd1
         nAqNOBUxIfjxAU9VLJG+cEz6omDG8CuII2kTgchomFRdTFUgOJH08v/H4+04YNAO7i
         MK1nZSCPtjVvKMGraC4ObGA28rg7wCeMFdPVvpTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 021/190] ALSA: arm: pxa: pxa2xx-ac97-lib: fix return value check of platform_get_irq()
Date:   Mon, 14 Nov 2022 13:44:05 +0100
Message-Id: <20221114124459.703334954@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

[ Upstream commit 46cf1954de3f324dc7f9472c12c3bd03b268a11b ]

platform_get_irq() returns negative error number on failure, fix the
return value check in pxa2xx_ac97_hw_probe() and assign the error code
to 'ret'.

Fixes: 2548e6c76ebf ("ARM: pxa: pxa2xx-ac97-lib: use IRQ resource")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221029082001.3207380-1-yangyingliang@huawei.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/arm/pxa2xx-ac97-lib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/arm/pxa2xx-ac97-lib.c b/sound/arm/pxa2xx-ac97-lib.c
index e55c0421718b..2ca33fd5a575 100644
--- a/sound/arm/pxa2xx-ac97-lib.c
+++ b/sound/arm/pxa2xx-ac97-lib.c
@@ -402,8 +402,10 @@ int pxa2xx_ac97_hw_probe(struct platform_device *dev)
 		goto err_clk2;
 
 	irq = platform_get_irq(dev, 0);
-	if (!irq)
+	if (irq < 0) {
+		ret = irq;
 		goto err_irq;
+	}
 
 	ret = request_irq(irq, pxa2xx_ac97_irq, 0, "AC97", NULL);
 	if (ret < 0)
-- 
2.35.1



