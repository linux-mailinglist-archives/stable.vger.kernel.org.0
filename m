Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CD2469E3E
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379473AbhLFPhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388665AbhLFPe2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:34:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498E3C07E5E6;
        Mon,  6 Dec 2021 07:20:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB78E61344;
        Mon,  6 Dec 2021 15:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1F6C341C2;
        Mon,  6 Dec 2021 15:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804024;
        bh=ACCB5ImNjM9ohOUwQdsg96kM2FBVAVZ4pu57rqbybdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SyFKwaiDziPzLLbhGmRIUovh8XZ+P5GSm8RcDJm7DYs9z8lmHbQNoEWoNuGTIDFuA
         EyNEiyukYfVg4I+HrZsfx+Bl5yBmaxrVFC3rYNTd35fCSt3ssAPnyIT8obJvrgLuUb
         0h3oErD4odD6qGNJoWgRlAE48FC8Sbtns7RcDSMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 129/130] net/tls: Fix authentication failure in CCM mode
Date:   Mon,  6 Dec 2021 15:57:26 +0100
Message-Id: <20211206145604.122195328@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
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
@@ -515,7 +515,7 @@ static int tls_do_encryption(struct sock
 	memcpy(&rec->iv_data[iv_offset], tls_ctx->tx.iv,
 	       prot->iv_size + prot->salt_size);
 
-	xor_iv_with_seq(prot->version, rec->iv_data, tls_ctx->tx.rec_seq);
+	xor_iv_with_seq(prot->version, rec->iv_data + iv_offset, tls_ctx->tx.rec_seq);
 
 	sge->offset += prot->prepend_size;
 	sge->length -= prot->prepend_size;
@@ -1487,7 +1487,7 @@ static int decrypt_internal(struct sock
 	else
 		memcpy(iv + iv_offset, tls_ctx->rx.iv, prot->salt_size);
 
-	xor_iv_with_seq(prot->version, iv, tls_ctx->rx.rec_seq);
+	xor_iv_with_seq(prot->version, iv + iv_offset, tls_ctx->rx.rec_seq);
 
 	/* Prepare AAD */
 	tls_make_aad(aad, rxm->full_len - prot->overhead_size +


