Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E374ABB20
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384236AbiBGL0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377777AbiBGLPi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:15:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9416BC0401F2;
        Mon,  7 Feb 2022 03:15:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EED686140C;
        Mon,  7 Feb 2022 11:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6614C340EB;
        Mon,  7 Feb 2022 11:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232515;
        bh=nE1n+sYB/6tK0H31pEAPox5TGZ1MxQk8Tj9aFsa/z74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sEZpEr1wJ40JvgX3vMACWQI6kWrOm5ip/POY0L0GDJhUWzju9r6ZEiYRIBZL7d9Fl
         Ui4GBoI4tLGH/V6bUBZnnA1mHWcznWUG8612ojF7U9WG2FhehUsOv0rtpdEcHf35R7
         6oFZOV11SHgUNHW1Bdd/t9J71sbIjkpzHjAv6djc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 35/86] drm/msm: Fix wrong size calculation
Date:   Mon,  7 Feb 2022 12:05:58 +0100
Message-Id: <20220207103758.680625641@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
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

From: Xianting Tian <xianting.tian@linux.alibaba.com>

commit 0a727b459ee39bd4c5ced19d6024258ac87b6b2e upstream.

For example, memory-region in .dts as below,
	reg = <0x0 0x50000000 0x0 0x20000000>

We can get below values,
struct resource r;
r.start = 0x50000000;
r.end	= 0x6fffffff;

So the size should be:
size = r.end - r.start + 1 = 0x20000000

Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
Fixes: 072f1f9168ed ("drm/msm: add support for "stolen" mem")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220112123334.749776-1-xianting.tian@linux.alibaba.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -388,7 +388,7 @@ static int msm_init_vram(struct drm_devi
 		of_node_put(node);
 		if (ret)
 			return ret;
-		size = r.end - r.start;
+		size = r.end - r.start + 1;
 		DRM_INFO("using VRAM carveout: %lx@%pa\n", size, &r.start);
 
 		/* if we have no IOMMU, then we need to use carveout allocator.


