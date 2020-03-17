Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9281880FC
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgCQLNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:13:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728963AbgCQLNC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:13:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD6D9205ED;
        Tue, 17 Mar 2020 11:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443582;
        bh=7AeRdUFqB8nXUpeMqPPG48ncKguSxkwesFV4prQw9Ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/t3RQIJrRQUedfCpFp6tMgbag+6HNok5oZo1LdbQaD/wAwLVIH7XD0Ux1TGqrF2+
         R7IgxMS3g4yZBFq2eKjE10WwksRF6cWs9iqZ8B++bblMKT5HX1HUZiYxagzWxYOG/k
         tJGEQcw0RqosLw5a3JQNJgXsJctuVOR1ybw3ibp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tina Zhang <tina.zhang@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.5 130/151] drm/i915/gvt: Fix dma-buf display blur issue on CFL
Date:   Tue, 17 Mar 2020 11:55:40 +0100
Message-Id: <20200317103335.675435099@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tina Zhang <tina.zhang@intel.com>

commit 259170cb4c84f4165a36c0b05811eb74c495412c upstream.

Commit c3b5a8430daad ("drm/i915/gvt: Enable gfx virtualiztion for CFL")
added the support on CFL. The vgpu emulation hotplug support on CFL was
supposed to be included in that patch. Without the vgpu emulation
hotplug support, the dma-buf based display gives us a blur face.

So fix this issue by adding the vgpu emulation hotplug support on CFL.

Fixes: c3b5a8430daad ("drm/i915/gvt: Enable gfx virtualiztion for CFL")
Signed-off-by: Tina Zhang <tina.zhang@intel.com>
Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20200227010041.32248-1-tina.zhang@intel.com
(cherry picked from commit 135dde8853c7e00f6002e710f7e4787ed8585c0e)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gvt/display.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gvt/display.c
+++ b/drivers/gpu/drm/i915/gvt/display.c
@@ -457,7 +457,8 @@ void intel_vgpu_emulate_hotplug(struct i
 	struct drm_i915_private *dev_priv = vgpu->gvt->dev_priv;
 
 	/* TODO: add more platforms support */
-	if (IS_SKYLAKE(dev_priv) || IS_KABYLAKE(dev_priv)) {
+	if (IS_SKYLAKE(dev_priv) || IS_KABYLAKE(dev_priv) ||
+		IS_COFFEELAKE(dev_priv)) {
 		if (connected) {
 			vgpu_vreg_t(vgpu, SFUSE_STRAP) |=
 				SFUSE_STRAP_DDID_DETECTED;


