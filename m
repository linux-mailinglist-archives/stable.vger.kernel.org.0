Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6781ACA4D
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633694AbgDPPdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:33:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898283AbgDPNlQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:41:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0C5B2076D;
        Thu, 16 Apr 2020 13:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044476;
        bh=cj9k2hAYAxhpwnoNJGeoddNVllBSWZVfbFc0dQYDt/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vf2LNXkFe5ZQ3XudJq52LiYLEWKnKW9REbWep05E3pG498uqcI8/UssWflM/GA8GV
         DLGfRSLp8hih5Pss2rcSwAE2Wz6ILubBZ4zelQNo8TxsKMm79ok84PABYOYz4kReOE
         4knCM628HbMIn8apaZsrcTA/9FggH+oPNkYEIbPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.5 206/257] vfio: platform: Switch to platform_get_irq_optional()
Date:   Thu, 16 Apr 2020 15:24:17 +0200
Message-Id: <20200416131351.833164111@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
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


