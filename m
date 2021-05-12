Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8A737CD51
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237179AbhELQy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:54:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243753AbhELQmB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C9DC6195A;
        Wed, 12 May 2021 16:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835582;
        bh=jJBfcZSMxzOu0I1FuITNhDs/2GeZ66Y0fPfWyvKslnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V8wcJS9b37JzbDpjStmFPswWA9fx9/1CuuSGCMWXIxiPo0hNQx875AvNH2bplPSCE
         YGcom5m/dqZZhCXmnTawaVkIcjhk+Sa2FfyysBvZgINyR190x4fxA7wyEUVzOQmVQ3
         JO73l0NiplXrvdEKWsf0ew4df0hb8I4Fd2j5KmR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 375/677] drm/omap: dsi: Add missing IRQF_ONESHOT
Date:   Wed, 12 May 2021 16:47:01 +0200
Message-Id: <20210512144849.791650274@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 0cafc8d88e6df446751669ec15adc9b807af4501 ]

fixed the following coccicheck:
./drivers/gpu/drm/omapdrm/dss/dsi.c:4329:7-27: ERROR: Threaded IRQ with
no primary handler requested without IRQF_ONESHOT

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Fixes: 4c1b935fea54 ("drm/omap: dsi: move TE GPIO handling into core")
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/1616492093-68237-1-git-send-email-yang.lee@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/omapdrm/dss/dsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/dsi.c b/drivers/gpu/drm/omapdrm/dss/dsi.c
index b31d750c425a..5f1722b040f4 100644
--- a/drivers/gpu/drm/omapdrm/dss/dsi.c
+++ b/drivers/gpu/drm/omapdrm/dss/dsi.c
@@ -4327,7 +4327,8 @@ static int omap_dsi_register_te_irq(struct dsi_data *dsi,
 	irq_set_status_flags(te_irq, IRQ_NOAUTOEN);
 
 	err = request_threaded_irq(te_irq, NULL, omap_dsi_te_irq_handler,
-				   IRQF_TRIGGER_RISING, "TE", dsi);
+				   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+				   "TE", dsi);
 	if (err) {
 		dev_err(dsi->dev, "request irq failed with %d\n", err);
 		gpiod_put(dsi->te_gpio);
-- 
2.30.2



