Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 246BA171E43
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388416AbgB0OJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:09:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:47678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388414AbgB0OJl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:09:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2513F20801;
        Thu, 27 Feb 2020 14:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812580;
        bh=iqOeOL/bKZf9/godjGAaOOR5QSWW8eIYnWcqwqh9Ias=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tcUKsZq2hVcVjILf6tn0OtJqFrNdd9oOJmurQAdlWeEITKEty0FyNni3Gkg29zJPK
         8b4PqK3DO6eIe8BmWEyNz6xdM0wbDYN3r7/yPxJ4IJUICfVPUxFMa53z/xUCDuOB7N
         IBuglx9Fhrs8pMyh167+Ew59WEy5HaxjT00FMRek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 5.4 073/135] drm/nouveau/kms/gv100-: Re-set LUT after clearing for modesets
Date:   Thu, 27 Feb 2020 14:36:53 +0100
Message-Id: <20200227132240.359549658@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit f287d3d19769b1d22cba4e51fa0487f2697713c9 upstream.

While certain modeset operations on gv100+ need us to temporarily
disable the LUT, we make the mistake of sometimes neglecting to
reprogram the LUT after such modesets. In particular, moving a head from
one encoder to another seems to trigger this quite often. GV100+ is very
picky about having a LUT in most scenarios, so this causes the display
engine to hang with the following error code:

disp: chid 1 stat 00005080 reason 5 [INVALID_STATE] mthd 0200 data
00000001 code 0000002d)

So, fix this by always re-programming the LUT if we're clearing it in a
state where the wndw is still visible, and has a XLUT handle programmed.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: facaed62b4cb ("drm/nouveau/kms/gv100: initial support")
Cc: <stable@vger.kernel.org> # v4.18+
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/dispnv50/wndw.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/nouveau/dispnv50/wndw.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
@@ -451,6 +451,8 @@ nv50_wndw_atomic_check(struct drm_plane
 		asyw->clr.ntfy = armw->ntfy.handle != 0;
 		asyw->clr.sema = armw->sema.handle != 0;
 		asyw->clr.xlut = armw->xlut.handle != 0;
+		if (asyw->clr.xlut && asyw->visible)
+			asyw->set.xlut = asyw->xlut.handle != 0;
 		asyw->clr.csc  = armw->csc.valid;
 		if (wndw->func->image_clr)
 			asyw->clr.image = armw->image.handle[0] != 0;


