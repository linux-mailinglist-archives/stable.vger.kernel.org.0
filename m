Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D222C07A5
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732980AbgKWMmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:42:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:55864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732975AbgKWMmu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:42:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F0F52065E;
        Mon, 23 Nov 2020 12:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135369;
        bh=a2aHZVi2/AC8uKmNZH1jKDGXkdvpT2rflTqU3gGLQ7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JwB97qRneCdz/bKFZO3bmmoSWOiPqVsOF6bnxBHLf6I1r/I1x5JkO13fkJXobG6I8
         xVMbpsuqLcfiphsjqAAu8DFy4i1Vif3IP+q5J2bCzMiuYIlwHTTTwYXhII1nHzhtUY
         VQXysDHlzdXw8p5NCjZGpXPhl5//6mjKQtPCBtZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
        Dexuan Cui <decui@microsoft.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 042/252] vsock: forward all packets to the host when no H2G is registered
Date:   Mon, 23 Nov 2020 13:19:52 +0100
Message-Id: <20201123121837.613422356@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 65b422d9b61ba12c08150784e8012fa1892ad03e ]

Before commit c0cfa2d8a788 ("vsock: add multi-transports support"),
if a G2H transport was loaded (e.g. virtio transport), every packets
was forwarded to the host, regardless of the destination CID.
The H2G transports implemented until then (vhost-vsock, VMCI) always
responded with an error, if the destination CID was not
VMADDR_CID_HOST.

>From that commit, we are using the remote CID to decide which
transport to use, so packets with remote CID > VMADDR_CID_HOST(2)
are sent only through H2G transport. If no H2G is available, packets
are discarded directly in the guest.

Some use cases (e.g. Nitro Enclaves [1]) rely on the old behaviour
to implement sibling VMs communication, so we restore the old
behavior when no H2G is registered.
It will be up to the host to discard packets if the destination is
not the right one. As it was already implemented before adding
multi-transport support.

Tested with nested QEMU/KVM by me and Nitro Enclaves by Andra.

[1] Documentation/virt/ne_overview.rst

Cc: Jorgen Hansen <jhansen@vmware.com>
Cc: Dexuan Cui <decui@microsoft.com>
Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Reported-by: Andra Paraschiv <andraprs@amazon.com>
Tested-by: Andra Paraschiv <andraprs@amazon.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20201112133837.34183-1-sgarzare@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -438,7 +438,7 @@ int vsock_assign_transport(struct vsock_
 	case SOCK_STREAM:
 		if (vsock_use_local_transport(remote_cid))
 			new_transport = transport_local;
-		else if (remote_cid <= VMADDR_CID_HOST)
+		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g)
 			new_transport = transport_g2h;
 		else
 			new_transport = transport_h2g;


