Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A7B4349BC
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 13:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhJTLIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 07:08:39 -0400
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:25964 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbhJTLIi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 07:08:38 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.9]) by rmmx-syy-dmz-app08-12008 (RichMail) with SMTP id 2ee8616ff822b7d-09242; Wed, 20 Oct 2021 19:06:10 +0800 (CST)
X-RM-TRANSID: 2ee8616ff822b7d-09242
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.112.105.130])
        by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee5616ff81f86e-1d843;
        Wed, 20 Oct 2021 19:06:10 +0800 (CST)
X-RM-TRANSID: 2ee5616ff81f86e-1d843
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     krzysztof.kozlowski@canonical.com, vz@mleia.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>
Subject: [PATCH v2] crypto: s5p-sss - Add error handling in s5p_aes_probe()
Date:   Wed, 20 Oct 2021 19:06:24 +0800
Message-Id: <20211020110624.47696-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The function s5p_aes_probe() does not perform sufficient error
checking after executing platform_get_resource(), thus fix it.

Fixes: c2afad6c6105 ("crypto: s5p-sss - Add HASH support for Exynos")
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
Changes from v1
 - add fixed title
---
 drivers/crypto/s5p-sss.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 55aa3a711..7717e9e59 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -2171,6 +2171,8 @@ static int s5p_aes_probe(struct platform_device *pdev)
 
 	variant = find_s5p_sss_version(pdev);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
 
 	/*
 	 * Note: HASH and PRNG uses the same registers in secss, avoid
-- 
2.20.1.windows.1



