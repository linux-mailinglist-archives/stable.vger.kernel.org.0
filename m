Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6E73BCECF
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbhGFL1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:27:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234527AbhGFLYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:24:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17EB161C81;
        Tue,  6 Jul 2021 11:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570316;
        bh=LlINakK7vPhAHS2AjT7/SVE6Zsa9OiC3yVd1oojOPFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e1HAEE/EwbQg00paw0PVuhF6kK2Zv0LnLuuyMjIw8m2HY4U1up+n5Lcb7UT0V4eLZ
         Oa3qbvaKfZvCTsKX4dO+T62gar/3A9Czw6acLhHey3PCYjSOF2z6TRDpProX5eXgar
         s+CAQTOw/G0autAXwSbXYrp44/zMs+LrY6FmqHU+mMSLivm2g9HQtJhnivqeJEtF8D
         KFJFaPEOnnSt/5HlfqKNNy9udpP+v8gGeswOQNsEKknqkaqhxY9wG6bf9hOkPyBO1g
         WanPF3K03JF5PQuuIljNdY2SkSrSmuq3UAvjJhz/+okQ/MADtkcCiLeHamfRnBsLXv
         osa7FBuIu0K4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        kernel test robot <lkp@intel.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 007/160] drm/vc4: fix argument ordering in vc4_crtc_get_margins()
Date:   Tue,  6 Jul 2021 07:15:53 -0400
Message-Id: <20210706111827.2060499-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

