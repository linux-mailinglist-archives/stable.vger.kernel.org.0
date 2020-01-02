Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C96F812F0DF
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgABWS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:18:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:33636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728334AbgABWSZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:18:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91A8821582;
        Thu,  2 Jan 2020 22:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003505;
        bh=ZRzUaS7TbHRkip6Y5V7m23bnGrNRf3b6ulStmFnU4HQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRYfJjzoLxqB1fED8jOqOgjS49pK67+DX4Iihb1s1J5a05oF/X5u3EKo72Lg/WK2r
         RVm3RxYFbsJtpUDGI1TYFIiZYYHmL7t5XOpQ+Z8WCp/NrbLXSJbMVIrojJaLkb979s
         DD0a/LVTVlvm8pOTKVfv26goh5+hQwzgyi5Le73s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 189/191] vhost/vsock: accept only packets with the right dst_cid
Date:   Thu,  2 Jan 2020 23:07:51 +0100
Message-Id: <20200102215849.847621468@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 8a3cc29c316c17de590e3ff8b59f3d6cbfd37b0a ]

When we receive a new packet from the guest, we check if the
src_cid is correct, but we forgot to check the dst_cid.

The host should accept only packets where dst_cid is
equal to the host CID.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vsock.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -437,7 +437,9 @@ static void vhost_vsock_handle_tx_kick(s
 		virtio_transport_deliver_tap_pkt(pkt);
 
 		/* Only accept correctly addressed packets */
-		if (le64_to_cpu(pkt->hdr.src_cid) == vsock->guest_cid)
+		if (le64_to_cpu(pkt->hdr.src_cid) == vsock->guest_cid &&
+		    le64_to_cpu(pkt->hdr.dst_cid) ==
+		    vhost_transport_get_local_cid())
 			virtio_transport_recv_pkt(pkt);
 		else
 			virtio_transport_free_pkt(pkt);


