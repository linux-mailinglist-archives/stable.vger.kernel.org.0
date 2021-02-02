Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A81530CC9F
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbhBBUCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:02:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:35064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232736AbhBBNoi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:44:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B48264F6F;
        Tue,  2 Feb 2021 13:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273224;
        bh=WZAX6xb/MG6Cuh3DT7zUEAnMLWUeVRVdLWKn39TkcWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFQsW7JZzAWN6eVtGoa/CBVefh9Q7mIT0t1i7p17/uxaHEw8DtSnlrMkgv8o0bF3n
         gXxWnRsSBfmIcxiavvaQ5ZXX928lzZId2NrgMZrsIdhUFx6wBmyaDKi6g093wzIHCm
         V69+W1TR2FR2R05FcswFDnFE9q8byrv9px1NGgBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Jones <jajones@nvidia.com>,
        Martin Peres <martin.peres@free.fr>,
        Jeremy Cline <jcline@redhat.com>,
        Simon Ser <contact@emersion.fr>, Lyude Paul <lyude@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 5.10 026/142] drivers/nouveau/kms/nv50-: Reject format modifiers for cursor planes
Date:   Tue,  2 Feb 2021 14:36:29 +0100
Message-Id: <20210202132958.790713871@linuxfoundation.org>
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

From: Lyude Paul <lyude@redhat.com>

commit 7c6d659868c77da9b518f32348160340dcdfa008 upstream.

Nvidia hardware doesn't actually support using tiling formats with the
cursor plane, only linear is allowed. In the future, we should write a
testcase for this.

Fixes: c586f30bf74c ("drm/nouveau/kms: Add format mod prop to base/ovly/nvdisp")
Cc: James Jones <jajones@nvidia.com>
Cc: Martin Peres <martin.peres@free.fr>
Cc: Jeremy Cline <jcline@redhat.com>
Cc: Simon Ser <contact@emersion.fr>
Cc: <stable@vger.kernel.org> # v5.8+
Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Simon Ser <contact@emersion.fr>
Reviewed-by: James Jones <jajones@nvidia.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/dispnv50/wndw.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/nouveau/dispnv50/wndw.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
@@ -702,6 +702,11 @@ nv50_wndw_init(struct nv50_wndw *wndw)
 	nvif_notify_get(&wndw->notify);
 }
 
+static const u64 nv50_cursor_format_modifiers[] = {
+	DRM_FORMAT_MOD_LINEAR,
+	DRM_FORMAT_MOD_INVALID,
+};
+
 int
 nv50_wndw_new_(const struct nv50_wndw_func *func, struct drm_device *dev,
 	       enum drm_plane_type type, const char *name, int index,
@@ -713,6 +718,7 @@ nv50_wndw_new_(const struct nv50_wndw_fu
 	struct nvif_mmu *mmu = &drm->client.mmu;
 	struct nv50_disp *disp = nv50_disp(dev);
 	struct nv50_wndw *wndw;
+	const u64 *format_modifiers;
 	int nformat;
 	int ret;
 
@@ -728,10 +734,13 @@ nv50_wndw_new_(const struct nv50_wndw_fu
 
 	for (nformat = 0; format[nformat]; nformat++);
 
-	ret = drm_universal_plane_init(dev, &wndw->plane, heads, &nv50_wndw,
-				       format, nformat,
-				       nouveau_display(dev)->format_modifiers,
-				       type, "%s-%d", name, index);
+	if (type == DRM_PLANE_TYPE_CURSOR)
+		format_modifiers = nv50_cursor_format_modifiers;
+	else
+		format_modifiers = nouveau_display(dev)->format_modifiers;
+
+	ret = drm_universal_plane_init(dev, &wndw->plane, heads, &nv50_wndw, format, nformat,
+				       format_modifiers, type, "%s-%d", name, index);
 	if (ret) {
 		kfree(*pwndw);
 		*pwndw = NULL;


