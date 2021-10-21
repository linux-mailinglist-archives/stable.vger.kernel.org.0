Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1D8435863
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 03:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhJUBpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 21:45:51 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:10105 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhJUBpu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 21:45:50 -0400
X-Greylist: delayed 545 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Oct 2021 21:45:49 EDT
Received: from spf.mail.chinamobile.com (unknown[172.16.121.1]) by rmmx-syy-dmz-app12-12012 (RichMail) with SMTP id 2eec6170c3980c2-0f6a2; Thu, 21 Oct 2021 09:34:17 +0800 (CST)
X-RM-TRANSID: 2eec6170c3980c2-0f6a2
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.112.105.130])
        by rmsmtp-syy-appsvr01-12001 (RichMail) with SMTP id 2ee16170c395d66-33509;
        Thu, 21 Oct 2021 09:34:16 +0800 (CST)
X-RM-TRANSID: 2ee16170c395d66-33509
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     krzysztof.kozlowski@canonical.com, vz@mleia.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>, stable@vger.kernel.org
Subject: [PATCH v3] crypto: s5p-sss - Add error handling in s5p_aes_probe()
Date:   Thu, 21 Oct 2021 09:34:22 +0800
Message-Id: <20211021013422.21396-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The function s5p_aes_probe() does not perform sufficient error
checking after executing platform_get_resource(), thus fix it.

Fixes: c2afad6c6105 ("crypto: s5p-sss - Add HASH support for Exynos")
Cc: <stable@vger.kernel.org>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
Changes from v2
 - add Cc: <stable@vger.kernel.org>

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



