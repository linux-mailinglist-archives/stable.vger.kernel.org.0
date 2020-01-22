Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5AF14519F
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbgAVJc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:32:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730261AbgAVJcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:32:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5ACBA24672;
        Wed, 22 Jan 2020 09:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685574;
        bh=zun0gG8f7XId1Idl6FRio3cy76k8PfGV/AV0jKqudLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zaz3JSL9t/9fcHkGV0zihQvjHgPEKM6BIiwA/CGSz8gy5GjWNE+ZcHwF0sCwAjDgx
         BB1Pu37cHxYmcmwiHPNUVDe8CfOC4LnB2ib9FnpPHPj6SM+dKZpmmb9iynZ7HBjp9w
         OenHMF70rN52pI67zDSHNitBrIBthnVMsgnxzEro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.4 68/76] cw1200: Fix a signedness bug in cw1200_load_firmware()
Date:   Wed, 22 Jan 2020 10:29:24 +0100
Message-Id: <20200122092801.757074212@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092751.587775548@linuxfoundation.org>
References: <20200122092751.587775548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 4a50d454502f1401171ff061a5424583f91266db upstream.

The "priv->hw_type" is an enum and in this context GCC will treat it
as an unsigned int so the error handling will never trigger.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/cw1200/fwio.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/cw1200/fwio.c
+++ b/drivers/net/wireless/cw1200/fwio.c
@@ -323,12 +323,12 @@ int cw1200_load_firmware(struct cw1200_c
 		goto out;
 	}
 
-	priv->hw_type = cw1200_get_hw_type(val32, &major_revision);
-	if (priv->hw_type < 0) {
+	ret = cw1200_get_hw_type(val32, &major_revision);
+	if (ret < 0) {
 		pr_err("Can't deduce hardware type.\n");
-		ret = -ENOTSUPP;
 		goto out;
 	}
+	priv->hw_type = ret;
 
 	/* Set DPLL Reg value, and read back to confirm writes work */
 	ret = cw1200_reg_write_32(priv, ST90TDS_TSET_GEN_R_W_REG_ID,


