Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67622375C65
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 22:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhEFUs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 16:48:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230104AbhEFUs7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 16:48:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620334080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=iNyKa3qN4dnX6up4J3TEfAYRRZRzTgh3ft7OZjiOwtQ=;
        b=VsuJOrBzqv8x8fmaA/K7QCwAKl7EYkYe1s4upYEq0YBj31A3buAEGuT+sCi3fWKRZsNnOp
        pCREIZAaZFHD+vFdVPqIYD+QANlxCWn8virYQIcC312vKDEkP8T3qRzgu5hDGFBDCqn36F
        8d7ygIHJQjBX5NVE670y9y5u3FI6tMs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-Zbj15EzQPIuZbIraAY5evg-1; Thu, 06 May 2021 16:47:57 -0400
X-MC-Unique: Zbj15EzQPIuZbIraAY5evg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2B91801B28;
        Thu,  6 May 2021 20:47:56 +0000 (UTC)
Received: from [172.30.42.188] (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3EBC7690F3;
        Thu,  6 May 2021 20:47:51 +0000 (UTC)
Subject: [PATCH 5.11.y, 5.10.y, 5.4.y] vfio: Depend on MMU
From:   Alex Williamson <alex.williamson@redhat.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com
Date:   Thu, 06 May 2021 14:47:51 -0600
Message-ID: <162033393037.4094195.18215062546427210332.stgit@omen>
User-Agent: StGit/1.0-8-g6af9-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

commit b2b12db53507bc97d96f6b7cb279e831e5eafb00 upstream

VFIO_IOMMU_TYPE1 does not compile with !MMU:

../drivers/vfio/vfio_iommu_type1.c: In function 'follow_fault_pfn':
../drivers/vfio/vfio_iommu_type1.c:536:22: error: implicit declaration of function 'pte_write'; did you mean 'vfs_write'? [-Werror=implicit-function-declaration]

So require it.

Suggested-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Message-Id: <0-v1-02cb5500df6e+78-vfio_no_mmu_jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: stable@vger.kernel.org # 5.11.y, 5.10.y, 5.4.y
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

The noted stable branches include upstream commit 179209fa1270
("vfio: IOMMU_API should be selected") without the follow-up commit
b2b12db53507 ("vfio: Depend on MMU"), which should have included a
Fixes: tag for the prior commit.  Without this latter commit, we're
susceptible to randconfig failures with !MMU configs.  Thanks!

 drivers/vfio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 90c0525b1e0c..67d0bf4efa16 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -22,7 +22,7 @@ config VFIO_VIRQFD
 menuconfig VFIO
 	tristate "VFIO Non-Privileged userspace driver framework"
 	select IOMMU_API
-	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM || ARM64)
+	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
 	help
 	  VFIO provides a framework for secure userspace device drivers.
 	  See Documentation/driver-api/vfio.rst for more details.


