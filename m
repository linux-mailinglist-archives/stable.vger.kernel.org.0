Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13575408F8
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349207AbiFGSEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351833AbiFGSCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:02:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AB4158943;
        Tue,  7 Jun 2022 10:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 612EC616A3;
        Tue,  7 Jun 2022 17:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706CFC385A5;
        Tue,  7 Jun 2022 17:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623940;
        bh=CTn9HCUjXYHSwA99rQmy+i5tCftAg7PvxJaOxRnYJjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSZlWFNhUKJMe9Xvnj2Wb8AGeySsqykX7W2SlQM0EnqYsUqRScUbpHYdONBJ64Blm
         nVuobse9j3vO2F+R/dVnvy4PeEk7lmpubxxUqtvCslf6LPUrYFKuat5c+mo7I6tpct
         n79QDqHQd+XM+zPh6XI8Lf+TlRbn2Ejl7kRjHjus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Kwanghoon Son <k.son@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/667] media: exynos4-is: Fix compile warning
Date:   Tue,  7 Jun 2022 18:56:35 +0200
Message-Id: <20220607164938.723276775@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kwanghoon Son <k.son@samsung.com>

[ Upstream commit e080f5c1f2b6d02c02ee5d674e0e392ccf63bbaf ]

Declare static on function 'fimc_isp_video_device_unregister'.

When VIDEO_EXYNOS4_ISP_DMA_CAPTURE=n, compiler warns about
warning: no previous prototype for function [-Wmissing-prototypes]

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Kwanghoon Son <k.son@samsung.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/exynos4-is/fimc-isp-video.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.h b/drivers/media/platform/exynos4-is/fimc-isp-video.h
index edcb3a5e3cb9..2dd4ddbc748a 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.h
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.h
@@ -32,7 +32,7 @@ static inline int fimc_isp_video_device_register(struct fimc_isp *isp,
 	return 0;
 }
 
-void fimc_isp_video_device_unregister(struct fimc_isp *isp,
+static inline void fimc_isp_video_device_unregister(struct fimc_isp *isp,
 				enum v4l2_buf_type type)
 {
 }
-- 
2.35.1



