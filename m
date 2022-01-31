Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8554A43A8
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377225AbiAaLWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378708AbiAaLUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:20:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865CFC0698C1;
        Mon, 31 Jan 2022 03:13:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5985AB82A60;
        Mon, 31 Jan 2022 11:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96705C340E8;
        Mon, 31 Jan 2022 11:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627608;
        bh=cV/tBrF8igkYghxgdAlvpCjcLp7koFtF1DiSCLSyycU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tjj4hg80fnbolETfJAV4rCtmdGeM5EYz2334gJTlKSuW07gOtz3X75xGCoOB7SBpt
         76GkkAe0gzM61G/traiNSYWT9u3MO/+pzy/6E4Wpl9Ik+DG5MYpqVsNG06uZZZK9F2
         XxZ/96rceypW/BOztfYuB8RwptG7CSpIAGSAbfQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/171] drm/msm: Fix wrong size calculation
Date:   Mon, 31 Jan 2022 11:56:01 +0100
Message-Id: <20220131105233.285068117@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
@@ -437,7 +437,7 @@ static int msm_init_vram(struct drm_devi
 		of_node_put(node);
 		if (ret)
 			return ret;
-		size = r.end - r.start;
+		size = r.end - r.start + 1;
 		DRM_INFO("using VRAM carveout: %lx@%pa\n", size, &r.start);
 
 		/* if we have no IOMMU, then we need to use carveout allocator.


