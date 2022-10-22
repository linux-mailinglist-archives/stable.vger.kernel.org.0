Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 823FD6088B5
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbiJVIVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233834AbiJVITv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:19:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60ADC2B5B8C;
        Sat, 22 Oct 2022 00:58:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECACEB82E2A;
        Sat, 22 Oct 2022 07:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32420C433D6;
        Sat, 22 Oct 2022 07:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425459;
        bh=hofricjNNRe79eBTRgopoPwZestWeMR5bnWXab1Fj6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=htWat0QuOSoy17Pqgav53Szc8WuA+P0SDuXXJNbqW5hf72+/FzBdoLL2MLVIqrPUa
         JLIGwf1UtgL1RtsCSc5a6xU5sRdimjxwDG2mnKzTV/ynUqDF8A/bVStIUwDMMnMTqY
         Dbrn0KNzPBf4SILREXnk7G4azZNaI00l3BfHsqzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Weihua <yeweihua4@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 508/717] crypto: hisilicon/zip - fix mismatch in get/set sgl_sge_nr
Date:   Sat, 22 Oct 2022 09:26:27 +0200
Message-Id: <20221022072520.733510815@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Weihua <yeweihua4@huawei.com>

[ Upstream commit d74f9340097a881869c4c22ca376654cc2516ecc ]

KASAN reported this Bug:

	[17619.659757] BUG: KASAN: global-out-of-bounds in param_get_int+0x34/0x60
	[17619.673193] Read of size 4 at addr fffff01332d7ed00 by task read_all/1507958
	...
	[17619.698934] The buggy address belongs to the variable:
	[17619.708371]  sgl_sge_nr+0x0/0xffffffffffffa300 [hisi_zip]

There is a mismatch in hisi_zip when get/set the variable sgl_sge_nr.
The type of sgl_sge_nr is u16, and get/set sgl_sge_nr by
param_get/set_int.

Replacing param_get/set_int to param_get/set_ushort can fix this bug.

Fixes: f081fda293ffb ("crypto: hisilicon - add sgl_sge_nr module param for zip")
Signed-off-by: Ye Weihua <yeweihua4@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/zip/zip_crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index 67869513e48c..d90b10ae005b 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -122,12 +122,12 @@ static int sgl_sge_nr_set(const char *val, const struct kernel_param *kp)
 	if (ret || n == 0 || n > HISI_ACC_SGL_SGE_NR_MAX)
 		return -EINVAL;
 
-	return param_set_int(val, kp);
+	return param_set_ushort(val, kp);
 }
 
 static const struct kernel_param_ops sgl_sge_nr_ops = {
 	.set = sgl_sge_nr_set,
-	.get = param_get_int,
+	.get = param_get_ushort,
 };
 
 static u16 sgl_sge_nr = HZIP_SGL_SGE_NR;
-- 
2.35.1



