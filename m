Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4CA247218
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbgHQSiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:38:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388141AbgHQP6i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:58:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D93A1206FA;
        Mon, 17 Aug 2020 15:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679917;
        bh=tUyQ7JpyxQCiTaMfaKNXuEnfPYLvnXB2tbmFxJwSzBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQ1vlvNAL2oaPjog8Qt+YZpkUr4NWVo/xJBv7L4ECShxbvQyBKhJSnHMTBErbk/jU
         nz4gHM1zd6n+H1hTiXpwf02ZiA6/SPo8pdxdaolV2ip9aVcH0a5GPNFjzk/TZUVHSh
         NsIwVHswPW+EQE+O7ms/qf39X14ErBCQ8h2NzsNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elliot Berman <eberman@codeaurora.org>,
        Jonathan McDowell <noodles@earth.li>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.7 378/393] firmware: qcom_scm: Fix legacy convention SCM accessors
Date:   Mon, 17 Aug 2020 17:17:08 +0200
Message-Id: <20200817143837.944460925@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan McDowell <noodles@earth.li>

commit b88c28280c3f7097546db93824686db1e7dceee1 upstream.

The move to a combined driver for the QCOM SCM hardware changed the
io_writel and io_readl helpers to use non-atomic calls, despite the
commit message saying that atomic was a better option. This breaks these
helpers on hardware that uses the old legacy convention (access fails
with a -95 return code). Switch back to using the atomic calls.

Observed as a failure routing GPIO interrupts to the Apps processor on
an IPQ8064; fix is confirmed as correctly allowing the interrupts to be
routed and observed.

Reviewed-by: Elliot Berman <eberman@codeaurora.org>
Fixes: 57d3b816718c ("firmware: qcom_scm: Remove thin wrappers")
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan McDowell <noodles@earth.li>
Link: https://lore.kernel.org/r/20200704172334.GA759@earth.li
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/qcom_scm.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -391,7 +391,7 @@ static int __qcom_scm_set_dload_mode(str
 
 	desc.args[1] = enable ? QCOM_SCM_BOOT_SET_DLOAD_MODE : 0;
 
-	return qcom_scm_call(__scm->dev, &desc, NULL);
+	return qcom_scm_call_atomic(__scm->dev, &desc, NULL);
 }
 
 static void qcom_scm_set_download_mode(bool enable)
@@ -650,7 +650,7 @@ int qcom_scm_io_readl(phys_addr_t addr,
 	int ret;
 
 
-	ret = qcom_scm_call(__scm->dev, &desc, &res);
+	ret = qcom_scm_call_atomic(__scm->dev, &desc, &res);
 	if (ret >= 0)
 		*val = res.result[0];
 
@@ -669,8 +669,7 @@ int qcom_scm_io_writel(phys_addr_t addr,
 		.owner = ARM_SMCCC_OWNER_SIP,
 	};
 
-
-	return qcom_scm_call(__scm->dev, &desc, NULL);
+	return qcom_scm_call_atomic(__scm->dev, &desc, NULL);
 }
 EXPORT_SYMBOL(qcom_scm_io_writel);
 


