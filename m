Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B084625B3
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhK2Wmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:42:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234159AbhK2WmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:42:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04510C141B02;
        Mon, 29 Nov 2021 10:32:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 52877CE13FD;
        Mon, 29 Nov 2021 18:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F3CC53FAD;
        Mon, 29 Nov 2021 18:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210723;
        bh=x03eSbQ2Bb7TKV1EWI7KKF5HwXD+aQeqx1ftcq19ySA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FttkTN3R2M2661N9Wb2fAoAU21AB2U++fLpmhbnetZrmlYoG6frMRRGbRF67Oix0y
         KFaduGuAeOC+BS9/PhS2NLQVoa5+8TAzSFol0Dzz+6hUg+S+svRGsV0e4iqswS2jaP
         1CepBGtRe+nf9i+CK947g0anFLGvKxM9v2vIrDYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/121] tls: splice_read: fix record type check
Date:   Mon, 29 Nov 2021 19:18:44 +0100
Message-Id: <20211129181714.799059368@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 520493f66f6822551aef2879cd40207074fe6980 ]

We don't support splicing control records. TLS 1.3 changes moved
the record type check into the decrypt if(). The skb may already
be decrypted and still be an alert.

Note that decrypt_skb_update() is idempotent and updates ctx->decrypted
so the if() is pointless.

Reorder the check for decryption errors with the content type check
while touching them. This part is not really a bug, because if
decryption failed in TLS 1.3 content type will be DATA, and for
TLS 1.2 it will be correct. Nevertheless its strange to touch output
before checking if the function has failed.

Fixes: fedf201e1296 ("net: tls: Refactor control message handling on recv")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 14cce61160a58..122d5daed8b61 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2007,21 +2007,18 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	if (!skb)
 		goto splice_read_end;
 
-	if (!ctx->decrypted) {
-		err = decrypt_skb_update(sk, skb, NULL, &chunk, &zc, false);
-
-		/* splice does not support reading control messages */
-		if (ctx->control != TLS_RECORD_TYPE_DATA) {
-			err = -EINVAL;
-			goto splice_read_end;
-		}
+	err = decrypt_skb_update(sk, skb, NULL, &chunk, &zc, false);
+	if (err < 0) {
+		tls_err_abort(sk, -EBADMSG);
+		goto splice_read_end;
+	}
 
-		if (err < 0) {
-			tls_err_abort(sk, -EBADMSG);
-			goto splice_read_end;
-		}
-		ctx->decrypted = 1;
+	/* splice does not support reading control messages */
+	if (ctx->control != TLS_RECORD_TYPE_DATA) {
+		err = -EINVAL;
+		goto splice_read_end;
 	}
+
 	rxm = strp_msg(skb);
 
 	chunk = min_t(unsigned int, rxm->full_len, len);
-- 
2.33.0



