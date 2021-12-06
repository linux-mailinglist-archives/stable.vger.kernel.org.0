Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67308469267
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 10:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240764AbhLFJet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 04:34:49 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:16363 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240727AbhLFJet (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 04:34:49 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R371e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uza6YuP_1638783068;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Uza6YuP_1638783068)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 06 Dec 2021 17:31:09 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vakul Garg <vakul.garg@nxp.com>, stable@vger.kernel.org
Subject: [PATCH stable 5.4] net/tls: Fix authentication failure in CCM mode
Date:   Mon,  6 Dec 2021 17:31:08 +0800
Message-Id: <20211206093108.124322-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
In-Reply-To: <163861363776188@kroah.com>
References: <163861363776188@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 5961060692f8b17cd2080620a3d27b95d2ae05ca upstream.

When the TLS cipher suite uses CCM mode, including AES CCM and
SM4 CCM, the first byte of the B0 block is flags, and the real
IV starts from the second byte. The XOR operation of the IV and
rec_seq should be skip this byte, that is, add the iv_offset.

Fixes: f295b3ae9f59 ("net/tls: Add support of AES128-CCM based ciphers")
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc: Vakul Garg <vakul.garg@nxp.com>
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/tls/tls_sw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 02821b914054..1436a36c1934 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -512,7 +512,7 @@ static int tls_do_encryption(struct sock *sk,
 	memcpy(&rec->iv_data[iv_offset], tls_ctx->tx.iv,
 	       prot->iv_size + prot->salt_size);
 
-	xor_iv_with_seq(prot->version, rec->iv_data, tls_ctx->tx.rec_seq);
+	xor_iv_with_seq(prot->version, rec->iv_data + iv_offset, tls_ctx->tx.rec_seq);
 
 	sge->offset += prot->prepend_size;
 	sge->length -= prot->prepend_size;
@@ -1483,7 +1483,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	else
 		memcpy(iv + iv_offset, tls_ctx->rx.iv, prot->salt_size);
 
-	xor_iv_with_seq(prot->version, iv, tls_ctx->rx.rec_seq);
+	xor_iv_with_seq(prot->version, iv + iv_offset, tls_ctx->rx.rec_seq);
 
 	/* Prepare AAD */
 	tls_make_aad(aad, rxm->full_len - prot->overhead_size +
-- 
2.19.1.3.ge56e4f7

