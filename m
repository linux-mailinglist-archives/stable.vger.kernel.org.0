Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2651B37C24A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhELPIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:08:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232808AbhELPGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:06:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AE0F6195D;
        Wed, 12 May 2021 15:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831673;
        bh=eCZDnkW9P19r0JkVfYRHvmC944E+FgZlf8cOSvhBm8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j3uW27f5YILWZ42geJnqXLrgis0HqEOWvhB2mFO3goIeLf3cPPu5cYBrvrhVH5SXh
         31GTk4f9OriWQKCUAGqeOBThD8/2sT5F4Gpg4hi7k2uNoJcTbcFLJCsRR+ti+eyFCR
         Jg8E8RmoeIvbPsJO5kZYhsM0pdMkHPikL/jfNtvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 214/244] vsock/vmci: log once the failed queue pair allocation
Date:   Wed, 12 May 2021 16:49:45 +0200
Message-Id: <20210512144749.839626570@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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
index 8c9c4ed90fa7..aaabcd84268a 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -576,8 +576,7 @@ vmci_transport_queue_pair_alloc(struct vmci_qp **qpair,
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



