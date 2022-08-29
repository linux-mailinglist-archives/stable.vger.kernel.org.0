Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB045A43CB
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 09:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiH2Hev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 03:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiH2Heu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 03:34:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736BC2725
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 00:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661758488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ivp8SkSbzWYeukb9RmMR/+ypBwoHgCA1ggb1pX9wCGY=;
        b=Gk5lcrC+7jmygkyFrwqu1L23/5QSIyOiphSuh3ybUl58iX0PT7pqwVgIjHzL3WS5jLKord
        GpXJIf3m1Jk8KK+nckeWG3viBoY1t9pMiNZjKpHcIxGQjuzqCcJutKAGyZCy+Ql/HoA/D7
        GC786MKzkf/gC3z6n9fh6LQY4AERubs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-XdSkkRb2Pn6saeyjF857mA-1; Mon, 29 Aug 2022 03:34:43 -0400
X-MC-Unique: XdSkkRb2Pn6saeyjF857mA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E77B185A7B2;
        Mon, 29 Aug 2022 07:34:43 +0000 (UTC)
Received: from max-t490s.redhat.com (unknown [10.39.208.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAA65492C3B;
        Mon, 29 Aug 2022 07:34:40 +0000 (UTC)
From:   Maxime Coquelin <maxime.coquelin@redhat.com>
To:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, elic@nvidia.com,
        guanjun@linux.alibaba.com, parav@nvidia.com,
        gautam.dawar@xilinx.com, dan.carpenter@oracle.com,
        xieyongji@bytedance.com, jasowang@redhat.com, mst@redhat.com
Cc:     Maxime Coquelin <maxime.coquelin@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] vduse: prevent uninitialized memory accesses
Date:   Mon, 29 Aug 2022 09:34:24 +0200
Message-Id: <20220829073424.5677-1-maxime.coquelin@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the VDUSE application provides a smaller config space
than the driver expects, the driver may use uninitialized
memory from the stack.

This patch prevents it by initializing the buffer passed by
the driver to store the config value.

This fix addresses CVE-2022-2308.

Cc: xieyongji@bytedance.com
Cc: stable@vger.kernel.org # v5.15+
Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Maxime Coquelin <maxime.coquelin@redhat.com>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 41c0b29739f1..35dceee3ed56 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -673,10 +673,15 @@ static void vduse_vdpa_get_config(struct vdpa_device *vdpa, unsigned int offset,
 {
 	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
 
-	if (offset > dev->config_size ||
-	    len > dev->config_size - offset)
+	/* Initialize the buffer in case of partial copy. */
+	memset(buf, 0, len);
+
+	if (offset > dev->config_size)
 		return;
 
+	if (len > dev->config_size - offset)
+		len = dev->config_size - offset;
+
 	memcpy(buf, dev->config + offset, len);
 }
 
-- 
2.37.2

