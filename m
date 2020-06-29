Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB4120E2E6
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388473AbgF2VJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:09:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730316AbgF2TAS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:00:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7801E25503;
        Mon, 29 Jun 2020 15:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446062;
        bh=rA5aTAAmo8TA8iTP7C04iQfYJE34ws41yHWBaX4nd0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iwDLsfcl+a27y9TmKkMBBtK0mUX7nEDs5Gz9J9LbYdHw0z+nq+4Qn47Bs+VBV50t9
         t1h4++6iEKs0yrYvoYJn0+QtwnejTTrFqQd/uAA7cPdll9wSAmg0r6lOp/m6TNN6jf
         Dvgk8Wmw9g7xRvy9EsRJcBh0ukphhPoAct8GeeME=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 061/135] drm: encoder_slave: fix refcouting error for modules
Date:   Mon, 29 Jun 2020 11:51:55 -0400
Message-Id: <20200629155309.2495516-62-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit f78d4032de60f50fd4afaa0fb68ea03b985f820a ]

module_put() balances try_module_get(), not request_module(). Fix the
error path to match that.

Fixes: 2066facca4c7 ("drm/kms: slave encoder interface.")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Emil Velikov <emil.l.velikov@gmail.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_encoder_slave.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_encoder_slave.c b/drivers/gpu/drm/drm_encoder_slave.c
index d18b88b755c34..5c595d9f7e8f2 100644
--- a/drivers/gpu/drm/drm_encoder_slave.c
+++ b/drivers/gpu/drm/drm_encoder_slave.c
@@ -84,7 +84,7 @@ int drm_i2c_encoder_init(struct drm_device *dev,
 
 	err = encoder_drv->encoder_init(client, dev, encoder);
 	if (err)
-		goto fail_unregister;
+		goto fail_module_put;
 
 	if (info->platform_data)
 		encoder->slave_funcs->set_config(&encoder->base,
@@ -92,9 +92,10 @@ int drm_i2c_encoder_init(struct drm_device *dev,
 
 	return 0;
 
+fail_module_put:
+	module_put(module);
 fail_unregister:
 	i2c_unregister_device(client);
-	module_put(module);
 fail:
 	return err;
 }
-- 
2.25.1

