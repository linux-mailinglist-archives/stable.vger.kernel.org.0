Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C226C16E4
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbjCTPKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbjCTPJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:09:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC1A26C28
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:04:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 564A261585
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663AEC433EF;
        Mon, 20 Mar 2023 15:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324697;
        bh=FMbUqgL0lq5swos4No6ff30OTTxdiyKWbGJBYOaTgj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H8gKb0xkspu7PVJHGgsQZOV6m6Emk3ynfzR3Q2wroNjFS0wAEg2H2+KGUaoZqibtM
         eLJFyQGXbxpbVoLcBf5IZVEze+2mawm/z54PyiMRuxkedVya9RglFuey9CMMWCxyt9
         hdtUKz0FzOtZW6JmqgaWIRRQm9OqDsvTF0A0OJ90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stefano Garzarella <sgarzare@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/115] vdpa_sim: set last_used_idx as last_avail_idx in vdpasim_queue_ready
Date:   Mon, 20 Mar 2023 15:53:51 +0100
Message-Id: <20230320145450.214072736@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugenio Pérez <eperezma@redhat.com>

[ Upstream commit b4cca6d48eb3fa6f0d9caba4329b1a2b0ff67a77 ]

Starting from an used_idx different than 0 is needed in use cases like
virtual machine migration.  Not doing so and letting the caller set an
avail idx different than 0 causes destination device to try to use old
buffers that source driver already recover and are not available
anymore.

Since vdpa_sim does not support receive inflight descriptors as a
destination of a migration, let's set both avail_idx and used_idx the
same at vq start.  This is how vhost-user works in a
VHOST_SET_VRING_BASE call.

Although the simple fix is to set last_used_idx at vdpasim_set_vq_state,
it would be reset at vdpasim_queue_ready.  The last_avail_idx case is
fixed with commit 0e84f918fac8 ("vdpa_sim: not reset state in
vdpasim_queue_ready").  Since the only option is to make it equal to
last_avail_idx, adding the only change needed here.

This was discovered and tested live migrating the vdpa_sim_net device.

Fixes: 2c53d0f64c06 ("vdpasim: vDPA device simulator")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Message-Id: <20230302181857.925374-1-eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index eeda45fbba258..3ccefa58e405c 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -75,6 +75,17 @@ static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
 			  (uintptr_t)vq->device_addr);
 
 	vq->vring.last_avail_idx = last_avail_idx;
+
+	/*
+	 * Since vdpa_sim does not support receive inflight descriptors as a
+	 * destination of a migration, let's set both avail_idx and used_idx
+	 * the same at vq start.  This is how vhost-user works in a
+	 * VHOST_SET_VRING_BASE call.
+	 *
+	 * Although the simple fix is to set last_used_idx at
+	 * vdpasim_set_vq_state, it would be reset at vdpasim_queue_ready.
+	 */
+	vq->vring.last_used_idx = last_avail_idx;
 	vq->vring.notify = vdpasim_vq_notify;
 }
 
-- 
2.39.2



