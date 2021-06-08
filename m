Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF6839FF59
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbhFHScZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:32:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234226AbhFHSbs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:31:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CA15613AE;
        Tue,  8 Jun 2021 18:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623176981;
        bh=PvTMYSM//QiSbcO7Cf3Y6Xndh6R5qxxdqFOK/OzrvbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=18kM63oXwWbE05T8mA5Oyr0JjmAivbMo7rMWZKzd9TEaywLN7RTqSntxzeFeKh0n9
         ybqNd3H7nofXUpYCzspXlmpP/t3KBgqoGwixc59AnfFqdvhx7338D4ZcqDosaDzqjx
         yV58bJR6Qc2/Qic4kBfNEmS2HvwTSrvkBgDe21Qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 06/29] vfio/platform: fix module_put call in error flow
Date:   Tue,  8 Jun 2021 20:27:00 +0200
Message-Id: <20210608175928.024686925@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175927.821075974@linuxfoundation.org>
References: <20210608175927.821075974@linuxfoundation.org>
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
index d143d08c4f0f..9b1b6c1e218d 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -288,7 +288,7 @@ err_irq:
 	vfio_platform_regions_cleanup(vdev);
 err_reg:
 	mutex_unlock(&driver_lock);
-	module_put(THIS_MODULE);
+	module_put(vdev->parent_module);
 	return ret;
 }
 
-- 
2.30.2



