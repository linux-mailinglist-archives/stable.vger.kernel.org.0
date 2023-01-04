Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A512365D97A
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239737AbjADQZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235006AbjADQZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:25:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755263D1C0
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:24:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35CE0B817B0
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7300BC433F0;
        Wed,  4 Jan 2023 16:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849485;
        bh=RKeG6pAXImq9qcj+T4tzTpmu5OGLr1tJpPPZeeygvbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oBRDj7wzSP0BGW6tUUL3Nhn3NNj4N1oYThZp3+h+QK3w1U/QdAP7Xs3i8YSfoZJAV
         PmjZanZDD0j0bmppbKaAkpoaOlR2xnjwlcp5Jb/2WcVwXeBzLcnCzLl4EpT3BxlBGR
         8Fuhv1FgpAoSoZIg7iikKfsn23NQTsjk3npM0XeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>
Subject: [PATCH 6.0 130/177] drm/etnaviv: reap idle mapping if it doesnt match the softpin address
Date:   Wed,  4 Jan 2023 17:07:01 +0100
Message-Id: <20230104160511.586835469@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

From: Lucas Stach <l.stach@pengutronix.de>

commit 332f847212e43d584019a8264895f25cf92aa647 upstream.

When a idle BO, which is held open by another process, gets freed by
userspace and subsequently referenced again by e.g. importing it again,
userspace may assign a different softpin VA than the last time around.
As the kernel GEM object still exists, we likely have a idle mapping
with the old VA still cached, if it hasn't been reaped in the meantime.

As the context matches, we then simply try to resurrect this mapping by
increasing the refcount. As the VA in this mapping does not match the
new softpin address, we consequently fail the otherwise valid submit.
Instead of failing, reap the idle mapping.

Cc: stable@vger.kernel.org # 5.19
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Guido Günther <agx@sigxcpu.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gem.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -258,7 +258,12 @@ struct etnaviv_vram_mapping *etnaviv_gem
 		if (mapping->use == 0) {
 			mutex_lock(&mmu_context->lock);
 			if (mapping->context == mmu_context)
-				mapping->use += 1;
+				if (va && mapping->iova != va) {
+					etnaviv_iommu_reap_mapping(mapping);
+					mapping = NULL;
+				} else {
+					mapping->use += 1;
+				}
 			else
 				mapping = NULL;
 			mutex_unlock(&mmu_context->lock);


