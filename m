Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD8E4F3003
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236651AbiDEI2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239618AbiDEIUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F4D1C6;
        Tue,  5 Apr 2022 01:17:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 282E6B81B92;
        Tue,  5 Apr 2022 08:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFC7C385A1;
        Tue,  5 Apr 2022 08:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146656;
        bh=TRFzbUO7n22VZ945pdzrqwka/ULHwpD2i4aPT2EBJnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xYcvcWCEByJwjjJQnlXe7zqYU1sxxTKL90/PRQr6mZjJIwV32faDi8j9oRwXgGEKi
         uuGdjgYDq3KFKNDu4Js/rjtmymVr7dqIiAUa7iltlg7vpClMVH3HE9TkDYcT1P8RYF
         VUXd2SRTzQQAhvJ/fvQLFmjB+GVjcodIN7sIOU94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0802/1126] vsock/virtio: read the negotiated features before using VQs
Date:   Tue,  5 Apr 2022 09:25:49 +0200
Message-Id: <20220405070431.110089321@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit c1011c0b3a9c8d2065f425407475cbcc812540b7 ]

Complete the driver configuration, reading the negotiated features,
before using the VQs in the virtio_vsock_probe().

Fixes: 53efbba12cc7 ("virtio/vsock: enable SEQPACKET for transport")
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 3e5513934c9f..3954d3be9083 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -622,6 +622,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
 	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
 
+	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
+		vsock->seqpacket_allow = true;
+
 	vdev->priv = vsock;
 
 	mutex_lock(&vsock->tx_lock);
@@ -638,9 +641,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	vsock->event_run = true;
 	mutex_unlock(&vsock->event_lock);
 
-	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
-		vsock->seqpacket_allow = true;
-
 	rcu_assign_pointer(the_virtio_vsock, vsock);
 
 	mutex_unlock(&the_virtio_vsock_mutex);
-- 
2.34.1



