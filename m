Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED2D7960B
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbfG2TsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:48:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390165AbfG2TsH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:48:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 414A9217D6;
        Mon, 29 Jul 2019 19:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429686;
        bh=sPGWWvnRK3lCpC2z96s5vL/h2YymgXEfM+MvPi/C/3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rUg9bgrp+/TYm69TUMBy5iOUCxGwxBkkhTBSzmP0DnLcU4PgyeC1w3Ki3zKPff1eM
         yPqWjIhpNt+nUjaSiZg5L8lCXsys9l/ydcchDmq4/PFXJ7+Uib1L1Go8AHeotcEbI3
         0p7+20QjoeIODvTnruGYBv+yurK4O+7Pr4fzreGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 061/215] drm/bridge: tfp410: fix use of cancel_delayed_work_sync
Date:   Mon, 29 Jul 2019 21:20:57 +0200
Message-Id: <20190729190751.102055862@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



