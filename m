Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB8C29C71F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1827788AbgJ0S2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:28:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752888AbgJ0N5a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:57:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 142012068D;
        Tue, 27 Oct 2020 13:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807050;
        bh=XMYfXOnhUsoMS3CYycBbIZEScuV4Ri3RvewhXglCiXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ImD6iOkNzZrgZo2pKuAeJuABOt1JvRSjH9BYjDQQweNlqUWiGKoKFafAsN8Ccwo6S
         xXDmrSOPa8OXl+N78doPpf4ZeBHtJS5zewMv9r0M+S5jnzIk1RhHn02fpxoUThpZ7z
         1FRJdfUiXfVCvKhJtL6ol5qJ7RTIJFhUIaSGioOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tero Kristo <t-kristo@ti.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 024/112] crypto: omap-sham - fix digcnt register handling with export/import
Date:   Tue, 27 Oct 2020 14:48:54 +0100
Message-Id: <20201027134901.711824913@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tero Kristo <t-kristo@ti.com>

[ Upstream commit 3faf757bad75f3fc1b2736f0431e295a073a7423 ]

Running export/import for hashes in peculiar order (mostly done by
openssl) can mess up the internal book keeping of the OMAP SHA core.
Fix by forcibly writing the correct DIGCNT back to hardware. This issue
was noticed while transitioning to openssl 1.1 support.

Fixes: 0d373d603202 ("crypto: omap-sham - Add OMAP4/AM33XX SHAM Support")
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-sham.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 48adb2a0903e5..7e9a44cee4250 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -453,6 +453,9 @@ static void omap_sham_write_ctrl_omap4(struct omap_sham_dev *dd, size_t length,
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(dd->req);
 	u32 val, mask;
 
+	if (likely(ctx->digcnt))
+		omap_sham_write(dd, SHA_REG_DIGCNT(dd), ctx->digcnt);
+
 	/*
 	 * Setting ALGO_CONST only for the first iteration and
 	 * CLOSE_HASH only for the last one. Note that flags mode bits
-- 
2.25.1



