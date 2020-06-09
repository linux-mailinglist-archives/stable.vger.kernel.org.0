Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F781F432E
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731361AbgFIRvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:51:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732760AbgFIRu7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:50:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 906472074B;
        Tue,  9 Jun 2020 17:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725059;
        bh=dneXgUP1hvA/ZLqtJEfa5ZryFKN8+0iq70e7wX8rxDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rZVGqPR+O+8qDt9JtgnohGDCRp8YTdgtmAtGiK+MUEPkfRRoqTWy3gLD4WktF1icA
         60Uc/Lxv3RBjjGPluvehXGVwp/7RvXG8QmVvIMElMApTqFSa+czZ7GPvGhrA6bdMZB
         UmDktNyL2Zo94EEMby1DBPJSGaRIWTUs4Dd3JY1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 27/46] vsock: fix timeout in vsock_accept()
Date:   Tue,  9 Jun 2020 19:44:43 +0200
Message-Id: <20200609174027.453089041@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174022.938987501@linuxfoundation.org>
References: <20200609174022.938987501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 7e0afbdfd13d1e708fe96e31c46c4897101a6a43 ]

The accept(2) is an "input" socket interface, so we should use
SO_RCVTIMEO instead of SO_SNDTIMEO to set the timeout.

So this patch replace sock_sndtimeo() with sock_rcvtimeo() to
use the right timeout in the vsock_accept().

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1290,7 +1290,7 @@ static int vsock_accept(struct socket *s
 	/* Wait for children sockets to appear; these are the new sockets
 	 * created upon connection establishment.
 	 */
-	timeout = sock_sndtimeo(listener, flags & O_NONBLOCK);
+	timeout = sock_rcvtimeo(listener, flags & O_NONBLOCK);
 	prepare_to_wait(sk_sleep(listener), &wait, TASK_INTERRUPTIBLE);
 
 	while ((connected = vsock_dequeue_accept(listener)) == NULL &&


