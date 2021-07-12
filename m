Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7337F3C552E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355383AbhGLIJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353096AbhGLIBH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:01:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D4BE61C31;
        Mon, 12 Jul 2021 07:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076452;
        bh=nU6wzOKD8NiYG6Pa85TpKVwjSIDU5p7mZxdvPZvqRPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oss6v+dE8ZaDTqX5Ctxb+8jgVCWuEkRImePXG9TNMn5P3k+XDfaOrmFfyij0KZvti
         keM5jkDH+f6wQns6/6DDfOkGPHGd705NRdAsUCCI5Luo+NcKO9M54FfNKrpl8uf3kM
         asxOHV7eJksbel1rxNm4i1BDomNNnoSdRumCaVtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 648/800] staging: mmal-vchiq: Fix incorrect static vchiq_instance.
Date:   Mon, 12 Jul 2021 08:11:11 +0200
Message-Id: <20210712061035.998655715@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit afc023da53e46b88552822f2fe035c7129c505a2 ]

For some reason lost in history function vchiq_mmal_init used
a static variable for storing the vchiq_instance.
This value is retrieved from vchiq per instance, so worked fine
until you try to call vchiq_mmal_init multiple times concurrently
when things then go wrong. This seemed to happen quite frequently
if using the cutdown firmware (no MMAL or VCSM services running)
as the vchiq_connect then failed, and one or other vchiq_shutdown
was working on an invalid handle.

Remove the static so that each caller gets a unique vchiq_instance.

Fixes: 7b3ad5abf027 ("staging: Import the BCM2835 MMAL-based V4L2 camera driver.")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/1621979857-26754-1-git-send-email-stefan.wahren@i2se.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c b/drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c
index 06bca7be5203..76d3f0399964 100644
--- a/drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c
+++ b/drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c
@@ -1862,7 +1862,7 @@ int vchiq_mmal_init(struct vchiq_mmal_instance **out_instance)
 	int status;
 	int err = -ENODEV;
 	struct vchiq_mmal_instance *instance;
-	static struct vchiq_instance *vchiq_instance;
+	struct vchiq_instance *vchiq_instance;
 	struct vchiq_service_params_kernel params = {
 		.version		= VC_MMAL_VER,
 		.version_min		= VC_MMAL_MIN_VER,
-- 
2.30.2



