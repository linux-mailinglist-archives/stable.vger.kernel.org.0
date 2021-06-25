Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3389F3B4362
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 14:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhFYMhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 08:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbhFYMhL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Jun 2021 08:37:11 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45172C0613A4
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 05:34:46 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id 21so7953886pfp.3
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 05:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sNO7OvoezOyKwRQqQPCTAGHXfd3P08Ex5P2XMikHwWs=;
        b=e9MtdpfGHP20g++UmMZA7v/PwkSWPmVAUxQ1kUZC76KT2yBOov0+XQs6prxQxXR2JU
         J0RlewuEWXnVf2dy2yeBZdZvVDfV1jC9PF/xziGneT/XMx/iRdxdAEc1r96xrIy9l816
         0FUtsFEgPVbP2Xzfvlg3QF9t/1vkQYKDmQATgckKnyMnzIATgGlSYnDkUEwedWOUS8QP
         H/5EMgjlapCD/mrgLvIj1zFWhWCdZo4jYMFjww3c4QC8gjDF54bKWDxx9HVEicB4mjjK
         l/AVlaKHWQaTME7XvE/XUSA8Lu219Qp/aiGadiyAhw1kKyHSIgoqN+r9Cl7BBUEHpIWf
         QHnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sNO7OvoezOyKwRQqQPCTAGHXfd3P08Ex5P2XMikHwWs=;
        b=rp5kLbeYzmgmi4xQCYm9G9cOaBKeNCi5fPsE4J2q+IqGFPq5bfsuup8YC7De2NdmeC
         IWftmoGFa10uXX/rhUBuRyMS+ek3sohb944HAVB2wVRx7s8bTlEHmq4Co4sBgrMO1unG
         SWjwYMQYstkAAQo2d0ChUxAKnCrrV/RDeA3RgnJF0hTdKXa7Ktvikqe+U+JCXruSsN4x
         VWgc5ASV8CRRbQ+zl1J5W+TBaoGC4/JjI02ZttaWA/WpJhB+5EHdDT0OypsftgMFDBoV
         mxo9ca6y5i+tACLWZEHbdDECJp/8wPy6TSIXP+yfIylHxJzPsvhasi6Mj1Wx16pIyXp2
         5E5Q==
X-Gm-Message-State: AOAM532DCiWXVUMXLwTJDHJfoVAiaVZ0fL4+3gk5lnjLJMz4s6e/E+m0
        fOU3TnabKmqejvMjSIWQAtS4
X-Google-Smtp-Source: ABdhPJxG2i6xZEvuWCUBDKfc9EaIHgiHlAUIJ5/atMQPCixk52P1mNDwspVOrh28gdRWtiQ4AGZbpw==
X-Received: by 2002:a63:7404:: with SMTP id p4mr9338107pgc.405.1624624485806;
        Fri, 25 Jun 2021 05:34:45 -0700 (PDT)
Received: from localhost.localdomain ([2409:4072:600b:2a0:ed5d:53e7:c64e:1bac])
        by smtp.gmail.com with ESMTPSA id y7sm6077780pfy.153.2021.06.25.05.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 05:34:45 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     hemantk@codeaurora.org, bbhatt@codeaurora.org,
        linux-arm-msm@vger.kernel.org, jhugo@codeaurora.org,
        linux-kernel@vger.kernel.org, loic.poulain@linaro.org,
        kvalo@codeaurora.org, ath11k@lists.infradead.org,
        stable@vger.kernel.org, Jeffrey Hugo <quic_jhugo@quicinc.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 06/10] bus: mhi: core: Set BHI and BHIe pointers to NULL in clean-up
Date:   Fri, 25 Jun 2021 18:03:51 +0530
Message-Id: <20210625123355.11578-7-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210625123355.11578-1-manivannan.sadhasivam@linaro.org>
References: <20210625123355.11578-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhaumik Bhatt <bbhatt@codeaurora.org>

Set the BHI and BHIe pointers to NULL as part of clean-up. This
makes sure that stale pointers are not accessed after powering
MHI down.

Cc: stable@vger.kernel.org
Suggested-by: Hemant Kumar <hemantk@codeaurora.org>
Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/1620330705-40192-3-git-send-email-bbhatt@codeaurora.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/core/init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
index 11c7a3d3c9bf..1cc2f225d3d1 100644
--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -1132,6 +1132,9 @@ void mhi_unprepare_after_power_down(struct mhi_controller *mhi_cntrl)
 		mhi_cntrl->rddm_image = NULL;
 	}
 
+	mhi_cntrl->bhi = NULL;
+	mhi_cntrl->bhie = NULL;
+
 	mhi_deinit_dev_ctxt(mhi_cntrl);
 }
 EXPORT_SYMBOL_GPL(mhi_unprepare_after_power_down);
-- 
2.25.1

