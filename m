Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 993891671AA
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbgBUH4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:56:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:55416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730439AbgBUH4M (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:56:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1CFD222C4;
        Fri, 21 Feb 2020 07:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271771;
        bh=7cQc4SRp6iphGymWqLpNl7n+Za/QHc3wM/3uBQapzDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YwB3IcRYnIgBuSxUozpzvNygj5HB6rVkG7sW1yKvSbTNDprj3QsHE+QU1wxRidWsf
         +DSLH6Zi00gUvg1Wx/TsjgIkGNovQrXB3hmsVvkgMPGs/WSUnGHB0Bm0Y8ezmbkecG
         MZp8avVCSdHfGyQaZUbZ5AgSVF2imBDCV4jBdX94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zaibo Xu <xuzaibo@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 275/399] crypto: hisilicon - Bugfixed tfm leak
Date:   Fri, 21 Feb 2020 08:40:00 +0100
Message-Id: <20200221072428.849850793@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zaibo Xu <xuzaibo@huawei.com>

[ Upstream commit dfee9955abc7ec9364413d16316181322cf44f2f ]

1.Fixed the bug of software tfm leakage.
2.Update HW error log message.

Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c |  7 +++++-
 drivers/crypto/hisilicon/hpre/hpre_main.c   | 24 ++++++++++-----------
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 98f037e6ea3e4..d8b015266ee49 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1043,6 +1043,7 @@ static unsigned int hpre_rsa_max_size(struct crypto_akcipher *tfm)
 static int hpre_rsa_init_tfm(struct crypto_akcipher *tfm)
 {
 	struct hpre_ctx *ctx = akcipher_tfm_ctx(tfm);
+	int ret;
 
 	ctx->rsa.soft_tfm = crypto_alloc_akcipher("rsa-generic", 0, 0);
 	if (IS_ERR(ctx->rsa.soft_tfm)) {
@@ -1050,7 +1051,11 @@ static int hpre_rsa_init_tfm(struct crypto_akcipher *tfm)
 		return PTR_ERR(ctx->rsa.soft_tfm);
 	}
 
-	return hpre_ctx_init(ctx);
+	ret = hpre_ctx_init(ctx);
+	if (ret)
+		crypto_free_akcipher(ctx->rsa.soft_tfm);
+
+	return ret;
 }
 
 static void hpre_rsa_exit_tfm(struct crypto_akcipher *tfm)
diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 34e0424410bfc..0c98c37e39f4a 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -106,18 +106,18 @@ static const char * const hpre_debug_file_name[] = {
 };
 
 static const struct hpre_hw_error hpre_hw_errors[] = {
-	{ .int_msk = BIT(0), .msg = "hpre_ecc_1bitt_err" },
-	{ .int_msk = BIT(1), .msg = "hpre_ecc_2bit_err" },
-	{ .int_msk = BIT(2), .msg = "hpre_data_wr_err" },
-	{ .int_msk = BIT(3), .msg = "hpre_data_rd_err" },
-	{ .int_msk = BIT(4), .msg = "hpre_bd_rd_err" },
-	{ .int_msk = BIT(5), .msg = "hpre_ooo_2bit_ecc_err" },
-	{ .int_msk = BIT(6), .msg = "hpre_cltr1_htbt_tm_out_err" },
-	{ .int_msk = BIT(7), .msg = "hpre_cltr2_htbt_tm_out_err" },
-	{ .int_msk = BIT(8), .msg = "hpre_cltr3_htbt_tm_out_err" },
-	{ .int_msk = BIT(9), .msg = "hpre_cltr4_htbt_tm_out_err" },
-	{ .int_msk = GENMASK(15, 10), .msg = "hpre_ooo_rdrsp_err" },
-	{ .int_msk = GENMASK(21, 16), .msg = "hpre_ooo_wrrsp_err" },
+	{ .int_msk = BIT(0), .msg = "core_ecc_1bit_err_int_set" },
+	{ .int_msk = BIT(1), .msg = "core_ecc_2bit_err_int_set" },
+	{ .int_msk = BIT(2), .msg = "dat_wb_poison_int_set" },
+	{ .int_msk = BIT(3), .msg = "dat_rd_poison_int_set" },
+	{ .int_msk = BIT(4), .msg = "bd_rd_poison_int_set" },
+	{ .int_msk = BIT(5), .msg = "ooo_ecc_2bit_err_int_set" },
+	{ .int_msk = BIT(6), .msg = "cluster1_shb_timeout_int_set" },
+	{ .int_msk = BIT(7), .msg = "cluster2_shb_timeout_int_set" },
+	{ .int_msk = BIT(8), .msg = "cluster3_shb_timeout_int_set" },
+	{ .int_msk = BIT(9), .msg = "cluster4_shb_timeout_int_set" },
+	{ .int_msk = GENMASK(15, 10), .msg = "ooo_rdrsp_err_int_set" },
+	{ .int_msk = GENMASK(21, 16), .msg = "ooo_wrrsp_err_int_set" },
 	{ /* sentinel */ }
 };
 
-- 
2.20.1



