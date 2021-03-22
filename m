Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72ACE344358
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhCVMtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:49:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232770AbhCVMsN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:48:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42D3A619A2;
        Mon, 22 Mar 2021 12:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417052;
        bh=d+GzcK6TgYw3Xx8UcYKbOHfid1fVg+Z1p3hoRBKFwrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tF+B//OftljrLJqPCmqTruza+mEfeN02JiHAscU7WWWnMdAZncZWJDz8vrHvafh1X
         qgW4gYno7T7kOJ35Prre+0okoGZ2b4gG33fJRTz6ceAX/nkkmkCo0PwE4VRCInTKqu
         GaPm6M/ZkBpOB7XtmwPX9AH0Hka8oIJ8ZWqkJxn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.4 25/60] vfio: IOMMU_API should be selected
Date:   Mon, 22 Mar 2021 13:28:13 +0100
Message-Id: <20210322121923.211557234@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

commit 179209fa12709a3df8888c323b37315da2683c24 upstream.

As IOMMU_API is a kconfig without a description (eg does not show in the
menu) the correct operator is select not 'depends on'. Using 'depends on'
for this kind of symbol means VFIO is not selectable unless some other
random kconfig has already enabled IOMMU_API for it.

Fixes: cba3345cc494 ("vfio: VFIO core")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Message-Id: <1-v1-df057e0f92c3+91-vfio_arm_compile_test_jgg@nvidia.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -21,7 +21,7 @@ config VFIO_VIRQFD
 
 menuconfig VFIO
 	tristate "VFIO Non-Privileged userspace driver framework"
-	depends on IOMMU_API
+	select IOMMU_API
 	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM || ARM64)
 	help
 	  VFIO provides a framework for secure userspace device drivers.


