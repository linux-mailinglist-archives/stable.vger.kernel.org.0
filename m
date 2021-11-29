Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9AA9461F4B
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380213AbhK2Spm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:45:42 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56938 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380369AbhK2Snk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:43:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1FAEACE140C;
        Mon, 29 Nov 2021 18:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06BDC53FAD;
        Mon, 29 Nov 2021 18:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211219;
        bh=zXU+sFrbHjGsQx8AvAg6K2FSI2Ujvex25JNIKxxKW3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zM6GN253cjaYtpPt4HCaIFoCnjRkmaPews7sv/r0Xi12D5Y6vkGWfZC1EzZ9J7aFp
         x95Y+da7s1RXHEEn9WodBgBIxL5llLFDD2gjv7DM4SYSMQL78zkL5L5p3AMUSJvyst
         hOf2XbCypaTsEYdsizPNDEzgU9SYjgILDDde0ZSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/179] tls: fix replacing proto_ops
Date:   Mon, 29 Nov 2021 19:18:59 +0100
Message-Id: <20211129181723.726286268@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit f3911f73f51d1534f4db70b516cc1fcb6be05bae ]

We replace proto_ops whenever TLS is configured for RX. But our
replacement also overrides sendpage_locked, which will crash
unless TX is also configured. Similarly we plug both of those
in for TLS_HW (NIC crypto offload) even tho TLS_HW has a completely
different implementation for TX.

Last but not least we always plug in something based on inet_stream_ops
even though a few of the callbacks differ for IPv6 (getname, release,
bind).

Use a callback building method similar to what we do for struct proto.

Fixes: c46234ebb4d1 ("tls: RX path for ktls")
Fixes: d4ffb02dee2f ("net/tls: enable sk_msg redirect to tls socket egress")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_main.c | 47 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 7 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 9ab81db8a6545..9aac9c60d786d 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -61,7 +61,7 @@ static DEFINE_MUTEX(tcpv6_prot_mutex);
 static const struct proto *saved_tcpv4_prot;
 static DEFINE_MUTEX(tcpv4_prot_mutex);
 static struct proto tls_prots[TLS_NUM_PROTS][TLS_NUM_CONFIG][TLS_NUM_CONFIG];
-static struct proto_ops tls_sw_proto_ops;
+static struct proto_ops tls_proto_ops[TLS_NUM_PROTS][TLS_NUM_CONFIG][TLS_NUM_CONFIG];
 static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 			 const struct proto *base);
 
@@ -71,6 +71,8 @@ void update_sk_prot(struct sock *sk, struct tls_context *ctx)
 
 	WRITE_ONCE(sk->sk_prot,
 		   &tls_prots[ip_ver][ctx->tx_conf][ctx->rx_conf]);
+	WRITE_ONCE(sk->sk_socket->ops,
+		   &tls_proto_ops[ip_ver][ctx->tx_conf][ctx->rx_conf]);
 }
 
 int wait_on_pending_writer(struct sock *sk, long *timeo)
@@ -581,8 +583,6 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 	if (tx) {
 		ctx->sk_write_space = sk->sk_write_space;
 		sk->sk_write_space = tls_write_space;
-	} else {
-		sk->sk_socket->ops = &tls_sw_proto_ops;
 	}
 	goto out;
 
@@ -640,6 +640,39 @@ struct tls_context *tls_ctx_create(struct sock *sk)
 	return ctx;
 }
 
+static void build_proto_ops(struct proto_ops ops[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
+			    const struct proto_ops *base)
+{
+	ops[TLS_BASE][TLS_BASE] = *base;
+
+	ops[TLS_SW  ][TLS_BASE] = ops[TLS_BASE][TLS_BASE];
+	ops[TLS_SW  ][TLS_BASE].sendpage_locked	= tls_sw_sendpage_locked;
+
+	ops[TLS_BASE][TLS_SW  ] = ops[TLS_BASE][TLS_BASE];
+	ops[TLS_BASE][TLS_SW  ].splice_read	= tls_sw_splice_read;
+
+	ops[TLS_SW  ][TLS_SW  ] = ops[TLS_SW  ][TLS_BASE];
+	ops[TLS_SW  ][TLS_SW  ].splice_read	= tls_sw_splice_read;
+
+#ifdef CONFIG_TLS_DEVICE
+	ops[TLS_HW  ][TLS_BASE] = ops[TLS_BASE][TLS_BASE];
+	ops[TLS_HW  ][TLS_BASE].sendpage_locked	= NULL;
+
+	ops[TLS_HW  ][TLS_SW  ] = ops[TLS_BASE][TLS_SW  ];
+	ops[TLS_HW  ][TLS_SW  ].sendpage_locked	= NULL;
+
+	ops[TLS_BASE][TLS_HW  ] = ops[TLS_BASE][TLS_SW  ];
+
+	ops[TLS_SW  ][TLS_HW  ] = ops[TLS_SW  ][TLS_SW  ];
+
+	ops[TLS_HW  ][TLS_HW  ] = ops[TLS_HW  ][TLS_SW  ];
+	ops[TLS_HW  ][TLS_HW  ].sendpage_locked	= NULL;
+#endif
+#ifdef CONFIG_TLS_TOE
+	ops[TLS_HW_RECORD][TLS_HW_RECORD] = *base;
+#endif
+}
+
 static void tls_build_proto(struct sock *sk)
 {
 	int ip_ver = sk->sk_family == AF_INET6 ? TLSV6 : TLSV4;
@@ -651,6 +684,8 @@ static void tls_build_proto(struct sock *sk)
 		mutex_lock(&tcpv6_prot_mutex);
 		if (likely(prot != saved_tcpv6_prot)) {
 			build_protos(tls_prots[TLSV6], prot);
+			build_proto_ops(tls_proto_ops[TLSV6],
+					sk->sk_socket->ops);
 			smp_store_release(&saved_tcpv6_prot, prot);
 		}
 		mutex_unlock(&tcpv6_prot_mutex);
@@ -661,6 +696,8 @@ static void tls_build_proto(struct sock *sk)
 		mutex_lock(&tcpv4_prot_mutex);
 		if (likely(prot != saved_tcpv4_prot)) {
 			build_protos(tls_prots[TLSV4], prot);
+			build_proto_ops(tls_proto_ops[TLSV4],
+					sk->sk_socket->ops);
 			smp_store_release(&saved_tcpv4_prot, prot);
 		}
 		mutex_unlock(&tcpv4_prot_mutex);
@@ -871,10 +908,6 @@ static int __init tls_register(void)
 	if (err)
 		return err;
 
-	tls_sw_proto_ops = inet_stream_ops;
-	tls_sw_proto_ops.splice_read = tls_sw_splice_read;
-	tls_sw_proto_ops.sendpage_locked   = tls_sw_sendpage_locked;
-
 	tls_device_init();
 	tcp_register_ulp(&tcp_tls_ulp_ops);
 
-- 
2.33.0



