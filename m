Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7CB22060E8
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392925AbgFWUsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:48:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392913AbgFWUsD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:48:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5F3B21548;
        Tue, 23 Jun 2020 20:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945283;
        bh=YkVoEorFSdIv9ryto11yZN9u8v2/IijlcqCT9u3qakE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sa5X4un9T0HSlYyEgfCl+onktsfsUkHgk9sYJP+ecRa9T8xifwt67PDdM5nwzjaWE
         O1YHghikuNQ5qooKvM0lAIVvMKjx4XqcB2VmW/+/BAK6dBU5Z+rHjppm3uv3W3f6Bw
         HrvnYZ2V/Uq8QaWiCHN0TqdQsflR+dXRC0G2b8Tk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 111/136] drm: encoder_slave: fix refcouting error for modules
Date:   Tue, 23 Jun 2020 21:59:27 +0200
Message-Id: <20200623195309.255776475@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index cf804389f5eca..d50a7884e69e1 100644
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



