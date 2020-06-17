Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680B31FD91D
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 00:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgFQWnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 18:43:50 -0400
Received: from mail1.protonmail.ch ([185.70.40.18]:25963 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgFQWnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 18:43:50 -0400
Date:   Wed, 17 Jun 2020 22:36:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1592433409;
        bh=Hc2vJyKauPxWIN1Brv3xdgm9zv1UUYytsgevWO4nQ68=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=BBp2S4pYRpuYrTeYQRLzAGBqfLxCAHkntk3pkGwzMAKChzI3s8/AsEi0vavDAxnQq
         Q+dCgSu4bHOb3f7PuFDpb7YBkDS8CsHvn3USRhUUn+8e3u+1/5A/KsfELIEGy9ZE+F
         KCMKVMuUtgYtrZR8DHWe76m+pYZA1W6I7o0+/+lw=
To:     stable@vger.kernel.org
From:   =?utf-8?Q?N=C3=ADcolas_F=2E_R=2E_A=2E_Prado?= 
        <nfraprado@protonmail.com>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jordan Crouse <jcrouse@codeaurora.org>
Reply-To: =?utf-8?Q?N=C3=ADcolas_F=2E_R=2E_A=2E_Prado?= 
          <nfraprado@protonmail.com>
Subject: [PATCH] drm/msm: Fix undefined "rd_full" link error
Message-ID: <20200617223628.3835502-1-nfraprado@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

commit 20aebe83698feb107d5a66b6cfd1d54459ccdfcf upstream.

rd_full should be defined outside the CONFIG_DEBUG_FS region, in order
to be able to link the msm driver even when CONFIG_DEBUG_FS is disabled.

Fixes: e515af8d4a6f ("drm/msm: devcoredump should dump MSM_SUBMIT_BO_DUMP b=
uffers")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: N=C3=ADcolas F. R. A. Prado <nfraprado@protonmail.com>
---
Hi,

this is my first time sending to the stable line, so please tell me if ther=
e's
anything wrong.

Building the kernel is failing for the Nexus 5 (ARCH=3Darm,
CROSS_COMPILE=3Darm-linux-gnueabihf-, DEFCONFIG=3Dqcom_defconfig) on 5.7 (f=
rom
5.7-rc1 to 5.7.3) with the following error:

ERROR: modpost: "rd_full" [drivers/gpu/drm/msm/msm.ko] undefined!
make[1]: *** [scripts/Makefile.modpost:94: __modpost] Error 1
make: *** [Makefile:1326: modules] Error 2

This patch from 5.8-rc1 fixes it, so it should be applied to the 5.7.y bran=
ch.

Thanks,
N=C3=ADcolas

 drivers/gpu/drm/msm/msm_rd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_rd.c b/drivers/gpu/drm/msm/msm_rd.c
index 732f65df5c4f..fea30e7aa9e8 100644
--- a/drivers/gpu/drm/msm/msm_rd.c
+++ b/drivers/gpu/drm/msm/msm_rd.c
@@ -29,8 +29,6 @@
  * or shader programs (if not emitted inline in cmdstream).
  */
=20
-#ifdef CONFIG_DEBUG_FS
-
 #include <linux/circ_buf.h>
 #include <linux/debugfs.h>
 #include <linux/kfifo.h>
@@ -47,6 +45,8 @@ bool rd_full =3D false;
 MODULE_PARM_DESC(rd_full, "If true, $debugfs/.../rd will snapshot all buff=
er contents");
 module_param_named(rd_full, rd_full, bool, 0600);
=20
+#ifdef CONFIG_DEBUG_FS
+
 enum rd_sect_type {
 =09RD_NONE,
 =09RD_TEST,       /* ascii text */
--=20
2.27.0


