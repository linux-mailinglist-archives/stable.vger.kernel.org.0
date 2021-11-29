Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E512461E28
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379221AbhK2SdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:33:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35732 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379224AbhK2SbD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:31:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB907B815D2;
        Mon, 29 Nov 2021 18:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C6CC53FC7;
        Mon, 29 Nov 2021 18:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210463;
        bh=xLEXFZDlt93SawD6InGVDuoCHOOS/eIZKQ5fge2jGQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1cz+nkfZQH+wUzszY6bwNJutbklbKmyFSUGc5KsSmH7NjOwheZuMc75G9oVP4961y
         /TfpwIFcpScLRMQfmRKynyxX8OjnmVcoZQNv8wTauxco6qQL6v/SYXzkx+xWJKaK6E
         PGkWC+CCrlKY4KeEtutINNPyrFZdD6yhgv/2Grbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH 5.4 78/92] vhost/vsock: fix incorrect used length reported to the guest
Date:   Mon, 29 Nov 2021 19:18:47 +0100
Message-Id: <20211129181710.008958085@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

commit 49d8c5ffad07ca014cfae72a1b9b8c52b6ad9cb8 upstream.

The "used length" reported by calling vhost_add_used() must be the
number of bytes written by the device (using "in" buffers).

In vhost_vsock_handle_tx_kick() the device only reads the guest
buffers (they are all "out" buffers), without writing anything,
so we must pass 0 as "used length" to comply virtio spec.

Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
Cc: stable@vger.kernel.org
Reported-by: Halil Pasic <pasic@linux.ibm.com>
Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20211122163525.294024-2-sgarzare@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vsock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -491,7 +491,7 @@ static void vhost_vsock_handle_tx_kick(s
 			virtio_transport_free_pkt(pkt);
 
 		len += sizeof(pkt->hdr);
-		vhost_add_used(vq, head, len);
+		vhost_add_used(vq, head, 0);
 		total_len += len;
 		added = true;
 	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));


