Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3385929B92D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802238AbgJ0PqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:46:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798143AbgJ0P1z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:27:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1519220780;
        Tue, 27 Oct 2020 15:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812474;
        bh=PJv+tjykekcFthJkwaQ076el4d3oxQG0tmu3Jqidw7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M9QszXiVkmhne0uYQJIEoIlQd1CDdDLYoNlZlxm9WeNeSB/nFb8WQKTlh2/R8DXd7
         6ho2/XheNX3xfffSrh/t8eJNA4Gjd4B3PPpKKt4OE89lG/M0fictojwdxaqhZ9Y60x
         jIO1da//JY0LvtY2FBwxAp4icONtcoHV94n5joio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 223/757] drm/crc-debugfs: Fix memleak in crc_control_write
Date:   Tue, 27 Oct 2020 14:47:53 +0100
Message-Id: <20201027135501.075797390@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index 5d67a41f7c3a8..3dd70d813f694 100644
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



