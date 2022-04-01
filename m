Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF07C4EF056
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347308AbiDAOfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347513AbiDAOdC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:33:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDA31EFE15;
        Fri,  1 Apr 2022 07:29:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2246B61C43;
        Fri,  1 Apr 2022 14:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6EBC340EE;
        Fri,  1 Apr 2022 14:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823363;
        bh=aoUe/M1CYOzKJMsQYqxk8lxuYJkmbYkYDaHKmDTSJss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AOdulAj2OIRKWAFzRIU+C91lhEeK4lEDf+uxyQWDuDCR9EoZ3FIihVVjz/Li37770
         fUlfJWYtK+pH2VSskZMXENepMaJfVO+hI5qOwOF0nY0tvbLXwr/VHtQeS6sbe3GDLF
         WV11hZpvb3ISRZaGkXYQC37ECZkl5D/jfHZZUGMywXA635GnJpN1OXT5sxB88wYRDU
         dLdEgvImgvJTWxUNyeS49Upqmaq7x9CL/FxltLFiArI972zAZ6KZc6xssZLKJ2PkpT
         ypStFIPhcYKyiIN+9tdet8R4R0o9oanA+55yLRaNc4o+E8YnIqiyBHQIufTMp5Ftot
         C/TKJqmp20Iaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kevin Tang <kevin3.tang@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>, airlied@linux.ie,
        daniel@ffwll.ch, orsonzhai@gmail.com, baolin.wang7@gmail.com,
        zhang.lyra@gmail.com, maarten.lankhorst@linux.intel.com,
        yong.wu@mediatek.com, etom@igel.co.jp,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 071/149] drm/sprd: fix potential NULL dereference
Date:   Fri,  1 Apr 2022 10:24:18 -0400
Message-Id: <20220401142536.1948161-71-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Kevin Tang <kevin3.tang@gmail.com>

[ Upstream commit 8668658aebb0a19d877d5a81c004baf716c4aaa6 ]

'drm' could be null in sprd_drm_shutdown, and drm_warn maybe dereference
it, remove this warning log.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kevin Tang <kevin3.tang@gmail.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/all/20220117084044.9210-1-kevin3.tang@gmail.com

v1 -> v2:
- Split checking platform_get_resource() return value to a separate patch
- Use dev_warn() instead of removing the warning log

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sprd/sprd_drm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sprd/sprd_drm.c b/drivers/gpu/drm/sprd/sprd_drm.c
index a077e2d4d721..af2be97d5ed0 100644
--- a/drivers/gpu/drm/sprd/sprd_drm.c
+++ b/drivers/gpu/drm/sprd/sprd_drm.c
@@ -155,7 +155,7 @@ static void sprd_drm_shutdown(struct platform_device *pdev)
 	struct drm_device *drm = platform_get_drvdata(pdev);
 
 	if (!drm) {
-		drm_warn(drm, "drm device is not available, no shutdown\n");
+		dev_warn(&pdev->dev, "drm device is not available, no shutdown\n");
 		return;
 	}
 
-- 
2.34.1

