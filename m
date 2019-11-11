Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 034F5F7D32
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfKKSyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:54:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:49916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729062AbfKKSyO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:54:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1756C2173B;
        Mon, 11 Nov 2019 18:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498453;
        bh=Ln5zO4FxwulI4Hbkne+2MsgfrPDmSUU850xuwaaYEEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rEZRVgoojPv+l8ZKjn+NUQNMXUGS/3N4mdDoxZIRgCZeGBB7ySqUXG8GNu+Tw4yBP
         uDjkZWoDrhC8JbmZiS7zuTSyy0MR9M1M7q71QOUJLHSiVPOc4zJfY1yZ72uQlpwedt
         gtstTE26jGbOY2fU5oW3ImDDnLW94bsX3aFhb4fA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Eric Anholt <eric@anholt.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 125/193] drm/v3d: Fix memory leak in v3d_submit_cl_ioctl
Date:   Mon, 11 Nov 2019 19:28:27 +0100
Message-Id: <20191111181510.407326103@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 29cd13cfd7624726d9e6becbae9aa419ef35af7f ]

In the impelementation of v3d_submit_cl_ioctl() there are two memory
leaks. One is when allocation for bin fails, and the other is when bin
initialization fails. If kcalloc fails to allocate memory for bin then
render->base should be put. Also, if v3d_job_init() fails to initialize
bin->base then allocated memory for bin should be released.

Fixes: a783a09ee76d ("drm/v3d: Refactor job management.")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Reviewed-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20191021185250.26130-1-navid.emamdoost@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_gem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/v3d_gem.c
index 27e0f87075d96..4dc7e38c99c7c 100644
--- a/drivers/gpu/drm/v3d/v3d_gem.c
+++ b/drivers/gpu/drm/v3d/v3d_gem.c
@@ -555,13 +555,16 @@ v3d_submit_cl_ioctl(struct drm_device *dev, void *data,
 
 	if (args->bcl_start != args->bcl_end) {
 		bin = kcalloc(1, sizeof(*bin), GFP_KERNEL);
-		if (!bin)
+		if (!bin) {
+			v3d_job_put(&render->base);
 			return -ENOMEM;
+		}
 
 		ret = v3d_job_init(v3d, file_priv, &bin->base,
 				   v3d_job_free, args->in_sync_bcl);
 		if (ret) {
 			v3d_job_put(&render->base);
+			kfree(bin);
 			return ret;
 		}
 
-- 
2.20.1



