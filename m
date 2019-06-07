Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B37739041
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730951AbfFGPuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:50:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732152AbfFGPuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:50:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4592C2146E;
        Fri,  7 Jun 2019 15:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922623;
        bh=W6Db8lBWnXHqNrj3xxZr4wuuS7uIPEOM6o1rpghWhfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUpqTPOJXmsvM/B4JQhhKzwZgXSYzzBUvAU4dFyhNixiERbxDbstV6G7crqqAKkjh
         tUmADpo8N1z1TL7wo6MjysN3qpAi9+6eOjg1ZEz6FdJj3bJvLWBWd3uccUXFh+GOto
         KS2KVKVVrAYdUATHbKqpn/dNXoLEkBUTE/xWDBPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Deepak Rawat <drawat@vmware.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 5.1 80/85] drm: Expose "FB_DAMAGE_CLIPS" property to atomic aware user-space only
Date:   Fri,  7 Jun 2019 17:40:05 +0200
Message-Id: <20190607153857.802928084@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deepak Rawat <drawat@vmware.com>

commit c8f005684c98f4d9942baec13ad98054dbf312a0 upstream.

Plane property "FB_DAMAGE_CLIPS" can only be used by atomic aware
user-space, so no point exposing it otherwise.

Cc: <stable@vger.kernel.org>
Signed-off-by: Deepak Rawat <drawat@vmware.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Fixes: d3b21767821e ("drm: Add a new plane property to send damage during plane update")
Link: https://patchwork.freedesktop.org/patch/msgid/20190415172814.9840-1-drawat@vmware.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_mode_config.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_mode_config.c
+++ b/drivers/gpu/drm/drm_mode_config.c
@@ -297,8 +297,9 @@ static int drm_mode_create_standard_prop
 		return -ENOMEM;
 	dev->mode_config.prop_crtc_id = prop;
 
-	prop = drm_property_create(dev, DRM_MODE_PROP_BLOB, "FB_DAMAGE_CLIPS",
-				   0);
+	prop = drm_property_create(dev,
+			DRM_MODE_PROP_ATOMIC | DRM_MODE_PROP_BLOB,
+			"FB_DAMAGE_CLIPS", 0);
 	if (!prop)
 		return -ENOMEM;
 	dev->mode_config.prop_fb_damage_clips = prop;


