Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87F7344214
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhCVMim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231877AbhCVMhG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:37:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FDBF61990;
        Mon, 22 Mar 2021 12:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416591;
        bh=d+GzcK6TgYw3Xx8UcYKbOHfid1fVg+Z1p3hoRBKFwrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UESuWc6S5ImOp3h05MU+hEzO96jiBBmX1CZHQ9bkigGD3gexczmfrX4DyOIhG0dmQ
         BR8AHlMt7K7yh5V/x+kiKe7lYyVJi5Yi+4TlO51yIPZgM6UXviGggZkeJ9NxyZoRZE
         coBIJJsSoedaGBM59UlXRWNCOBx8R6fp595o4SZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.10 046/157] vfio: IOMMU_API should be selected
Date:   Mon, 22 Mar 2021 13:26:43 +0100
Message-Id: <20210322121935.209960366@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
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


