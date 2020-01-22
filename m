Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05E9C1448F5
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 01:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgAVAe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 19:34:57 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41806 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726876AbgAVAe4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 19:34:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579653295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MJ4SkbpxcRrIWzJPxY9eWD1fiCB6FFP/Gm3vsvFDakM=;
        b=Z5aA4G0cZscldsMCYlOzawFveSCxgB88elET6MNApui+yDxE2ZOzOAZ3NTT2kpRT09f+ab
        D/GgQaDhBNbP7TPkBL55N2gl4YoNqqh1dmWjtxWHz+6XZam9t48AsAk0uSDzIG5PVOcdDa
        /wHjP5BjZUU+/z9B1HHzbqKAo86g6lw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-dI-WQVENOiO03h8Q7VUfgQ-1; Tue, 21 Jan 2020 19:34:40 -0500
X-MC-Unique: dI-WQVENOiO03h8Q7VUfgQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE5251882CC2;
        Wed, 22 Jan 2020 00:34:38 +0000 (UTC)
Received: from cantor.redhat.com (ovpn-118-59.phx2.redhat.com [10.3.118.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 794937DB34;
        Wed, 22 Jan 2020 00:34:38 +0000 (UTC)
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     iommu@lists.linux-foundation.org
Cc:     Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iommu/vt-d: call __dmar_remove_one_dev_info with valid pointer
Date:   Tue, 21 Jan 2020 17:34:26 -0700
Message-Id: <20200122003426.16079-1-jsnitsel@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It is possible for archdata.iommu to be set to
DEFER_DEVICE_DOMAIN_INFO or DUMMY_DEVICE_DOMAIN_INFO so check for
those values before calling __dmar_remove_one_dev_info. Without a
check it can result in a null pointer dereference. This has been seen
while booting a kdump kernel on an HP dl380 gen9.

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: stable@vger.kernel.org # 5.3+
Cc: linux-kernel@vger.kernel.org
Fixes: ae23bfb68f28 ("iommu/vt-d: Detach domain before using a private on=
e")
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
---
 drivers/iommu/intel-iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 1801f0aaf013..932267f49f9a 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -5163,7 +5163,8 @@ static void dmar_remove_one_dev_info(struct device =
*dev)
=20
 	spin_lock_irqsave(&device_domain_lock, flags);
 	info =3D dev->archdata.iommu;
-	if (info)
+	if (info && info !=3D DEFER_DEVICE_DOMAIN_INFO
+	    && info !=3D DUMMY_DEVICE_DOMAIN_INFO)
 		__dmar_remove_one_dev_info(info);
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 }
--=20
2.24.0

