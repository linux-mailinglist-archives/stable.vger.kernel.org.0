Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B133A002F
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234564AbhFHSkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:40:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235190AbhFHSjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:39:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 981A361421;
        Tue,  8 Jun 2021 18:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177251;
        bh=2UlRm6zG1CjQuwWEpdFSnVppc7+vgNmgOp4sokZzRAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x7yV44tvjpBz7jb9drsI+oHv5WGjDyIw0pUHmc5XupqWhL0uWff2X8coYFXrFlsBL
         bXFThq95FhK8YZmdPNYCfmSzEQL9omwneGOex+UggmyIAiz2jxTM/bjF62HwPrdUBo
         v1e0vXxUahLYEarvsdQeUUA5H8iZKUz6jZCZYOh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/58] vfio/platform: fix module_put call in error flow
Date:   Tue,  8 Jun 2021 20:26:50 +0200
Message-Id: <20210608175932.589684048@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

[ Upstream commit dc51ff91cf2d1e9a2d941da483602f71d4a51472 ]

The ->parent_module is the one that use in try_module_get. It should
also be the one the we use in module_put during vfio_platform_open().

Fixes: 32a2d71c4e80 ("vfio: platform: introduce vfio-platform-base module")
Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Message-Id: <20210518192133.59195-1-mgurtovoy@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/platform/vfio_platform_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 460760d0becf..c29fc6844f84 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -295,7 +295,7 @@ err_irq:
 	vfio_platform_regions_cleanup(vdev);
 err_reg:
 	mutex_unlock(&driver_lock);
-	module_put(THIS_MODULE);
+	module_put(vdev->parent_module);
 	return ret;
 }
 
-- 
2.30.2



