Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB0330CC94
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240313AbhBBUA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:00:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:38204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232974AbhBBNrm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:47:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C162164F98;
        Tue,  2 Feb 2021 13:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273320;
        bh=xxpUYpNUwg9WVbKZi1NM8nUZ/wS3c0OgoxdXTyYhosg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jAWesLH1Th8FuYNDLBii1r1KH7I+3/JT+jTxCaTyxUfjTPZup9VJowt7dV/XgJjfS
         tpVfD57cOxIt+nVJJN0Xogcusrlf8490sD1PEKG8JVAG01uLTAqmwKAU0K3amE16iX
         80xyUbomSsWifm6bYFiLN5SuJc5nE8yShP3LUOF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bastian Beranek <bastian.beischer@rwth-aachen.de>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 5.10 062/142] drm/nouveau/dispnv50: Restore pushing of all data.
Date:   Tue,  2 Feb 2021 14:37:05 +0100
Message-Id: <20210202133000.278560691@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bastian Beranek <bastian.beischer@rwth-aachen.de>

commit fd55b61ebd31449549e14c33574825d64de2b29b upstream.

Commit f844eb485eb056ad3b67e49f95cbc6c685a73db4 introduced a regression for
NV50, which lead to visual artifacts, tearing and eventual crashes.

In the changes of f844eb485eb056ad3b67e49f95cbc6c685a73db4 only the first line
was correctly translated to the new NVIDIA header macros:

-		PUSH_NVSQ(push, NV827C, 0x0110, 0,
-					0x0114, 0);
+		PUSH_MTHD(push, NV827C, SET_PROCESSING,
+			  NVDEF(NV827C, SET_PROCESSING, USE_GAIN_OFS, DISABLE));

The lower part ("0x0114, 0") was probably omitted by accident.

This patch restores the push of the missing data and fixes the regression.

Signed-off-by: Bastian Beranek <bastian.beischer@rwth-aachen.de>
Fixes: f844eb485eb05 ("drm/nouveau/kms/nv50-: use NVIDIA's headers for wndw image_set()")
Link: https://gitlab.freedesktop.org/drm/nouveau/-/issues/14
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/gpu/drm/nouveau/dispnv50/base507c.c b/drivers/gpu/drm/nouveau/dispnv50/base507c.c
index 302d4e6fc52f..788db043a342 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/base507c.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/base507c.c
@@ -88,7 +88,11 @@ base507c_image_set(struct nv50_wndw *wndw, struct nv50_wndw_atom *asyw)
 			  NVVAL(NV507C, SET_CONVERSION, OFS, 0x64));
 	} else {
 		PUSH_MTHD(push, NV507C, SET_PROCESSING,
-			  NVDEF(NV507C, SET_PROCESSING, USE_GAIN_OFS, DISABLE));
+			  NVDEF(NV507C, SET_PROCESSING, USE_GAIN_OFS, DISABLE),
+
+					SET_CONVERSION,
+			  NVVAL(NV507C, SET_CONVERSION, GAIN, 0) |
+			  NVVAL(NV507C, SET_CONVERSION, OFS, 0));
 	}
 
 	PUSH_MTHD(push, NV507C, SURFACE_SET_OFFSET(0, 0), asyw->image.offset[0] >> 8);
diff --git a/drivers/gpu/drm/nouveau/dispnv50/base827c.c b/drivers/gpu/drm/nouveau/dispnv50/base827c.c
index 18d34096f125..093d4ba6910e 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/base827c.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/base827c.c
@@ -49,7 +49,11 @@ base827c_image_set(struct nv50_wndw *wndw, struct nv50_wndw_atom *asyw)
 			  NVVAL(NV827C, SET_CONVERSION, OFS, 0x64));
 	} else {
 		PUSH_MTHD(push, NV827C, SET_PROCESSING,
-			  NVDEF(NV827C, SET_PROCESSING, USE_GAIN_OFS, DISABLE));
+			  NVDEF(NV827C, SET_PROCESSING, USE_GAIN_OFS, DISABLE),
+
+					SET_CONVERSION,
+			  NVVAL(NV827C, SET_CONVERSION, GAIN, 0) |
+			  NVVAL(NV827C, SET_CONVERSION, OFS, 0));
 	}
 
 	PUSH_MTHD(push, NV827C, SURFACE_SET_OFFSET(0, 0), asyw->image.offset[0] >> 8,


