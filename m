Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B76838A743
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236966AbhETKgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:36:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237089AbhETKdk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:33:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3986C61581;
        Thu, 20 May 2021 09:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504380;
        bh=LGNpyK4Do3h3CvzevW2+nFJk++3+zBIXTaQn1hxw0QU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uelpw/qGHEQu6kJ1G6eKp7pS5XbHABdJQptqkspaSI7ctPv1SUgb6LMe68z7UJt6d
         42LwXN3W+B0ZgbainLSW6r7OhCGFypcyVFJHAcmpeDaLyAe9hPn3XJzg3ymXhnqmop
         BNmpmQsdRGWRFDRQiN1HEdI3Ay7TXL4OpUrUNYwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 220/323] vsock/vmci: log once the failed queue pair allocation
Date:   Thu, 20 May 2021 11:21:52 +0200
Message-Id: <20210520092127.672742642@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit e16edc99d658cd41c60a44cc14d170697aa3271f ]

VMCI feature is not supported in conjunction with the vSphere Fault
Tolerance (FT) feature.

VMware Tools can repeatedly try to create a vsock connection. If FT is
enabled the kernel logs is flooded with the following messages:

    qp_alloc_hypercall result = -20
    Could not attach to queue pair with -20

"qp_alloc_hypercall result = -20" was hidden by commit e8266c4c3307
("VMCI: Stop log spew when qp allocation isn't possible"), but "Could
not attach to queue pair with -20" is still there flooding the log.

Since the error message can be useful in some cases, print it only once.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/vmci_transport.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index ba4cb18c4b9a..c1da1ce3d36e 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -585,8 +585,7 @@ vmci_transport_queue_pair_alloc(struct vmci_qp **qpair,
 			       peer, flags, VMCI_NO_PRIVILEGE_FLAGS);
 out:
 	if (err < 0) {
-		pr_err("Could not attach to queue pair with %d\n",
-		       err);
+		pr_err_once("Could not attach to queue pair with %d\n", err);
 		err = vmci_transport_error_to_vsock_error(err);
 	}
 
-- 
2.30.2



