Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D12837C63B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237308AbhELPtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:49:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234199AbhELPlZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:41:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 919FE61104;
        Wed, 12 May 2021 15:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832895;
        bh=8/JIDKouSYg/xwkLP+eNHpCCoB3Kb49A5+8NdWiXhB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9x49FNJ78RMCXX0mayfc/Xg+u7At5+WL0Ymc8Fx/HBSp4UnCVtuc7IIIg0cTsuXe
         lQ6mYQbTeAfJruJKfPl6mUA4muB7g0VdiXGPR9xVrWDAN1ugmdt7K/Q9rahKz1IAPF
         1y3dIFKAVzw/iiEcJR02AK+672YTZ8Qp8HtWzo3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 466/530] vsock/vmci: log once the failed queue pair allocation
Date:   Wed, 12 May 2021 16:49:36 +0200
Message-Id: <20210512144835.081973866@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index 8b65323207db..1c9ecb18b8e6 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -568,8 +568,7 @@ vmci_transport_queue_pair_alloc(struct vmci_qp **qpair,
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



