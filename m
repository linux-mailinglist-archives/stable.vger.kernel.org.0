Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9422375E
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388284AbfETMYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:24:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388923AbfETMYu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:24:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8013D21479;
        Mon, 20 May 2019 12:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355090;
        bh=evbFVzhLxEg4SbCoKYUaCDJhdyPgsuUfMr8WxKWYoSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqratxeL/FEKfOGSyHQUmgwR74/LuMarNB0TwFfK5VbzhXxucbS+xR6C1vD54CGYv
         Vj5aCPKmfusRZPnKUmAIAUHZelcK2hcvFHv9c3r71n5oO59g2/KfASPpITBsfSVrqo
         3Xzm68uiPsbix5gYo5UFQITSNGsW6gMtQRvn0Nzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 052/105] crypto: ccree - handle tee fips error during power management resume
Date:   Mon, 20 May 2019 14:13:58 +0200
Message-Id: <20190520115250.648743917@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ofir Drang <ofir.drang@arm.com>

commit 7138377ce10455b7183c6dde4b2c51b33f464c45 upstream.

in order to support cryptocell tee fips error that may occurs while
cryptocell ree is suspended, an cc_tee_handle_fips_error  call added
to the cc_pm_resume function.

Signed-off-by: Ofir Drang <ofir.drang@arm.com>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccree/cc_pm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -11,6 +11,7 @@
 #include "cc_ivgen.h"
 #include "cc_hash.h"
 #include "cc_pm.h"
+#include "cc_fips.h"
 
 #define POWER_DOWN_ENABLE 0x01
 #define POWER_DOWN_DISABLE 0x00
@@ -50,12 +51,13 @@ int cc_pm_resume(struct device *dev)
 	}
 
 	cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_DISABLE);
-
 	rc = init_cc_regs(drvdata, false);
 	if (rc) {
 		dev_err(dev, "init_cc_regs (%x)\n", rc);
 		return rc;
 	}
+	/* check if tee fips error occurred during power down */
+	cc_tee_handle_fips_error(drvdata);
 
 	rc = cc_resume_req_queue(drvdata);
 	if (rc) {


