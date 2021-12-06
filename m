Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47BC469D6F
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358607AbhLFP3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:29:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58706 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386293AbhLFP0X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:26:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE381B8101B;
        Mon,  6 Dec 2021 15:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DAC5C341C5;
        Mon,  6 Dec 2021 15:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804172;
        bh=5plzfkIbrCl/xIRY7yXwMN3TtOIYkNMBgE/9zriAJGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxG9O3/RpJerVdVeQ083lSo/mixzQg966/J6zcteGc8DKOAga86Tjn8HRUc9K62LE
         IfYsilndo+OGVpbqyojgeHixjFHyn1abU1ajF7MZCX/pkTc95mk32+l8dOVzVWG+Mv
         DTMfz567QjC/7eUAARFwfwgRlEU+urxK76AKeom4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 052/207] net/tls: Fix authentication failure in CCM mode
Date:   Mon,  6 Dec 2021 15:55:06 +0100
Message-Id: <20211206145612.030788545@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
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
 
-	xor_iv_with_seq(prot, rec->iv_data, tls_ctx->tx.rec_seq);
+	xor_iv_with_seq(prot, rec->iv_data + iv_offset, tls_ctx->tx.rec_seq);
 
 	sge->offset += prot->prepend_size;
 	sge->length -= prot->prepend_size;
@@ -1487,7 +1487,7 @@ static int decrypt_internal(struct sock
 	else
 		memcpy(iv + iv_offset, tls_ctx->rx.iv, prot->salt_size);
 
-	xor_iv_with_seq(prot, iv, tls_ctx->rx.rec_seq);
+	xor_iv_with_seq(prot, iv + iv_offset, tls_ctx->rx.rec_seq);
 
 	/* Prepare AAD */
 	tls_make_aad(aad, rxm->full_len - prot->overhead_size +


