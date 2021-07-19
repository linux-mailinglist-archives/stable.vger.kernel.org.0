Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456903CDD13
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238494AbhGSOzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:55:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237234AbhGSOxl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:53:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E93560FED;
        Mon, 19 Jul 2021 15:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708772;
        bh=IUOyfzLMW8GzMiPpo4wEXbstiy9EHKa3mOMC7uXDqU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncZs4CBbSdZtUUZBHjs2S+DirgHBVuajB+GGpAwxlhEkP4Nq8uZpF+N8jz+0xDaI3
         OUc4l1aA9Ul7rm41BgATx+cEGfolfFhyAQwW65UE3/ZQLyB01Z40OlpVYNorlLKrR2
         G+raj7QIssiDE4L1cCG/pQgJ5oilnjaBV+Hm8UCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 125/421] drm: qxl: ensure surf.data is ininitialized
Date:   Mon, 19 Jul 2021 16:48:56 +0200
Message-Id: <20210719144950.881601088@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit fbbf23ddb2a1cc0c12c9f78237d1561c24006f50 ]

The object surf is not fully initialized and the uninitialized
field surf.data is being copied by the call to qxl_bo_create
via the call to qxl_gem_object_create. Set surf.data to zero
to ensure garbage data from the stack is not being copied.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: f64122c1f6ad ("drm: add new QXL driver. (v1.4)")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20210608161313.161922-1-colin.king@canonical.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/qxl/qxl_dumb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/qxl/qxl_dumb.c b/drivers/gpu/drm/qxl/qxl_dumb.c
index c666b89eed5d..e89491b5155f 100644
--- a/drivers/gpu/drm/qxl/qxl_dumb.c
+++ b/drivers/gpu/drm/qxl/qxl_dumb.c
@@ -57,6 +57,8 @@ int qxl_mode_dumb_create(struct drm_file *file_priv,
 	surf.height = args->height;
 	surf.stride = pitch;
 	surf.format = format;
+	surf.data = 0;
+
 	r = qxl_gem_object_create_with_handle(qdev, file_priv,
 					      QXL_GEM_DOMAIN_VRAM,
 					      args->size, &surf, &qobj,
-- 
2.30.2



