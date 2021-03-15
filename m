Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E3433B78C
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbhCOOAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232632AbhCON7U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FD3464F40;
        Mon, 15 Mar 2021 13:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816741;
        bh=YID2P7AvDCfohH6m59JbgtIUUiOAnIQBKEJthKB0uos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQhnCoItQi/+EM667U8KW2i7V5R8eYZjQrhWVbCiXh9mT03l86OXQT0cQskISkB2B
         Qcs6EaHbSaQufrjMXcsewHW2zMKVdNmBqOWoNIcjgMHBa7V1mA7HiH9E4B/lIo2gHO
         s2P20McCFI1/kitTVRwMuDCRQrOwJHsYVZZYPs3c=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 096/306] drm/radeon: also init GEM funcs in radeon_gem_prime_import_sg_table
Date:   Mon, 15 Mar 2021 14:52:39 +0100
Message-Id: <20210315135510.902710918@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Christian König <christian.koenig@amd.com>

commit a25955ba123499d7db520175c6be59c29f9215e3 upstream.

Otherwise we will run into a NULL ptr deref.

Signed-off-by: Christian König <christian.koenig@amd.com>
Bug: https://bugzilla.kernel.org/show_bug.cgi?id=212137
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon.h       |    2 ++
 drivers/gpu/drm/radeon/radeon_gem.c   |    4 ++--
 drivers/gpu/drm/radeon/radeon_prime.c |    2 ++
 3 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -575,6 +575,8 @@ struct radeon_gem {
 	struct list_head	objects;
 };
 
+extern const struct drm_gem_object_funcs radeon_gem_object_funcs;
+
 int radeon_gem_init(struct radeon_device *rdev);
 void radeon_gem_fini(struct radeon_device *rdev);
 int radeon_gem_object_create(struct radeon_device *rdev, unsigned long size,
--- a/drivers/gpu/drm/radeon/radeon_gem.c
+++ b/drivers/gpu/drm/radeon/radeon_gem.c
@@ -43,7 +43,7 @@ struct sg_table *radeon_gem_prime_get_sg
 int radeon_gem_prime_pin(struct drm_gem_object *obj);
 void radeon_gem_prime_unpin(struct drm_gem_object *obj);
 
-static const struct drm_gem_object_funcs radeon_gem_object_funcs;
+const struct drm_gem_object_funcs radeon_gem_object_funcs;
 
 static void radeon_gem_object_free(struct drm_gem_object *gobj)
 {
@@ -227,7 +227,7 @@ static int radeon_gem_handle_lockup(stru
 	return r;
 }
 
-static const struct drm_gem_object_funcs radeon_gem_object_funcs = {
+const struct drm_gem_object_funcs radeon_gem_object_funcs = {
 	.free = radeon_gem_object_free,
 	.open = radeon_gem_object_open,
 	.close = radeon_gem_object_close,
--- a/drivers/gpu/drm/radeon/radeon_prime.c
+++ b/drivers/gpu/drm/radeon/radeon_prime.c
@@ -56,6 +56,8 @@ struct drm_gem_object *radeon_gem_prime_
 	if (ret)
 		return ERR_PTR(ret);
 
+	bo->tbo.base.funcs = &radeon_gem_object_funcs;
+
 	mutex_lock(&rdev->gem.mutex);
 	list_add_tail(&bo->list, &rdev->gem.objects);
 	mutex_unlock(&rdev->gem.mutex);


