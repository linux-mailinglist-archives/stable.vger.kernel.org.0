Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECB9417483
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345430AbhIXNHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:07:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345018AbhIXNFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:05:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C009661107;
        Fri, 24 Sep 2021 12:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488143;
        bh=ckDzZx/F0M8XMpGOU1duiUOy/wn6eUR0XqvN7lA37a4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z46xfuN1gDqg0koTjLAZsYmGXX8+EYOUY7j0YmGkaiCQlOhgH+N8c5zAWEHfC+Ppf
         zviajPmckQzImPNhxBAHJZNz9+j+4gGZdL1EIPxdcR3iao/15huev+cfU32sWMonyS
         EIjya8eh5FtroS/Dm6Ier4kfCNbxHqAPXxEx91Xg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.14 100/100] drm/nouveau/nvkm: Replace -ENOSYS with -ENODEV
Date:   Fri, 24 Sep 2021 14:44:49 +0200
Message-Id: <20210924124344.847773688@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit e8f71f89236ef82d449991bfbc237e3cb6ea584f upstream.

nvkm test builds fail with the following error.

  drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c: In function 'nvkm_control_mthd_pstate_info':
  drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c:60:35: error: overflow in conversion from 'int' to '__s8' {aka 'signed char'} changes value from '-251' to '5'

The code builds on most architectures, but fails on parisc where ENOSYS
is defined as 251.

Replace the error code with -ENODEV (-19).  The actual error code does
not really matter and is not passed to userspace - it just has to be
negative.

Fixes: 7238eca4cf18 ("drm/nouveau: expose pstate selection per-power source in sysfs")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c
@@ -57,7 +57,7 @@ nvkm_control_mthd_pstate_info(struct nvk
 		args->v0.count = 0;
 		args->v0.ustate_ac = NVIF_CONTROL_PSTATE_INFO_V0_USTATE_DISABLE;
 		args->v0.ustate_dc = NVIF_CONTROL_PSTATE_INFO_V0_USTATE_DISABLE;
-		args->v0.pwrsrc = -ENOSYS;
+		args->v0.pwrsrc = -ENODEV;
 		args->v0.pstate = NVIF_CONTROL_PSTATE_INFO_V0_PSTATE_UNKNOWN;
 	}
 


