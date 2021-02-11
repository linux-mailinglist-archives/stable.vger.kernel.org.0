Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D679318FF2
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 17:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbhBKQ3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 11:29:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33969 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230373AbhBKQ1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 11:27:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613060726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XQoevciACwPLARu60eJww58zrFl7HrSfeZVa0fo4e3M=;
        b=Sn4/dsFxxjb/1wqaCoiVIO+exTUhvJc69c0KRFctS6k8VLaoSXqyVAsmlvV3CBVHvVDdRh
        egPvseD0GnBuKuZ8N0senDgH04HKPTxZ7I/fropbZVTtkYoSt8sR8lDabn9PRvGn2PWZoR
        nK+z5WMM5mvSLhDVulbxmQGlrs6Tj2Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-598-KCaMI8aPOtSm_ZngdVRuxA-1; Thu, 11 Feb 2021 11:25:24 -0500
X-MC-Unique: KCaMI8aPOtSm_ZngdVRuxA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AB3D1005501;
        Thu, 11 Feb 2021 16:25:22 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-187.ams2.redhat.com [10.36.113.187])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6CEA5C1BD;
        Thu, 11 Feb 2021 16:25:20 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     stable@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH for 5.10] vdpa_sim: fix param validation in vdpasim_get_config()
Date:   Thu, 11 Feb 2021 17:25:19 +0100
Message-Id: <20210211162519.215418-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 65b709586e222fa6ffd4166ac7fdb5d5dad113ee upstream.

Before this patch, if 'offset + len' was equal to
sizeof(struct virtio_net_config), the entire buffer wasn't filled,
returning incorrect values to the caller.

Since 'vdpasim->config' type is 'struct virtio_net_config', we can
safely copy its content under this condition.

Commit 65b709586e22 ("vdpa_sim: add get_config callback in
vdpasim_dev_attr") unintentionally solved it upstream while
refactoring vdpa_sim.c to support multiple devices. But we don't want
to backport it to stable branches as it contains many changes.

Fixes: 2c53d0f64c06 ("vdpasim: vDPA device simulator")
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 6a90fdb9cbfc..8ca178d7b02f 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -572,7 +572,7 @@ static void vdpasim_get_config(struct vdpa_device *vdpa, unsigned int offset,
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 
-	if (offset + len < sizeof(struct virtio_net_config))
+	if (offset + len <= sizeof(struct virtio_net_config))
 		memcpy(buf, (u8 *)&vdpasim->config + offset, len);
 }
 
-- 
2.29.2

