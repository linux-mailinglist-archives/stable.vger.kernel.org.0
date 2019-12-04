Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3ED911334E
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731717AbfLDSNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:13:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:42190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731714AbfLDSNL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:13:11 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4442E20675;
        Wed,  4 Dec 2019 18:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483190;
        bh=7B2zsv4wmb26jk/t27o3Uj0Jm6oJDggdc1ltkcsGrAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AIitDm7o9WlDatRUvQrd8u4C7PUf5+aRBl8ZR1GxR3X3nGXyygsbz8ajIps0by3dD
         2ee/XrMm/93LbC4fTTJCpfqF9EWPPhs2QXElOogzoa/0ZLWBvd+KpQx53VPwi53PYP
         UWcOF3UPeGNhxnRmdeF9VXcyE5BTF9KoE0ce+g1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lepton Wu <ytht.net@gmail.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 034/125] VSOCK: bind to random port for VMADDR_PORT_ANY
Date:   Wed,  4 Dec 2019 18:55:39 +0100
Message-Id: <20191204175321.062982160@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lepton Wu <ytht.net@gmail.com>

[ Upstream commit 8236b08cf50f85bbfaf48910a0b3ee68318b7c4b ]

The old code always starts from fixed port for VMADDR_PORT_ANY. Sometimes
when VMM crashed, there is still orphaned vsock which is waiting for
close timer, then it could cause connection time out for new started VM
if they are trying to connect to same port with same guest cid since the
new packets could hit that orphaned vsock. We could also fix this by doing
more in vhost_vsock_reset_orphans, but any way, it should be better to start
from a random local port instead of a fixed one.

Signed-off-by: Lepton Wu <ytht.net@gmail.com>
Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 7566395e526d2..18f377306884b 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -97,6 +97,7 @@
 #include <linux/mutex.h>
 #include <linux/net.h>
 #include <linux/poll.h>
+#include <linux/random.h>
 #include <linux/skbuff.h>
 #include <linux/smp.h>
 #include <linux/socket.h>
@@ -501,9 +502,13 @@ out:
 static int __vsock_bind_stream(struct vsock_sock *vsk,
 			       struct sockaddr_vm *addr)
 {
-	static u32 port = LAST_RESERVED_PORT + 1;
+	static u32 port = 0;
 	struct sockaddr_vm new_addr;
 
+	if (!port)
+		port = LAST_RESERVED_PORT + 1 +
+			prandom_u32_max(U32_MAX - LAST_RESERVED_PORT);
+
 	vsock_addr_init(&new_addr, addr->svm_cid, addr->svm_port);
 
 	if (addr->svm_port == VMADDR_PORT_ANY) {
-- 
2.20.1



