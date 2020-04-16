Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D061AC862
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440396AbgDPPHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:07:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388888AbgDPNvW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:51:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF2312078B;
        Thu, 16 Apr 2020 13:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045082;
        bh=cj9k2hAYAxhpwnoNJGeoddNVllBSWZVfbFc0dQYDt/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=esEF4noHSO+Un//p2n7KYbytxCCWqk66unn5XLMsvMw2wE9g8IdP6Lw6qRLjUYUbU
         dmlb8bMFJJNvPni/WV8iTc+jWzW3dFGtkx6a59eGc49GfpI+DxaSuKySL32waCigrI
         rt4UDyFkYVi8kX0BDGuP7PLnbG8EfmGaLXBxUu2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.4 182/232] vfio: platform: Switch to platform_get_irq_optional()
Date:   Thu, 16 Apr 2020 15:24:36 +0200
Message-Id: <20200416131337.861347073@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

commit 723fe298ad85ad1278bd2312469ad14738953cc6 upstream.

Since commit 7723f4c5ecdb ("driver core: platform: Add an error
message to platform_get_irq*()"), platform_get_irq() calls dev_err()
on an error. As we enumerate all interrupts until platform_get_irq()
fails, we now systematically get a message such as:
"vfio-platform fff51000.ethernet: IRQ index 3 not found" which is
a false positive.

Let's use platform_get_irq_optional() instead.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Cc: stable@vger.kernel.org # v5.3+
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Tested-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vfio/platform/vfio_platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/vfio/platform/vfio_platform.c
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -44,7 +44,7 @@ static int get_platform_irq(struct vfio_
 {
 	struct platform_device *pdev = (struct platform_device *) vdev->opaque;
 
-	return platform_get_irq(pdev, i);
+	return platform_get_irq_optional(pdev, i);
 }
 
 static int vfio_platform_probe(struct platform_device *pdev)


