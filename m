Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37DB22F00F
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731737AbgG0OVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:21:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730258AbgG0OVe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:21:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DADC2070B;
        Mon, 27 Jul 2020 14:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859692;
        bh=qZ/q8yUYZulNBOTbHyiSlh+qQ7ws0lW90pxD72l4R9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rLzg6Ebq2TheqrePFb87qusuHZwmnoCiyrBb2bLPTJRB8vCi9rrMdDAUQG6hLFNyT
         dRXienJvQt/ulV3Lg0H9rwhTc4N0fNAjVSA1kWlj1Z6k8k/9ACWcAoOCMws9ahOrCa
         UBh69c4rq7M8U2WufZlkURiYAKLXeGA0oz5R1TDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 051/179] vsock/virtio: annotate the_virtio_vsock RCU pointer
Date:   Mon, 27 Jul 2020 16:03:46 +0200
Message-Id: <20200727134935.154462720@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit f961134a612c793d5901a93d85a29337c74af978 ]

Commit 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free
on the_virtio_vsock") starts to use RCU to protect 'the_virtio_vsock'
pointer, but we forgot to annotate it.

This patch adds the annotation to fix the following sparse errors:

    net/vmw_vsock/virtio_transport.c:73:17: error: incompatible types in comparison expression (different address spaces):
    net/vmw_vsock/virtio_transport.c:73:17:    struct virtio_vsock [noderef] __rcu *
    net/vmw_vsock/virtio_transport.c:73:17:    struct virtio_vsock *
    net/vmw_vsock/virtio_transport.c:171:17: error: incompatible types in comparison expression (different address spaces):
    net/vmw_vsock/virtio_transport.c:171:17:    struct virtio_vsock [noderef] __rcu *
    net/vmw_vsock/virtio_transport.c:171:17:    struct virtio_vsock *
    net/vmw_vsock/virtio_transport.c:207:17: error: incompatible types in comparison expression (different address spaces):
    net/vmw_vsock/virtio_transport.c:207:17:    struct virtio_vsock [noderef] __rcu *
    net/vmw_vsock/virtio_transport.c:207:17:    struct virtio_vsock *
    net/vmw_vsock/virtio_transport.c:561:13: error: incompatible types in comparison expression (different address spaces):
    net/vmw_vsock/virtio_transport.c:561:13:    struct virtio_vsock [noderef] __rcu *
    net/vmw_vsock/virtio_transport.c:561:13:    struct virtio_vsock *
    net/vmw_vsock/virtio_transport.c:612:9: error: incompatible types in comparison expression (different address spaces):
    net/vmw_vsock/virtio_transport.c:612:9:    struct virtio_vsock [noderef] __rcu *
    net/vmw_vsock/virtio_transport.c:612:9:    struct virtio_vsock *
    net/vmw_vsock/virtio_transport.c:631:9: error: incompatible types in comparison expression (different address spaces):
    net/vmw_vsock/virtio_transport.c:631:9:    struct virtio_vsock [noderef] __rcu *
    net/vmw_vsock/virtio_transport.c:631:9:    struct virtio_vsock *

Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock")
Reported-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index dfbaf6bd8b1c7..2700a63ab095e 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -22,7 +22,7 @@
 #include <net/af_vsock.h>
 
 static struct workqueue_struct *virtio_vsock_workqueue;
-static struct virtio_vsock *the_virtio_vsock;
+static struct virtio_vsock __rcu *the_virtio_vsock;
 static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
 
 struct virtio_vsock {
-- 
2.25.1



