Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936DF47ADEE
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239628AbhLTO4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:56:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45278 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236567AbhLTOxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:53:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33C51611A4;
        Mon, 20 Dec 2021 14:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DFEC36AE7;
        Mon, 20 Dec 2021 14:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012033;
        bh=yZxRJIUhIMqQCSxsdSnLyqZUmctDgTSnhonj7nzkSXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YEDu0sdJ2503w1VUUCyaANQmjyoBS6wuQHBg7asz1g76wXO6dCte+EtoazspImsTS
         RYrSWLH5e6laRZthHPGhXyaeD7S3tzdP+klovCKzqqN5Y1sZkZ+0+xXDiQIONy8bmc
         yC8Bn2NXr1IBsXego+j7s2N1T0D4PazCGODTUbwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/177] virtio/vsock: fix the transport to work with VMADDR_CID_ANY
Date:   Mon, 20 Dec 2021 15:33:26 +0100
Message-Id: <20211220143041.982864663@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Wang <wei.w.wang@intel.com>

[ Upstream commit 1db8f5fc2e5c66a5c51e1f6488e0ba7d45c29ae4 ]

The VMADDR_CID_ANY flag used by a socket means that the socket isn't bound
to any specific CID. For example, a host vsock server may want to be bound
with VMADDR_CID_ANY, so that a guest vsock client can connect to the host
server with CID=VMADDR_CID_HOST (i.e. 2), and meanwhile, a host vsock
client can connect to the same local server with CID=VMADDR_CID_LOCAL
(i.e. 1).

The current implementation sets the destination socket's svm_cid to a
fixed CID value after the first client's connection, which isn't an
expected operation. For example, if the guest client first connects to the
host server, the server's svm_cid gets set to VMADDR_CID_HOST, then other
host clients won't be able to connect to the server anymore.

Reproduce steps:
1. Run the host server:
   socat VSOCK-LISTEN:1234,fork -
2. Run a guest client to connect to the host server:
   socat - VSOCK-CONNECT:2:1234
3. Run a host client to connect to the host server:
   socat - VSOCK-CONNECT:1:1234

Without this patch, step 3. above fails to connect, and socat complains
"socat[1720] E connect(5, AF=40 cid:1 port:1234, 16): Connection
reset by peer".
With this patch, the above works well.

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Link: https://lore.kernel.org/r/20211126011823.1760-1-wei.w.wang@intel.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 59ee1be5a6dd3..ec2c2afbf0d06 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1299,7 +1299,8 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 	space_available = virtio_transport_space_update(sk, pkt);
 
 	/* Update CID in case it has changed after a transport reset event */
-	vsk->local_addr.svm_cid = dst.svm_cid;
+	if (vsk->local_addr.svm_cid != VMADDR_CID_ANY)
+		vsk->local_addr.svm_cid = dst.svm_cid;
 
 	if (space_available)
 		sk->sk_write_space(sk);
-- 
2.33.0



