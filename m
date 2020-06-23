Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8D620633B
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388754AbgFWUTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:19:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389826AbgFWUTi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:19:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 752DD20E65;
        Tue, 23 Jun 2020 20:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943577;
        bh=JYMVwZMPCodj9GabGHXZ1GiAh0WVUm5keBK7FCpEu5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ju42yyXQKR0NkUYlPl6wg490DFN/gTi188ddo4ro6WY/leF2Gi62QuSGCW+7Gn5Uk
         tbo9Q/qfg0W2kE9kwIyBsjWaZ3R3IPgoxeeGGYjDgZQ35fQUcs8hPXae5XVeZ+9/+R
         qYc+n/IpKp6lewilhXSoUpQOkduswk4cuOzV26E4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Brun <lorenz@brun.one>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.7 447/477] drm/amdkfd: Use correct major in devcgroup check
Date:   Tue, 23 Jun 2020 21:57:24 +0200
Message-Id: <20200623195428.665403349@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Brun <lorenz@brun.one>

commit 99c7b309472787026ce52fd2bc5d00630567a872 upstream.

The existing code used the major version number of the DRM driver
instead of the device major number of the DRM subsystem for
validating access for a devices cgroup.

This meant that accesses allowed by the devices cgroup weren't
permitted and certain accesses denied by the devices cgroup were
permitted (if they matched the wrong major device number).

Signed-off-by: Lorenz Brun <lorenz@brun.one>
Fixes: 6b855f7b83d2f ("drm/amdkfd: Check against device cgroup")
Reviewed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -40,6 +40,7 @@
 #include <drm/drm_file.h>
 #include <drm/drm_drv.h>
 #include <drm/drm_device.h>
+#include <drm/drm_ioctl.h>
 #include <kgd_kfd_interface.h>
 #include <linux/swap.h>
 
@@ -1053,7 +1054,7 @@ static inline int kfd_devcgroup_check_pe
 #if defined(CONFIG_CGROUP_DEVICE) || defined(CONFIG_CGROUP_BPF)
 	struct drm_device *ddev = kfd->ddev;
 
-	return devcgroup_check_permission(DEVCG_DEV_CHAR, ddev->driver->major,
+	return devcgroup_check_permission(DEVCG_DEV_CHAR, DRM_MAJOR,
 					  ddev->render->index,
 					  DEVCG_ACC_WRITE | DEVCG_ACC_READ);
 #else


