Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 203526E03F
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729116AbfGSElF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbfGSD5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:57:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CA1221850;
        Fri, 19 Jul 2019 03:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508625;
        bh=NOChr+M9WOR9orhCSmC3TRPJClfJwif6AL58ptimSVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YkTqd2ElFuWeLqHW6VEveWs20pnTPxsyuYcyktLIF0EmLLb9EghRc6c0vRN+pgwcH
         XgEG2EjWDIpQsIBmUkeEIHnlaraYpOI/+lhxioazyYlpFwrbDl7aCqeCVOZRDIQFDA
         UBZ3tcohv7VraN3xfAosx20DA+V7R3gdGMZNXJCA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sam Bobroff <sbobroff@linux.ibm.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 009/171] drm/bochs: Fix connector leak during driver unload
Date:   Thu, 18 Jul 2019 23:54:00 -0400
Message-Id: <20190719035643.14300-9-sashal@kernel.org>
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

From: Sam Bobroff <sbobroff@linux.ibm.com>

[ Upstream commit 3c6b8625dde82600fd03ad1fcba223f1303ee535 ]

When unloading the bochs-drm driver, a warning message is printed by
drm_mode_config_cleanup() because a reference is still held to one of
the drm_connector structs.

Correct this by calling drm_atomic_helper_shutdown() in
bochs_pci_remove().

Fixes: 6579c39594ae ("drm/bochs: atomic: switch planes to atomic, wire up helpers.")
Signed-off-by: Sam Bobroff <sbobroff@linux.ibm.com>
Link: http://patchwork.freedesktop.org/patch/msgid/93b363ad62f4938d9ddf3e05b2a61e3f66b2dcd3.1558416473.git.sbobroff@linux.ibm.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bochs/bochs_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/bochs/bochs_drv.c b/drivers/gpu/drm/bochs/bochs_drv.c
index b86cc705138c..d8b945596b09 100644
--- a/drivers/gpu/drm/bochs/bochs_drv.c
+++ b/drivers/gpu/drm/bochs/bochs_drv.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <drm/drm_fb_helper.h>
 #include <drm/drm_probe_helper.h>
+#include <drm/drm_atomic_helper.h>
 
 #include "bochs.h"
 
@@ -171,6 +172,7 @@ static void bochs_pci_remove(struct pci_dev *pdev)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
 
+	drm_atomic_helper_shutdown(dev);
 	drm_dev_unregister(dev);
 	bochs_unload(dev);
 	drm_dev_put(dev);
-- 
2.20.1

