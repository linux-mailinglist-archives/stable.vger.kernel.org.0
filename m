Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBD78126BB4
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfLSS6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:58:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730273AbfLSSyz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:54:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9334D206EC;
        Thu, 19 Dec 2019 18:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781695;
        bh=jM4AaFsdUm+PCgilD4TxVD2a/AGAmFNdPl4DlFC+EvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nwpdwecqpy74LXwL7VivJDnDmds/T6W3ciX2Cd5CHPGlxtUEaMVE2QAn+23C5M1A4
         6cMV3h4eDytV5X07Eqxy9lMTX65fcum3wX74yw1XIBYk6gqzBRMlTPPtt/qrYlkgGz
         UfC4+PVqHLt5eaDOjy/qBD/ctQXqFX889KGQ6zM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.4 43/80] drm/panfrost: Fix a race in panfrost_ioctl_madvise()
Date:   Thu, 19 Dec 2019 19:34:35 +0100
Message-Id: <20191219183111.174687637@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@collabora.com>

commit 70cc77952efebf6722d483cb83cfb563ac9768db upstream.

If 2 threads change the MADVISE property of the same BO in parallel we
might end up with an shmem->madv value that's inconsistent with the
presence of the BO in the shrinker list.

The easiest solution to fix that is to protect the
drm_gem_shmem_madvise() call with the shrinker lock.

Fixes: 013b65101315 ("drm/panfrost: Add madvise and shrinker support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Acked-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20191129135908.2439529-3-boris.brezillon@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/panfrost/panfrost_drv.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -347,20 +347,19 @@ static int panfrost_ioctl_madvise(struct
 		return -ENOENT;
 	}
 
+	mutex_lock(&pfdev->shrinker_lock);
 	args->retained = drm_gem_shmem_madvise(gem_obj, args->madv);
 
 	if (args->retained) {
 		struct panfrost_gem_object *bo = to_panfrost_bo(gem_obj);
 
-		mutex_lock(&pfdev->shrinker_lock);
-
 		if (args->madv == PANFROST_MADV_DONTNEED)
-			list_add_tail(&bo->base.madv_list, &pfdev->shrinker_list);
+			list_add_tail(&bo->base.madv_list,
+				      &pfdev->shrinker_list);
 		else if (args->madv == PANFROST_MADV_WILLNEED)
 			list_del_init(&bo->base.madv_list);
-
-		mutex_unlock(&pfdev->shrinker_lock);
 	}
+	mutex_unlock(&pfdev->shrinker_lock);
 
 	drm_gem_object_put_unlocked(gem_obj);
 	return 0;


