Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931DB579E7E
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242647AbiGSNBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242779AbiGSM7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:59:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC632623;
        Tue, 19 Jul 2022 05:25:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 24549CE1BCF;
        Tue, 19 Jul 2022 12:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25814C341D1;
        Tue, 19 Jul 2022 12:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233503;
        bh=w88KjV2nHe48toTaqFwb8rbs7fnFyPWkrIu4x3ktmtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EGoGvaTkCyToWCaH/WfiVlNTz1ERcVBYYVxxqE+H2iRj4IUq7la1gOLzh3AOUffe2
         byi14/CnVpzNdeiAJvPvJGHbzR/6Tit6tpK9GlLLwNPE6bZQoFoSKT09N7WGdeRd+5
         5VEf25j5d4k8ukb4ukK4ifDbNlaEu+jxnHbeKF6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 143/231] net/tls: Check for errors in tls_device_init
Date:   Tue, 19 Jul 2022 13:53:48 +0200
Message-Id: <20220719114726.401044856@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit 3d8c51b25a235e283e37750943bbf356ef187230 ]

Add missing error checks in tls_device_init.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20220714070754.1428-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tls.h    | 4 ++--
 net/tls/tls_device.c | 4 ++--
 net/tls/tls_main.c   | 7 ++++++-
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index b6968a5b5538..e8764d3da41a 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -708,7 +708,7 @@ int tls_sw_fallback_init(struct sock *sk,
 			 struct tls_crypto_info *crypto_info);
 
 #ifdef CONFIG_TLS_DEVICE
-void tls_device_init(void);
+int tls_device_init(void);
 void tls_device_cleanup(void);
 void tls_device_sk_destruct(struct sock *sk);
 int tls_set_device_offload(struct sock *sk, struct tls_context *ctx);
@@ -728,7 +728,7 @@ static inline bool tls_is_sk_rx_device_offloaded(struct sock *sk)
 	return tls_get_ctx(sk)->rx_conf == TLS_HW;
 }
 #else
-static inline void tls_device_init(void) {}
+static inline int tls_device_init(void) { return 0; }
 static inline void tls_device_cleanup(void) {}
 
 static inline int
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 3919fe2c58c5..3a61bb594544 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1394,9 +1394,9 @@ static struct notifier_block tls_dev_notifier = {
 	.notifier_call	= tls_dev_event,
 };
 
-void __init tls_device_init(void)
+int __init tls_device_init(void)
 {
-	register_netdevice_notifier(&tls_dev_notifier);
+	return register_netdevice_notifier(&tls_dev_notifier);
 }
 
 void __exit tls_device_cleanup(void)
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 5c9697840ef7..13058b0ee4cd 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -993,7 +993,12 @@ static int __init tls_register(void)
 	if (err)
 		return err;
 
-	tls_device_init();
+	err = tls_device_init();
+	if (err) {
+		unregister_pernet_subsys(&tls_proc_ops);
+		return err;
+	}
+
 	tcp_register_ulp(&tcp_tls_ulp_ops);
 
 	return 0;
-- 
2.35.1



