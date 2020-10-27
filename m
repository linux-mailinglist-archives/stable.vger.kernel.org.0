Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570DC29C2CF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1820858AbgJ0RjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:39:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:32818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760218AbgJ0OeC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:34:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CCF1207BB;
        Tue, 27 Oct 2020 14:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809242;
        bh=1Y364duatBBUJCxU9Qrrav/P6SMu/GedhHQJqpgaBcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dy0enMGHXsLcZRqZH+ZDxg+Q4e4L5juGSya2x0ZC4odotAmlZuPM61wHXtlKL43fp
         SuEPqNsKg6PE0oY2FKaGy535PoD1WVo9VypsZo4jEahIgJfa3ek2rx7fgD9VGAIO/H
         1Qh4p0QUuH2EGaBfN1BDfCnOzK+EAug7AyWX8c7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 127/408] drm/crc-debugfs: Fix memleak in crc_control_write
Date:   Tue, 27 Oct 2020 14:51:05 +0100
Message-Id: <20201027135500.989201679@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit f7ec68b341dbd5da13d4c65ce444dcd605f1c42e ]

When verify_crc_source() fails, source needs to be freed.
However, current code is returning directly and ends up
leaking memory.

Fixes: d5cc15a0c66e ("drm: crc: Introduce verify_crc_source callback")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
[danvet: change Fixes: tag per Laurent's review]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20200819082228.26847-1-dinghao.liu@zju.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_debugfs_crc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_debugfs_crc.c b/drivers/gpu/drm/drm_debugfs_crc.c
index 6a626c82e264b..f6598c5a9a879 100644
--- a/drivers/gpu/drm/drm_debugfs_crc.c
+++ b/drivers/gpu/drm/drm_debugfs_crc.c
@@ -144,8 +144,10 @@ static ssize_t crc_control_write(struct file *file, const char __user *ubuf,
 		source[len - 1] = '\0';
 
 	ret = crtc->funcs->verify_crc_source(crtc, source, &values_cnt);
-	if (ret)
+	if (ret) {
+		kfree(source);
 		return ret;
+	}
 
 	spin_lock_irq(&crc->lock);
 
-- 
2.25.1



