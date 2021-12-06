Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E2B469C21
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349444AbhLFPVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:21:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37002 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345881AbhLFPSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:18:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4A2E61320;
        Mon,  6 Dec 2021 15:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8608BC341C1;
        Mon,  6 Dec 2021 15:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803675;
        bh=K6aE/Qrzyk8m3kTTMO+MQjEl1O1vAPMVrgXwwZbzLig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZUNthJuBe6I+FC9MkiVyevN26zO7mOS7LSP7CFEWQodaX7TMajSEsOftY7IBdxFeC
         8Bm+1cxe5G3Rtar2ed6n6GHOuZoDqY7SoOxMMXma+UKgBpJ/s8fryytCu2I7DcflYU
         glpRwzZ4coLCQ3JiO7ERa3Av1RL3hxjwb3prh2xQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 69/70] net/tls: Fix authentication failure in CCM mode
Date:   Mon,  6 Dec 2021 15:57:13 +0100
Message-Id: <20211206145554.338303123@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -512,7 +512,7 @@ static int tls_do_encryption(struct sock
 	memcpy(&rec->iv_data[iv_offset], tls_ctx->tx.iv,
 	       prot->iv_size + prot->salt_size);
 
-	xor_iv_with_seq(prot->version, rec->iv_data, tls_ctx->tx.rec_seq);
+	xor_iv_with_seq(prot->version, rec->iv_data + iv_offset, tls_ctx->tx.rec_seq);
 
 	sge->offset += prot->prepend_size;
 	sge->length -= prot->prepend_size;
@@ -1483,7 +1483,7 @@ static int decrypt_internal(struct sock
 	else
 		memcpy(iv + iv_offset, tls_ctx->rx.iv, prot->salt_size);
 
-	xor_iv_with_seq(prot->version, iv, tls_ctx->rx.rec_seq);
+	xor_iv_with_seq(prot->version, iv + iv_offset, tls_ctx->rx.rec_seq);
 
 	/* Prepare AAD */
 	tls_make_aad(aad, rxm->full_len - prot->overhead_size +


