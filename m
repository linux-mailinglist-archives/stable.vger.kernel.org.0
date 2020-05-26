Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956101E2E92
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390769AbgEZTAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:00:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389533AbgEZTAg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:00:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 737042084C;
        Tue, 26 May 2020 19:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519635;
        bh=LsS3+PSIvW8Kau/n+6pr/cwnVZ7ma7hnw6/ulEOkfCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w0Sk+nD5khnplevED6DjMTEP+pm53EvLJJV8taNRQnxPV7SEoVg+F2crrw3ArYsEP
         ugjmnZhW8eYniN4JeYlNPTXPnSmXAWlpqqRHgBsPDgk2m/ahrHLSCmMyr+UtvKJr07
         3k/xXcObZeXzKSRCUSiAgutcBpnZYnl7ehu6xwPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 17/59] vhost/vsock: fix packet delivery order to monitoring devices
Date:   Tue, 26 May 2020 20:53:02 +0200
Message-Id: <20200526183913.796883425@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183907.123822792@linuxfoundation.org>
References: <20200526183907.123822792@linuxfoundation.org>
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
index 834e88e20550..3f2f34ebf51f 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -182,14 +182,14 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
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



