Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D9A468405
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 11:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343696AbhLDKa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 05:30:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49732 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234334AbhLDKaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 05:30:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A1E5B8098F
        for <stable@vger.kernel.org>; Sat,  4 Dec 2021 10:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD87C341C2;
        Sat,  4 Dec 2021 10:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638613648;
        bh=nn+T9w6KHEEOo2XIh7Wc+sKqXKj/9gOTqXAe2zyabXA=;
        h=Subject:To:Cc:From:Date:From;
        b=ZgK8ers8Jv/1OPsHDZQovMkx7ar8E/o5CQXUbn/qCB9Rtvu6bAhdqN8v8wIDOz17w
         Uj8MRS3MCKM4fHfm3d8umqjiUoJFYKt0GqEF4UeYAg34SmHWzl5xym3v9Rbh2d6V6M
         j8XIiAnx2X17vroA2EebcxGbvJ7UIEge6xK5Np7k=
Subject: FAILED: patch "[PATCH] net/tls: Fix authentication failure in CCM mode" failed to apply to 5.4-stable tree
To:     tianjia.zhang@linux.alibaba.com, davem@davemloft.net,
        vakul.garg@nxp.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 04 Dec 2021 11:27:17 +0100
Message-ID: <163861363776188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5961060692f8b17cd2080620a3d27b95d2ae05ca Mon Sep 17 00:00:00 2001
From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Date: Mon, 29 Nov 2021 17:32:12 +0800
Subject: [PATCH] net/tls: Fix authentication failure in CCM mode

When the TLS cipher suite uses CCM mode, including AES CCM and
SM4 CCM, the first byte of the B0 block is flags, and the real
IV starts from the second byte. The XOR operation of the IV and
rec_seq should be skip this byte, that is, add the iv_offset.

Fixes: f295b3ae9f59 ("net/tls: Add support of AES128-CCM based ciphers")
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc: Vakul Garg <vakul.garg@nxp.com>
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index d3e7ff90889e..dfe623a4e72f 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -521,7 +521,7 @@ static int tls_do_encryption(struct sock *sk,
 	memcpy(&rec->iv_data[iv_offset], tls_ctx->tx.iv,
 	       prot->iv_size + prot->salt_size);
 
-	xor_iv_with_seq(prot, rec->iv_data, tls_ctx->tx.rec_seq);
+	xor_iv_with_seq(prot, rec->iv_data + iv_offset, tls_ctx->tx.rec_seq);
 
 	sge->offset += prot->prepend_size;
 	sge->length -= prot->prepend_size;
@@ -1499,7 +1499,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	else
 		memcpy(iv + iv_offset, tls_ctx->rx.iv, prot->salt_size);
 
-	xor_iv_with_seq(prot, iv, tls_ctx->rx.rec_seq);
+	xor_iv_with_seq(prot, iv + iv_offset, tls_ctx->rx.rec_seq);
 
 	/* Prepare AAD */
 	tls_make_aad(aad, rxm->full_len - prot->overhead_size +

