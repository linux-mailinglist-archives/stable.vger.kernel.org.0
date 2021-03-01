Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B62C328C3E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235902AbhCASrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:47:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:51554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240172AbhCASl7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:41:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC6F664F72;
        Mon,  1 Mar 2021 17:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618403;
        bh=C+lypmXzClL1DQ+g9IH4CZLXoIDxnhDXXUmlOd7aj/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n4gan/1urjiOHz+cx+IGY/dOBI0IPUsPSW+6G+NnQtln+ochVkolr7F7pct90uoUf
         6EojXTqmbdG/8QRzdPwq2DEZoz3+95EGRLKpn5HegiMc+GX8L3l4hBnW2Yiv8hYAAK
         U+aVWepZm5WyhuM0pxZ9HShHRUqPst3AdO+JRfaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Masney <masneyb@onstation.org>,
        Luca Weiss <luca@z3ntu.xyz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/663] soc: qcom: ocmem: dont return NULL in of_get_ocmem
Date:   Mon,  1 Mar 2021 17:05:23 +0100
Message-Id: <20210301161145.447090044@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit 01f937ffc4686837d6c43dea80c6ade6cbd2940a ]

If ocmem probe fails for whatever reason, of_get_ocmem returned NULL.
Without this, users must check for both NULL and IS_ERR on the returned
pointer - which didn't happen in drivers/gpu/drm/msm/adreno/adreno_gpu.c
leading to a NULL pointer dereference.

Reviewed-by: Brian Masney <masneyb@onstation.org>
Fixes: 88c1e9404f1d ("soc: qcom: add OCMEM driver")
Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Link: https://lore.kernel.org/r/20210130142349.53335-1-luca@z3ntu.xyz
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/ocmem.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/ocmem.c b/drivers/soc/qcom/ocmem.c
index 7f9e9944d1eae..f1875dc31ae2c 100644
--- a/drivers/soc/qcom/ocmem.c
+++ b/drivers/soc/qcom/ocmem.c
@@ -189,6 +189,7 @@ struct ocmem *of_get_ocmem(struct device *dev)
 {
 	struct platform_device *pdev;
 	struct device_node *devnode;
+	struct ocmem *ocmem;
 
 	devnode = of_parse_phandle(dev->of_node, "sram", 0);
 	if (!devnode || !devnode->parent) {
@@ -202,7 +203,12 @@ struct ocmem *of_get_ocmem(struct device *dev)
 		return ERR_PTR(-EPROBE_DEFER);
 	}
 
-	return platform_get_drvdata(pdev);
+	ocmem = platform_get_drvdata(pdev);
+	if (!ocmem) {
+		dev_err(dev, "Cannot get ocmem\n");
+		return ERR_PTR(-ENODEV);
+	}
+	return ocmem;
 }
 EXPORT_SYMBOL(of_get_ocmem);
 
-- 
2.27.0



