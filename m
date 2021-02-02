Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBED30BFFD
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhBBNrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:47:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:36410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232896AbhBBNpP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:45:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 686C764F79;
        Tue,  2 Feb 2021 13:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273244;
        bh=knkl94FSkMKf1qU+46CcvhyoGxxaf2VM4Xast9AQ40c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WzojE57MisJJ5pIDGzup7CyD9FYC6mX+VpI6+IxKTVdkAzn6UzZw5ZKGaUlplPBnX
         moAe2zFIPTrh3Fgma/aoiczdNyH/oWJcD59daAWV2Yyb1SZdcoYFVvWwdoFkiS4paa
         AyVykMsTSQcVHHwruRCJnKK6KUUKGjI0Cyu879GY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Auhagen <sven.auhagen@voleatech.de>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 034/142] crypto: marvel/cesa - Fix tdma descriptor on 64-bit
Date:   Tue,  2 Feb 2021 14:36:37 +0100
Message-Id: <20210202132959.116531916@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 4f6543f28bb05433d87b6de6c21e9c14c35ecf33 upstream.

The patch that added src_dma/dst_dma to struct mv_cesa_tdma_desc
is broken on 64-bit systems as the size of the descriptor has been
changed.  This patch fixes it by using u32 instead of dma_addr_t.

Fixes: e62291c1d9f4 ("crypto: marvell/cesa - Fix sparse warnings")
Cc: <stable@vger.kernel.org>
Reported-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/marvell/cesa/cesa.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/marvell/cesa/cesa.h
+++ b/drivers/crypto/marvell/cesa/cesa.h
@@ -300,11 +300,11 @@ struct mv_cesa_tdma_desc {
 	__le32 byte_cnt;
 	union {
 		__le32 src;
-		dma_addr_t src_dma;
+		u32 src_dma;
 	};
 	union {
 		__le32 dst;
-		dma_addr_t dst_dma;
+		u32 dst_dma;
 	};
 	__le32 next_dma;
 


