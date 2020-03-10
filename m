Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0741F17FE17
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbgCJMtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:49:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728412AbgCJMtJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:49:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 545CE2468F;
        Tue, 10 Mar 2020 12:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844548;
        bh=Y4Smq8YFSQBMaSqUWzR1a0AhnVnNhOje69/N4JfaKis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n7AMHAWqxxtyex4nZwUFR8iua+f5nvrI5ijInXb9eS8yVWTijd+1NnGfxDHpGpDKW
         SmmdnlORLVA6AA54FdJ7cHW/Mu7jdIOktkMoFWhGL6rYsTqVdwWZeH6777qZSeCFWR
         t2ibeo//QQGXEHizmo3OL5HcF0l2XqXjShSQca44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/168] drm/modes: Allow DRM_MODE_ROTATE_0 when applying video mode parameters
Date:   Tue, 10 Mar 2020 13:37:51 +0100
Message-Id: <20200310123638.188087466@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 5c320b6ce7510653bce68cecf80cf5b2d67e907f ]

At the moment, only DRM_MODE_ROTATE_180 is allowed when we try to apply
the rotation from the video mode parameters. It is also useful to allow
DRM_MODE_ROTATE_0 in case there is only a reflect option in the video mode
parameter (e.g. video=540x960,reflect_x).

DRM_MODE_ROTATE_0 means "no rotation" and should therefore not require
any special handling, so we can just add it to the if condition.

Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20200117153429.54700-3-stephan@gerhold.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_client_modeset.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_client_modeset.c b/drivers/gpu/drm/drm_client_modeset.c
index 12e748b202d6f..18cb88b9105e4 100644
--- a/drivers/gpu/drm/drm_client_modeset.c
+++ b/drivers/gpu/drm/drm_client_modeset.c
@@ -952,7 +952,8 @@ bool drm_client_rotation(struct drm_mode_set *modeset, unsigned int *rotation)
 	 * depending on the hardware this may require the framebuffer
 	 * to be in a specific tiling format.
 	 */
-	if ((*rotation & DRM_MODE_ROTATE_MASK) != DRM_MODE_ROTATE_180 ||
+	if (((*rotation & DRM_MODE_ROTATE_MASK) != DRM_MODE_ROTATE_0 &&
+	     (*rotation & DRM_MODE_ROTATE_MASK) != DRM_MODE_ROTATE_180) ||
 	    !plane->rotation_property)
 		return false;
 
-- 
2.20.1



