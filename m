Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D223CA9FC
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243299AbhGOTLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:11:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242245AbhGOTIt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:08:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF21A613DF;
        Thu, 15 Jul 2021 19:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375874;
        bh=LlINakK7vPhAHS2AjT7/SVE6Zsa9OiC3yVd1oojOPFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQ9SZCMMORha31221Uy0QZZQKmZfWDnkHM8h6oAJZz1aMJjCWV70hM7UJ3ISqm8KD
         3INYxWdXEoFaFeVfXsjwAUYs7BDmhwoTFsEG2/iIRhfRqMtJSYzjg0Bykizw8y7068
         +mTuVNLdGFwaXaHIzoIZe5nw9WYHTVkDguz30RO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 008/266] drm/vc4: fix argument ordering in vc4_crtc_get_margins()
Date:   Thu, 15 Jul 2021 20:36:03 +0200
Message-Id: <20210715182615.341158690@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
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
index a7500716cf3f..5dceadc61600 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.h
+++ b/drivers/gpu/drm/vc4/vc4_drv.h
@@ -825,7 +825,7 @@ void vc4_crtc_destroy_state(struct drm_crtc *crtc,
 void vc4_crtc_reset(struct drm_crtc *crtc);
 void vc4_crtc_handle_vblank(struct vc4_crtc *crtc);
 void vc4_crtc_get_margins(struct drm_crtc_state *state,
-			  unsigned int *right, unsigned int *left,
+			  unsigned int *left, unsigned int *right,
 			  unsigned int *top, unsigned int *bottom);
 
 /* vc4_debugfs.c */
-- 
2.30.2



