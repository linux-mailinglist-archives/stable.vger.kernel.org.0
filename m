Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B64C2375C
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388347AbfETMYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:24:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388502AbfETMYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:24:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3568421479;
        Mon, 20 May 2019 12:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355084;
        bh=N9QFeO4yQVMQCWzkv0CVm3igV/vAF6zg1t8BEEZGIbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahne2PDQSWZq8HCKGvhI9xFDo26wLPwCLzV+WBr0bt4q1qC263BVV18NUbP2uqZjU
         qYzafox2TF8bwAMoSxp0nrVpUabnPxRR+OS0uQjresGdHxLkQiS9+fcjjhcpzW3opX
         PI9D0xuJoKMaaqf5mVh3QLs4Kc8SchpI79wc/vzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 050/105] crypto: ccree - HOST_POWER_DOWN_EN should be the last CC access during suspend
Date:   Mon, 20 May 2019 14:13:56 +0200
Message-Id: <20190520115250.492893602@linuxfoundation.org>
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

commit 3499efbeed39d114873267683b9e776bcb34b058 upstream.

During power management suspend the driver need to prepare the device
for the power down operation and as a last indication write to the
HOST_POWER_DOWN_EN register which signals to the hardware that
The ccree is ready for power down.

Signed-off-by: Ofir Drang <ofir.drang@arm.com>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccree/cc_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -25,13 +25,13 @@ int cc_pm_suspend(struct device *dev)
 	int rc;
 
 	dev_dbg(dev, "set HOST_POWER_DOWN_EN\n");
-	cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_ENABLE);
 	rc = cc_suspend_req_queue(drvdata);
 	if (rc) {
 		dev_err(dev, "cc_suspend_req_queue (%x)\n", rc);
 		return rc;
 	}
 	fini_cc_regs(drvdata);
+	cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_ENABLE);
 	cc_clk_off(drvdata);
 	return 0;
 }


