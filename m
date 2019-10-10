Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1CBD2474
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388067AbfJJIpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:45:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388040AbfJJIpT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:45:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B32082190F;
        Thu, 10 Oct 2019 08:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697119;
        bh=ZwsGgjl9+rpPm+dqONwrfFcqeSGtvnpm4WmFQaz5YAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OSToX5ToT7bCOOYatyymi+59f8TuFk6CFvXEr5XVvSKjAorhg/Dv2t3MrkwxC3myj
         IQkuyn0IaBO62FoE8Dpch/TwYf6mK8egKcWaW4hFrod8vM3q9Kw5E57Uu+ZQDrPBlO
         wJyua5buN0fG+LgyWIpw89abo4k61xz5XaW6mbK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 025/114] crypto: ccree - account for TEE not ready to report
Date:   Thu, 10 Oct 2019 10:35:32 +0200
Message-Id: <20191010083555.614023425@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

commit 76a95bd8f9e10cade9c4c8df93b5c20ff45dc0f5 upstream.

When ccree driver runs it checks the state of the Trusted Execution
Environment CryptoCell driver before proceeding. We did not account
for cases where the TEE side is not ready or not available at all.
Fix it by only considering TEE error state after sync with the TEE
side driver.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Fixes: ab8ec9658f5a ("crypto: ccree - add FIPS support")
CC: stable@vger.kernel.org # v4.17+
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccree/cc_fips.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/crypto/ccree/cc_fips.c
+++ b/drivers/crypto/ccree/cc_fips.c
@@ -21,7 +21,13 @@ static bool cc_get_tee_fips_status(struc
 	u32 reg;
 
 	reg = cc_ioread(drvdata, CC_REG(GPR_HOST));
-	return (reg == (CC_FIPS_SYNC_TEE_STATUS | CC_FIPS_SYNC_MODULE_OK));
+	/* Did the TEE report status? */
+	if (reg & CC_FIPS_SYNC_TEE_STATUS)
+		/* Yes. Is it OK? */
+		return (reg & CC_FIPS_SYNC_MODULE_OK);
+
+	/* No. It's either not in use or will be reported later */
+	return true;
 }
 
 /*


