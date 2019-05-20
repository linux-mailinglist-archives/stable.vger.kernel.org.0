Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C87C723761
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732248AbfETMrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:47:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388895AbfETMYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:24:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6909D216C4;
        Mon, 20 May 2019 12:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355081;
        bh=Uw0pF31YOHlAKBRVzNCneThPQgBmKK3R8VVsUrLP+AI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fHXknbxcp5YuhxEXK4Em1yXF48PFoRnubZ9VZfxZ8NSWLy1wS/iY1p6RYqeUdhawo
         zzATjQYDqgQ/a4maLa2YxlpLhVnK9A7hTSeWHF54zMiKZYqA95FsDtKRduznkiAFnA
         4sXjcBewaxzjuhhb6PDjQTj0rtBWmO9NwUSaTwAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 049/105] crypto: ccree - pm resume first enable the source clk
Date:   Mon, 20 May 2019 14:13:55 +0200
Message-Id: <20190520115250.419216080@linuxfoundation.org>
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

commit 7766dd774d80463cec7b81d90c8672af91de2da1 upstream.

On power management resume function first enable the device clk source
to allow access to the device registers.

Signed-off-by: Ofir Drang <ofir.drang@arm.com>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccree/cc_pm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -42,14 +42,15 @@ int cc_pm_resume(struct device *dev)
 	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
 
 	dev_dbg(dev, "unset HOST_POWER_DOWN_EN\n");
-	cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_DISABLE);
-
+	/* Enables the device source clk */
 	rc = cc_clk_on(drvdata);
 	if (rc) {
 		dev_err(dev, "failed getting clock back on. We're toast.\n");
 		return rc;
 	}
 
+	cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_DISABLE);
+
 	rc = init_cc_regs(drvdata, false);
 	if (rc) {
 		dev_err(dev, "init_cc_regs (%x)\n", rc);


