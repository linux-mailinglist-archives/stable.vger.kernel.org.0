Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F173B435E
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 14:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbhFYMhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 08:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbhFYMg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Jun 2021 08:36:58 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090A8C0617A6
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 05:34:34 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id bb20so5372620pjb.3
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 05:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g+lLagFeszou/6sKi0JtQNyDv5OxzHHtHPuB74dMzb0=;
        b=S83L6xztJyvMDdrDFudWRKLH2YgerUT+jvHanW2eS+hr0VefoDlCCLQxtDG9RwEV9B
         WocxhY2bygwxU1a+h4YRatVNm8Pu+p4kQpIR8AV9HJrzPaZs+wbPsujVvyhJKbHhIvnl
         3fZcwkDXnx1o4sS6fWNHoN4vjTJAgsJ2wD1ObNa1zhzvz8iFz0QlLAHr5uk/rBNJV2kR
         SOgH278CQrhzmGgm1dmbaVUnnZpckIYDupAzYRTE2bV7GLro+DD9xhXf66jyWaS4p8zf
         ezLhNM1qCEhYlr9VM+CsGs1HiVKqFI0gzDpDylrcMlWu5BXXUazz665O5/OV5520le5H
         +YjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g+lLagFeszou/6sKi0JtQNyDv5OxzHHtHPuB74dMzb0=;
        b=QNmiNZ/C0d1n4k1b4oJamd4VBE63OWyI2wBHxz/wqgMH4isOL5RrB8pT5Z7mt1t+JM
         6CI91s5nT7dM2rheaKhthUXL05z0YE6m868O83+PcP4CRncacHE/EQ6IFh9bXU98dxnJ
         oRVhddRTIVexZFTsgTQ3t1mnmtQI/84bM7XniJl2BEwQGY8DhQVU7UgcIHlYmulzUUBM
         uQzG8DIHkb/INcbB19Xb5gnAo/TdzSExfzD0iEmc8NMmtyEKR3NItF3trAbfuKEIrz/k
         oRgIIz/k4N+WhJg6eDCUq3NkCE0zracjV7xkYF/OioJf0ij+41bDZW83/HAPLIejGb1K
         iMYw==
X-Gm-Message-State: AOAM531bwCIAFJunhEi1DI+Wr7Fi8rlAVdDQeoXcyaY0+wLbpzf8NmRE
        gdY44fNsfUzRI55//E4GJEpJ
X-Google-Smtp-Source: ABdhPJzMZ0sOSaatnSTaZkqhHA4ywNY1d3PNVi04GVU9+0MP7fahzw4gCxdrSqgZJUQYYbQaEALb1g==
X-Received: by 2002:a17:90b:603:: with SMTP id gb3mr11364268pjb.230.1624624473578;
        Fri, 25 Jun 2021 05:34:33 -0700 (PDT)
Received: from localhost.localdomain ([2409:4072:600b:2a0:ed5d:53e7:c64e:1bac])
        by smtp.gmail.com with ESMTPSA id y7sm6077780pfy.153.2021.06.25.05.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 05:34:32 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     hemantk@codeaurora.org, bbhatt@codeaurora.org,
        linux-arm-msm@vger.kernel.org, jhugo@codeaurora.org,
        linux-kernel@vger.kernel.org, loic.poulain@linaro.org,
        kvalo@codeaurora.org, ath11k@lists.infradead.org,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Jeffrey Hugo <quic_jhugo@quicinc.com>
Subject: [PATCH 04/10] bus: mhi: core: Validate channel ID when processing command completions
Date:   Fri, 25 Jun 2021 18:03:49 +0530
Message-Id: <20210625123355.11578-5-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210625123355.11578-1-manivannan.sadhasivam@linaro.org>
References: <20210625123355.11578-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhaumik Bhatt <bbhatt@codeaurora.org>

MHI reads the channel ID from the event ring element sent by the
device which can be any value between 0 and 255. In order to
prevent any out of bound accesses, add a check against the maximum
number of channels supported by the controller and those channels
not configured yet so as to skip processing of that event ring
element.

Cc: stable@vger.kernel.org
Fixes: 1d3173a3bae7 ("bus: mhi: core: Add support for processing events from client device")
Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://lore.kernel.org/r/1624558141-11045-1-git-send-email-bbhatt@codeaurora.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/core/main.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
index 69cd9dcde6d8..26bbc812121d 100644
--- a/drivers/bus/mhi/core/main.c
+++ b/drivers/bus/mhi/core/main.c
@@ -773,11 +773,18 @@ static void mhi_process_cmd_completion(struct mhi_controller *mhi_cntrl,
 	cmd_pkt = mhi_to_virtual(mhi_ring, ptr);
 
 	chan = MHI_TRE_GET_CMD_CHID(cmd_pkt);
-	mhi_chan = &mhi_cntrl->mhi_chan[chan];
-	write_lock_bh(&mhi_chan->lock);
-	mhi_chan->ccs = MHI_TRE_GET_EV_CODE(tre);
-	complete(&mhi_chan->completion);
-	write_unlock_bh(&mhi_chan->lock);
+
+	if (chan < mhi_cntrl->max_chan &&
+	    mhi_cntrl->mhi_chan[chan].configured) {
+		mhi_chan = &mhi_cntrl->mhi_chan[chan];
+		write_lock_bh(&mhi_chan->lock);
+		mhi_chan->ccs = MHI_TRE_GET_EV_CODE(tre);
+		complete(&mhi_chan->completion);
+		write_unlock_bh(&mhi_chan->lock);
+	} else {
+		dev_err(&mhi_cntrl->mhi_dev->dev,
+			"Completion packet for invalid channel ID: %d\n", chan);
+	}
 
 	mhi_del_ring_element(mhi_cntrl, mhi_ring);
 }
-- 
2.25.1

