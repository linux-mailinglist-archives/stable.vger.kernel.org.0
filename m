Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0A8378734
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237114AbhEJLOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:14:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236171AbhEJLHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B8DC61938;
        Mon, 10 May 2021 10:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644322;
        bh=sxcFWR7+uvNZG7VaXezJitXakTFWveoce4hP0zX2wH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yy02pF34yyfzQPGEBbiqOi7AdkkIc860oEap8iLYCw1yN02qX8PYGzkBeU1dOZIjF
         uTroiTemVlB/pzbiKtYRT570m6r/RvWWZCJ74ohi90BdayaaPNwLXtyTfXAmoDZ4N3
         0v5GUJJPZPc3InhHFOxB5wd4ZeZ3r832NzKm+lAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.12 004/384] bus: mhi: core: Add missing checks for MMIO register entries
Date:   Mon, 10 May 2021 12:16:33 +0200
Message-Id: <20210510102015.003755112@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhaumik Bhatt <bbhatt@codeaurora.org>

commit 8de5ad99414347ad08e6ebc2260be1d2e009cb9a upstream.

As per documentation, fields marked as (required) in an MHI
controller structure need to be populated by the controller driver
before calling mhi_register_controller(). Ensure all required
pointers and non-zero fields are present in the controller before
proceeding with the registration.

Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Reviewed-by: Jeffrey Hugo <jhugo@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/1615315490-36017-1-git-send-email-bbhatt@codeaurora.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/core/init.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -876,12 +876,10 @@ int mhi_register_controller(struct mhi_c
 	u32 soc_info;
 	int ret, i;
 
-	if (!mhi_cntrl)
-		return -EINVAL;
-
-	if (!mhi_cntrl->runtime_get || !mhi_cntrl->runtime_put ||
+	if (!mhi_cntrl || !mhi_cntrl->cntrl_dev || !mhi_cntrl->regs ||
+	    !mhi_cntrl->runtime_get || !mhi_cntrl->runtime_put ||
 	    !mhi_cntrl->status_cb || !mhi_cntrl->read_reg ||
-	    !mhi_cntrl->write_reg || !mhi_cntrl->nr_irqs)
+	    !mhi_cntrl->write_reg || !mhi_cntrl->nr_irqs || !mhi_cntrl->irq)
 		return -EINVAL;
 
 	ret = parse_config(mhi_cntrl, config);


