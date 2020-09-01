Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFE325991C
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgIAQgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:36:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729301AbgIAP3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:29:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66AF620FC3;
        Tue,  1 Sep 2020 15:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974174;
        bh=G7hxTffaqe+Bxa7p5NVLTRKMskTbwn8S9WqqzMk2v74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzbcmso30S81fRjHMhZWGK6wgJQSMi+ZOh5rSR9P38IReUGnMdkCU4LH60PiSa4OW
         KkpLljlWMoWdm1L/yFgv/RXRjEOiVcB9oiU4DwFQBShPwML8585DD+gbhXRrjTrIbP
         HWVb3ClD2DJFkoTIvO23txBeP8Zf8+SWybmCETwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ding Xiang <dingxiang@cmss.chinamobile.com>,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/214] drm/xen: fix passing zero to PTR_ERR warning
Date:   Tue,  1 Sep 2020 17:09:14 +0200
Message-Id: <20200901150956.517513806@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ding Xiang <dingxiang@cmss.chinamobile.com>

[ Upstream commit 4c1cb04e0e7ac4ba1ef5457929ef9b5671d9eed3 ]

Fix a static code checker warning:
    drivers/gpu/drm/xen/xen_drm_front.c:404 xen_drm_drv_dumb_create()
    warn: passing zero to 'PTR_ERR'

Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
Reviewed-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/1585562347-30214-1-git-send-email-dingxiang@cmss.chinamobile.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xen/xen_drm_front.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xen/xen_drm_front.c b/drivers/gpu/drm/xen/xen_drm_front.c
index 4be49c1aef518..374142018171c 100644
--- a/drivers/gpu/drm/xen/xen_drm_front.c
+++ b/drivers/gpu/drm/xen/xen_drm_front.c
@@ -401,7 +401,7 @@ static int xen_drm_drv_dumb_create(struct drm_file *filp,
 
 	obj = xen_drm_front_gem_create(dev, args->size);
 	if (IS_ERR_OR_NULL(obj)) {
-		ret = PTR_ERR(obj);
+		ret = PTR_ERR_OR_ZERO(obj);
 		goto fail;
 	}
 
-- 
2.25.1



