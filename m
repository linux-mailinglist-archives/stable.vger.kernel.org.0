Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87665450EE8
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238556AbhKOSVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:21:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:60796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241121AbhKOSS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:18:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 039176325A;
        Mon, 15 Nov 2021 17:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998659;
        bh=1vlQxgWvv6mlibt4gMYdzN8sX3Rs91zWBBQcXsEaV2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PIH34gwWT0dOGCwovAZ+Ll6jekXCgl0JRh6AAxLCjTdfZHxJP/ZIxamDtuuVXdbtQ
         aCGXeCJOvn0AJmH0AYpyvQfBM1g+QW+G93DvE6OEreMJbKnqdMABkEUDYbfaVS2ehh
         K6r9tVLMvHDAi4cSayvKBPD+4ndoIJAu3tHzT+gE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 5.14 014/849] ce/gf100: fix incorrect CE0 address calculation on some GPUs
Date:   Mon, 15 Nov 2021 17:51:37 +0100
Message-Id: <20211115165420.487864561@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

commit 93f43ed81abec8c805e1b77eb1d20dbc51a24dc4 upstream.

The code which constructs the modules for each engine present on the GPU
passes -1 for 'instance' on non-instanced engines, which affects how the
name for a sub-device is generated.  This is then stored as 'instance 0'
in nvkm_subdev.inst, so code can potentially be shared with earlier GPUs
that only had a single instance of an engine.

However, GF100's CE constructor uses this value to calculate the address
of its falcon before it's translated, resulting in CE0 getting the wrong
address.

This slightly modifies the approach, always passing a valid instance for
engines that *can* have multiple copies, and having the code for earlier
GPUs explicitly ask for non-instanced name generation.

Bug: https://gitlab.freedesktop.org/drm/nouveau/-/issues/91

Fixes: 50551b15c760 ("drm/nouveau/ce: switch to instanced constructor")
Cc: <stable@vger.kernel.org> # v5.12+
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Tested-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211103011057.15344-1-skeggsb@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/ce/gt215.c    |    2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/nouveau/nvkm/engine/ce/gt215.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/ce/gt215.c
@@ -78,6 +78,6 @@ int
 gt215_ce_new(struct nvkm_device *device, enum nvkm_subdev_type type, int inst,
 	     struct nvkm_engine **pengine)
 {
-	return nvkm_falcon_new_(&gt215_ce, device, type, inst,
+	return nvkm_falcon_new_(&gt215_ce, device, type, -1,
 				(device->chipset != 0xaf), 0x104000, pengine);
 }
--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
@@ -3147,8 +3147,7 @@ nvkm_device_ctor(const struct nvkm_devic
 	WARN_ON(device->chip->ptr.inst & ~((1 << ARRAY_SIZE(device->ptr)) - 1));             \
 	for (j = 0; device->chip->ptr.inst && j < ARRAY_SIZE(device->ptr); j++) {            \
 		if ((device->chip->ptr.inst & BIT(j)) && (subdev_mask & BIT_ULL(type))) {    \
-			int inst = (device->chip->ptr.inst == 1) ? -1 : (j);                 \
-			ret = device->chip->ptr.ctor(device, (type), inst, &device->ptr[j]); \
+			ret = device->chip->ptr.ctor(device, (type), (j), &device->ptr[j]);  \
 			subdev = nvkm_device_subdev(device, (type), (j));                    \
 			if (ret) {                                                           \
 				nvkm_subdev_del(&subdev);                                    \


