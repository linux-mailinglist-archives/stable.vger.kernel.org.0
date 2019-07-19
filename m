Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A6E6E00B
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfGSEjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:39:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728361AbfGSD65 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:58:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D01A921855;
        Fri, 19 Jul 2019 03:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508736;
        bh=ArwmgiV1wSYko0c2MaUE0C7Iz4E5SJPnVJ/ZR/Lcg0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZptdSlyu+xpXNYOyLbzZ5/NU+ntd37BxinqRRk6RLSHfCC3Ij5F+pvYtos5v/Tb8
         aQBZ7h7qycjKr4GXlAHmV8ENAU9vNcXM2ScPkj7snGZm/YEXQ7q6PfYeF4L7QK8wE9
         v0mwxcHlVF6FyxpVcx4fqWUIT/yf8vFITMWBMg94=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 059/171] drm/bridge: tfp410: fix use of cancel_delayed_work_sync
Date:   Thu, 18 Jul 2019 23:54:50 -0400
Message-Id: <20190719035643.14300-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

[ Upstream commit b1622cb3be4557fd086831ca7426eafe5f1acc2e ]

We use delayed_work in HPD handling, and cancel any scheduled work in
tfp410_fini using cancel_delayed_work_sync(). However, we have only
initialized the delayed work if we actually have a HPD interrupt
configured in the DT, but in the tfp410_fini, we always cancel the work,
possibly causing a WARN().

Fix this by doing the cancel only if we actually had the delayed work
set up.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190610135739.6077-2-tomi.valkeinen@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-tfp410.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ti-tfp410.c b/drivers/gpu/drm/bridge/ti-tfp410.c
index a879aac21246..3a8af9978ebd 100644
--- a/drivers/gpu/drm/bridge/ti-tfp410.c
+++ b/drivers/gpu/drm/bridge/ti-tfp410.c
@@ -372,7 +372,8 @@ static int tfp410_fini(struct device *dev)
 {
 	struct tfp410 *dvi = dev_get_drvdata(dev);
 
-	cancel_delayed_work_sync(&dvi->hpd_work);
+	if (dvi->hpd_irq >= 0)
+		cancel_delayed_work_sync(&dvi->hpd_work);
 
 	drm_bridge_remove(&dvi->bridge);
 
-- 
2.20.1

