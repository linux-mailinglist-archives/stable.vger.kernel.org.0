Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF3F676DF4
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388210AbfGZP1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:27:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388203AbfGZP1I (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:27:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51FF8218D4;
        Fri, 26 Jul 2019 15:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154827;
        bh=rA2FqFUvc1PoYNeLlUKoLtsNwAP3/mdz2JPQVmHyk50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ApqxpRMpr+rFlgjrTzxEaMEjIlZPnCnKkl59/xs0djuDQiX6Aoy/2WBOn+Vnzjl9B
         8zWek7hgre23diJyVc3CCpn17s1QePxQbeCHlIlbetkV9taGZ7Ca0c2MPXS1yZH/nL
         3z9MQ72p+SafqQ3YuPX3QDu/6Bh1OUcaFo0H6CAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 38/66] net/tls: reject offload of TLS 1.3
Date:   Fri, 26 Jul 2019 17:24:37 +0200
Message-Id: <20190726152306.144992521@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 618bac45937a3dc6126ac0652747481e97000f99 ]

Neither drivers nor the tls offload code currently supports TLS
version 1.3. Check the TLS version when installing connection
state. TLS 1.3 will just fallback to the kernel crypto for now.

Fixes: 130b392c6cd6 ("net: tls: Add tls 1.3 support")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_device.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -742,6 +742,11 @@ int tls_set_device_offload(struct sock *
 	}
 
 	crypto_info = &ctx->crypto_send.info;
+	if (crypto_info->version != TLS_1_2_VERSION) {
+		rc = -EOPNOTSUPP;
+		goto free_offload_ctx;
+	}
+
 	switch (crypto_info->cipher_type) {
 	case TLS_CIPHER_AES_GCM_128:
 		nonce_size = TLS_CIPHER_AES_GCM_128_IV_SIZE;
@@ -876,6 +881,9 @@ int tls_set_device_offload_rx(struct soc
 	struct net_device *netdev;
 	int rc = 0;
 
+	if (ctx->crypto_recv.info.version != TLS_1_2_VERSION)
+		return -EOPNOTSUPP;
+
 	/* We support starting offload on multiple sockets
 	 * concurrently, so we only need a read lock here.
 	 * This lock must precede get_netdev_for_sock to prevent races between


