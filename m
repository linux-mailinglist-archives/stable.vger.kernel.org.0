Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9E3205F71
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391350AbgFWUc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:32:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390573AbgFWUcy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:32:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B5EB20702;
        Tue, 23 Jun 2020 20:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944374;
        bh=YkVoEorFSdIv9ryto11yZN9u8v2/IijlcqCT9u3qakE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2S8TfC6v9QUbiD7/Sc2ywr++EQAthOsZmB6OwYlS7m6w0ErX354Dw8ancQkAzfIsg
         B1F7M9UIAVbPthO9Vk5jePefziTeywRvFHyzMWj23+9STEtJXkgdQ9afnbnKz0NVC/
         3goCqnioa+NRgfRP8q0nO2my8hSl1MTifnUxTvjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 280/314] drm: encoder_slave: fix refcouting error for modules
Date:   Tue, 23 Jun 2020 21:57:55 +0200
Message-Id: <20200623195352.338196405@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
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



