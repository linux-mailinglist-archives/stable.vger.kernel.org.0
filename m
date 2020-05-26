Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA56E1E2DE3
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392542AbgEZTZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:25:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391691AbgEZTHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:07:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 036BE208A7;
        Tue, 26 May 2020 19:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520021;
        bh=sfEmZzYhPeVOloIwz/2tq/ZwALlDcCqLPWzA6mRKkUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YRCQk5LEIkComvvvm+RuWnhBoVshRlDiLvexxzM23LAB6SqFN7+O6v/16C9i3i8lC
         TwMYjqV1AO8eqW8FreyAk26YpxaFwDjKPQQ74i+mXtVCthWpZQlR/nwyh1cFnOpqFn
         pl+0tAz4g8LR3/cdDSRBmRHUMgU3enTj92HG6+Lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/111] vhost/vsock: fix packet delivery order to monitoring devices
Date:   Tue, 26 May 2020 20:52:45 +0200
Message-Id: <20200526183935.318980223@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 107bc0766b9feb5113074c753735a3f115c2141f ]

We want to deliver packets to monitoring devices before it is
put in the virtqueue, to avoid that replies can appear in the
packet capture before the transmitted packet.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vsock.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 6c089f655707..ca68a27b98ed 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -181,14 +181,14 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			break;
 		}
 
-		vhost_add_used(vq, head, sizeof(pkt->hdr) + payload_len);
-		added = true;
-
-		/* Deliver to monitoring devices all correctly transmitted
-		 * packets.
+		/* Deliver to monitoring devices all packets that we
+		 * will transmit.
 		 */
 		virtio_transport_deliver_tap_pkt(pkt);
 
+		vhost_add_used(vq, head, sizeof(pkt->hdr) + payload_len);
+		added = true;
+
 		pkt->off += payload_len;
 		total_len += payload_len;
 
-- 
2.25.1



