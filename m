Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094384F2661
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbiDEIFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235853AbiDEIAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:00:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8111EACB;
        Tue,  5 Apr 2022 00:58:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D532F6173E;
        Tue,  5 Apr 2022 07:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2511C3410F;
        Tue,  5 Apr 2022 07:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145515;
        bh=+vB/c5TYSJXJNmD9pjNpxLmLtUsmHAcZ/hjWBUHuL58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZpCaPxj9Q9DTsI4tU2y1fajozQF5k9nKcOOt6A+N2XjmlTo2vxO9Er9lm1dWcAj74
         NtlqSpibzOLO0i+ZC+PpqIC6erROPWfkCs2THDDjLyOIgjpwM+VmSUjBN7dwmDeWJg
         T5bLkHmPYvjaoS1bJlJjVFhxwntRYiyHsoIUUSe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Steven Price <steven.price@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0434/1126] drm/panfrost: Check for error num after setting mask
Date:   Tue,  5 Apr 2022 09:19:41 +0200
Message-Id: <20220405070420.363666105@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 44ab30b056149bd59dd7989a593dd25ead6007fd ]

Because of the possible failure of the dma_supported(), the
dma_set_mask_and_coherent() may return error num.
Therefore, it should be better to check it and return the error if
fails.

Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
[Steve: fix Fixes: line]
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220106030326.2620942-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_gpu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_gpu.c b/drivers/gpu/drm/panfrost/panfrost_gpu.c
index bbe628b306ee..f8355de6e335 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gpu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gpu.c
@@ -360,8 +360,11 @@ int panfrost_gpu_init(struct panfrost_device *pfdev)
 
 	panfrost_gpu_init_features(pfdev);
 
-	dma_set_mask_and_coherent(pfdev->dev,
+	err = dma_set_mask_and_coherent(pfdev->dev,
 		DMA_BIT_MASK(FIELD_GET(0xff00, pfdev->features.mmu_features)));
+	if (err)
+		return err;
+
 	dma_set_max_seg_size(pfdev->dev, UINT_MAX);
 
 	irq = platform_get_irq_byname(to_platform_device(pfdev->dev), "gpu");
-- 
2.34.1



