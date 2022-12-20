Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6436517B9
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 02:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbiLTBVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 20:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiLTBVN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 20:21:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419EB765D;
        Mon, 19 Dec 2022 17:21:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E5C261209;
        Tue, 20 Dec 2022 01:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B49C433D2;
        Tue, 20 Dec 2022 01:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671499265;
        bh=Jm+x80oTDfUuDs71WlCtYCTS+kyu5Ilm1cqtGtD1kK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TrWaMc/HsI2rY8Epp+O+GtrufjE23kX+2k9nJLfp7fkdoAeA5mMqdApqEtw9Au49c
         XtOheUXI6nXVZjpVT6ryXrSMZ2kiFBLK48ry+5vij+wZd50uLZNOLpcnLNjsDWN6E4
         R12AU9bVL4go+cEZRYvqVwJssn6j1IUrwdQQQnPcBks//tRwQnbpEPAOWhugbqxgxj
         WB0DgYpVqVmwNChCuSdxm9jZv6+GdoGsIDUyki8fjSVWRIj2DwKTTcH2l8YmBfFaQ0
         a1+vvMrqrvDOLojnK2IjmPjgaEF5p4VlIxziSznn9D3VkX0sqZ76rjqvkmdrzXLcZ6
         TOxOqfrtk1qGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Ye <yekai13@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, qianweili@huawei.com,
        wangzhou1@hisilicon.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 04/16] crypto: hisilicon/qm - increase the memory of local variables
Date:   Mon, 19 Dec 2022 20:20:41 -0500
Message-Id: <20221220012053.1222101-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221220012053.1222101-1-sashal@kernel.org>
References: <20221220012053.1222101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Ye <yekai13@huawei.com>

[ Upstream commit 3efe90af4c0c46c58dba1b306de142827153d9c0 ]

Increase the buffer to prevent stack overflow by fuzz test. The maximum
length of the qos configuration buffer is 256 bytes. Currently, the value
of the 'val buffer' is only 32 bytes. The sscanf does not check the dest
memory length. So the 'val buffer' may stack overflow.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 8b387de69d22..335e58018a31 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -250,7 +250,6 @@
 #define QM_QOS_MIN_CIR_B		100
 #define QM_QOS_MAX_CIR_U		6
 #define QM_QOS_MAX_CIR_S		11
-#define QM_QOS_VAL_MAX_LEN		32
 #define QM_DFX_BASE		0x0100000
 #define QM_DFX_STATE1		0x0104000
 #define QM_DFX_STATE2		0x01040C8
@@ -4614,7 +4613,7 @@ static ssize_t qm_get_qos_value(struct hisi_qm *qm, const char *buf,
 			       unsigned int *fun_index)
 {
 	char tbuf_bdf[QM_DBG_READ_LEN] = {0};
-	char val_buf[QM_QOS_VAL_MAX_LEN] = {0};
+	char val_buf[QM_DBG_READ_LEN] = {0};
 	u32 tmp1, device, function;
 	int ret, bus;
 
-- 
2.35.1

