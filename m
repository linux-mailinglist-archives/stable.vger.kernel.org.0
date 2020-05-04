Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F3C1C4514
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731360AbgEDSCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:02:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731356AbgEDSCh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:02:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C41620746;
        Mon,  4 May 2020 18:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615357;
        bh=VN6d4nzbrLNjgkAvTHCF4tjP+1SiphgWn7ph4Scj52s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLyxRac4QXwWptZw9TV/U31bbAfwdMc3UJmyyV51qsSKt8/laFqdFt6uPboTWUr1a
         oRfryn/kekEr+rQ0Jf8rbKA2RfitezAfTHh0Ku7w/Iq0GdI1VEcwgutkEjHoZVOzxl
         eF8i44DakwJLrR6xYnHj8WkpQIFAUZN6bzCE5N3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tang Bin <tangbin@cmss.chinamobile.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4.19 23/37] iommu/qcom: Fix local_base status check
Date:   Mon,  4 May 2020 19:57:36 +0200
Message-Id: <20200504165450.779338785@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165448.264746645@linuxfoundation.org>
References: <20200504165448.264746645@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>

commit b52649aee6243ea661905bdc5fbe28cc5f6dec76 upstream.

The function qcom_iommu_device_probe() does not perform sufficient
error checking after executing devm_ioremap_resource(), which can
result in crashes if a critical error path is encountered.

Fixes: 0ae349a0f33f ("iommu/qcom: Add qcom_iommu")
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20200418134703.1760-1-tangbin@cmss.chinamobile.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/qcom_iommu.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/iommu/qcom_iommu.c
+++ b/drivers/iommu/qcom_iommu.c
@@ -797,8 +797,11 @@ static int qcom_iommu_device_probe(struc
 	qcom_iommu->dev = dev;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res)
+	if (res) {
 		qcom_iommu->local_base = devm_ioremap_resource(dev, res);
+		if (IS_ERR(qcom_iommu->local_base))
+			return PTR_ERR(qcom_iommu->local_base);
+	}
 
 	qcom_iommu->iface_clk = devm_clk_get(dev, "iface");
 	if (IS_ERR(qcom_iommu->iface_clk)) {


