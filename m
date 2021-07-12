Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856313C4574
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbhGLGZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:25:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235264AbhGLGYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:24:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F17861108;
        Mon, 12 Jul 2021 06:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070910;
        bh=SbF4yzBq7y62F6u4/XMHKjDwk6LqH31EWHoz1G38F7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UIZcI+ZsH4AOAUXiup3+hzOCYHI0kf4l5SKCeZkH7OhKsf5wfJe5h2wr/WtVLMV8/
         ibeAcM75lVTMGpwibb8hxG6qhlBafKvQlZo/4fgDQMaF/es7v7QU+SGd84IDQqT/7p
         w/hD3xhirRf7nbD1znauvy68DPzidqZmADFN6KSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 192/348] drm/rockchip: cdn-dp-core: add missing clk_disable_unprepare() on error in cdn_dp_grf_write()
Date:   Mon, 12 Jul 2021 08:09:36 +0200
Message-Id: <20210712060726.522114754@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit ae41d925c75b53798f289c69ee8d9f7d36432f6d ]

After calling clk_prepare_enable(), clk_disable_unprepare() need
be called when calling regmap_write() failed.

Fixes: 1a0f7ed3abe2 ("drm/rockchip: cdn-dp: add cdn DP support for rk3399")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20210519134928.2696617-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/cdn-dp-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/rockchip/cdn-dp-core.c b/drivers/gpu/drm/rockchip/cdn-dp-core.c
index d505ea7d5384..8f299d76b69b 100644
--- a/drivers/gpu/drm/rockchip/cdn-dp-core.c
+++ b/drivers/gpu/drm/rockchip/cdn-dp-core.c
@@ -72,6 +72,7 @@ static int cdn_dp_grf_write(struct cdn_dp_device *dp,
 	ret = regmap_write(dp->grf, reg, val);
 	if (ret) {
 		DRM_DEV_ERROR(dp->dev, "Could not write to GRF: %d\n", ret);
+		clk_disable_unprepare(dp->grf_clk);
 		return ret;
 	}
 
-- 
2.30.2



