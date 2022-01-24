Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9D049A353
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365142AbiAXXuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:50:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48032 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455782AbiAXVgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:36:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46D50B81233;
        Mon, 24 Jan 2022 21:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AD5C340E4;
        Mon, 24 Jan 2022 21:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060173;
        bh=xI5hEJ3lhDIHA1QI9owRidjMV8Rm3Aur9/+X8usPUKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9gSHT6RFJqkagUTkO5V6rLHtk5AikfZPhghrWzP6PU/+q6zkiUpvw3Fl2YtFy2fK
         Wi4BI50lf3tvgM3C53BkJeWkTdnv4+mJSbxgeA0m7+FGbbPzwZgOfcIhF/uyr/mA8S
         Ly0FJeTmEDCFW+vz7lnjwSSWJHDnEMvpwg1sg+3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Nathan E. Egge" <unlord@xiph.org>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 5.16 0862/1039] drm/nouveau/kms/nv04: use vzalloc for nv04_display
Date:   Mon, 24 Jan 2022 19:44:11 +0100
Message-Id: <20220124184154.268640046@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilia Mirkin <imirkin@alum.mit.edu>

commit bd6e07e72f37f34535bec7eebc807e5fcfe37b43 upstream.

The struct is giant, and triggers an order-7 allocation (512K). There is
no reason for this to be kmalloc-type memory, so switch to vmalloc. This
should help loading nouveau on low-memory and/or long-running systems.

Reported-by: Nathan E. Egge <unlord@xiph.org>
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://gitlab.freedesktop.org/drm/nouveau/-/merge_requests/10
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/dispnv04/disp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/nouveau/dispnv04/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv04/disp.c
@@ -205,7 +205,7 @@ nv04_display_destroy(struct drm_device *
 	nvif_notify_dtor(&disp->flip);
 
 	nouveau_display(dev)->priv = NULL;
-	kfree(disp);
+	vfree(disp);
 
 	nvif_object_unmap(&drm->client.device.object);
 }
@@ -223,7 +223,7 @@ nv04_display_create(struct drm_device *d
 	struct nv04_display *disp;
 	int i, ret;
 
-	disp = kzalloc(sizeof(*disp), GFP_KERNEL);
+	disp = vzalloc(sizeof(*disp));
 	if (!disp)
 		return -ENOMEM;
 


