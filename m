Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6284B499524
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392266AbiAXUu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:50:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40144 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351903AbiAXUoe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:44:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CE0D60B0B;
        Mon, 24 Jan 2022 20:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3E7C340E5;
        Mon, 24 Jan 2022 20:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057072;
        bh=xI5hEJ3lhDIHA1QI9owRidjMV8Rm3Aur9/+X8usPUKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fBI9oJzXdsIXDh561HNCaOpqcQ+uhLx++H4fuSwtnDdX8cXr0OR2/E7S+KMMaucAC
         NLl4DuesPRYkxbNwUUp8h8nGOtDfw93C0rE0DTAMPwbPV5DuBZmfVXn1IdB4dLhuTj
         +IHAtqkjAEnuRru4cNHi0RnN6uA1EoOx8FJZXya4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Nathan E. Egge" <unlord@xiph.org>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 5.15 693/846] drm/nouveau/kms/nv04: use vzalloc for nv04_display
Date:   Mon, 24 Jan 2022 19:43:30 +0100
Message-Id: <20220124184124.950008539@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
 


