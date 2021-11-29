Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2AC461F4A
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380049AbhK2Spj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:45:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48416 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380345AbhK2Sne (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:43:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5526B81632;
        Mon, 29 Nov 2021 18:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7D3C53FC7;
        Mon, 29 Nov 2021 18:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211213;
        bh=8jYf/+Ab1t+RuY8HRaY0RU8jehREoAaeW+3jlgCGP34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2WR66zdXrzy9mKiA1iuc4PEarYvqcoxjwDLxc2udtA2PKgYnlIWUEiliaFI5zhrm
         7e+joM64feZk/OgsM4SvmWYYegFAN7dJH2HdD3OeIXGPcu1gKKK7t6QS3sagOobznk
         +ELJwoIRBbepVLAlB3qoLCExlWFOVP/rtCmvQb1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/179] tls: splice_read: fix record type check
Date:   Mon, 29 Nov 2021 19:18:57 +0100
Message-Id: <20211129181723.647905371@linuxfoundation.org>
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
index 1b08b877a8900..1715e793c04ba 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2006,21 +2006,18 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
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



