Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A01229C2C7
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760125AbgJ0Odc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:33:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902453AbgJ0Odb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:33:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C293020773;
        Tue, 27 Oct 2020 14:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809211;
        bh=GAEcYI73tOo/0HcEuL9S2l4FtNXoCbXC1XuSr4iDeCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFLCVMVL9QgfQBQNxgHpO5W3Ts3WkJabsBHcTdcHlki2zxtpATxftPlIUk7yvH5bU
         rNFWAQEO1tSYV+xlmxhjPpnwm6cDGqmV+1MGO7goLKad+tBXBVl8V6uqT7MLMwH3ui
         yM0QSr8WluUNvYFyvVIPDWKwmPUopMYrGCGigFtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tero Kristo <t-kristo@ti.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/408] crypto: omap-sham - fix digcnt register handling with export/import
Date:   Tue, 27 Oct 2020 14:50:23 +0100
Message-Id: <20201027135459.012909578@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
index aba5db3c0588f..d7c0c982ba433 100644
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



