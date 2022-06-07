Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7F4554189C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379697AbiFGVNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379464AbiFGVMB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:12:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E6E21A540;
        Tue,  7 Jun 2022 11:54:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C88861768;
        Tue,  7 Jun 2022 18:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE02BC385A2;
        Tue,  7 Jun 2022 18:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628042;
        bh=p85B30dk9OhAgqXpoKQRxZZSIMPJk0LPPpMeE1vocXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJjwRd+RA5fp1FTIDVRUgx6BXNzs3q+vcU2J0K14KGncUXVADh2jAzsoUGipk+WSY
         1/3CTCN8qs3COmMoRcFOu9Hxg6wq0HpfVHAPKYF+WK4rvEorOPRkvkjEXwt/uW/luw
         PX44y6l0G2N+iPf16pj+QZxpGcvm2ERLp0foqqM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Kwanghoon Son <k.son@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 184/879] media: exynos4-is: Fix compile warning
Date:   Tue,  7 Jun 2022 18:55:02 +0200
Message-Id: <20220607165008.184390262@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
 drivers/media/platform/samsung/exynos4-is/fimc-isp-video.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/samsung/exynos4-is/fimc-isp-video.h b/drivers/media/platform/samsung/exynos4-is/fimc-isp-video.h
index edcb3a5e3cb9..2dd4ddbc748a 100644
--- a/drivers/media/platform/samsung/exynos4-is/fimc-isp-video.h
+++ b/drivers/media/platform/samsung/exynos4-is/fimc-isp-video.h
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



