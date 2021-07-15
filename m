Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0C33CA5CE
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbhGOSol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:44:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233183AbhGOSoe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:44:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDBF4613CF;
        Thu, 15 Jul 2021 18:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374500;
        bh=z4nzh3+1uDEn4WWcMyoGo44T9Zo/R3NIjFIN05kUkv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=idnWsvkTCWAIDPElZMeQo3q3VVQUXSWH77FAWTfNGb2L+baZ5BhTVm/KZCsMiJogJ
         ENHoOJbU+RNPoe8oP9PhMlA4M4UIvTQU9Jg53DtgCvK6/IyOBHN03RiitQtrw9OVvz
         WZZtlQshf92B6Ow7FazedD6Wdc8ejZTIK1t5ftRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 004/122] drm/vc4: fix argument ordering in vc4_crtc_get_margins()
Date:   Thu, 15 Jul 2021 20:37:31 +0200
Message-Id: <20210715182449.627911980@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e590c2b03a6143ba93ddad306bc9eaafa838c020 ]

Cppcheck complains that the declaration doesn't match the function
definition.  Obviously "left" should come before "right".  The caller
and the function implementation are done this way, it's just the
declaration which is wrong so this doesn't affect runtime.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/YH/720FD978TPhHp@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_drv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_drv.h b/drivers/gpu/drm/vc4/vc4_drv.h
index 6627b20c99e9..3ddaa817850d 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.h
+++ b/drivers/gpu/drm/vc4/vc4_drv.h
@@ -750,7 +750,7 @@ bool vc4_crtc_get_scanoutpos(struct drm_device *dev, unsigned int crtc_id,
 void vc4_crtc_handle_vblank(struct vc4_crtc *crtc);
 void vc4_crtc_txp_armed(struct drm_crtc_state *state);
 void vc4_crtc_get_margins(struct drm_crtc_state *state,
-			  unsigned int *right, unsigned int *left,
+			  unsigned int *left, unsigned int *right,
 			  unsigned int *top, unsigned int *bottom);
 
 /* vc4_debugfs.c */
-- 
2.30.2



