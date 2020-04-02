Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBEE719C97F
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389109AbgDBTLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:11:40 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50680 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731689AbgDBTLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:11:40 -0400
Received: by mail-wm1-f66.google.com with SMTP id t128so4646402wma.0
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Jummrcf5rvKAi6eH2KyVwYJGqNxV7PrPZlMxGnwq5Ts=;
        b=uFy/GCfGdxFp2lryU43f5joIxwAkP+0y5u8w2OaclI2U1iFS0lteQiiS4s+Ao+X6C1
         OQXH8Z5N0YGhAckdFWoCD60dxsTZDEvAbgBF5n27CqOgGAHKcJh36oyisayOIVZMJbnb
         jFddnNzLrmCSkc5AeMZ6v4HHcaHwP+XI4UcO1gOIkk/Ygzjl6alnKOmUvHDlVkP5Bc4c
         1PIUS9YC30zYsithwh5j7TvsmXp3dRK6/qH3BSbHx0ZHyzXCdsne/+eV+HvzTyqUvr9E
         4wBzcGbcWNlnmgfnw04Qvqmnsgba2ixXcPipm4hirW/w74Z1GZravr4Twu0jRLKZaomd
         bPEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jummrcf5rvKAi6eH2KyVwYJGqNxV7PrPZlMxGnwq5Ts=;
        b=X/bU6po4AimDl6NxgX7sEeWkwInd0ypIAxfX5gJh022Z+EFSaprbe3WkX3nBei7HzJ
         gdGINoxPJC7XbkME4MFvF+O4Ih55i3bHjLJH6MVguTmLxpHfnRXl/wd9EeToYdMeDTPE
         /eALKpuMGYJQcK15vSX8JSsWQ5ycN9Xw3CzeKcUcu0jjQ/VX5SfIXwG71GUiT6d8DJfE
         mRauCIs0rbnCB2EGl/NM9rdUVdWjKeJT3mDpfGco9UIYvElKaKFG/wMfbuPKNmV+YTh4
         T5aAprd0sOmJWZK8PkkDNIhtvng90mV9HcFYVjLOvdmBN4x0PxDM4Q8lpFaVBYANq1qm
         IgWw==
X-Gm-Message-State: AGi0PubyLWdT8w39Vj3JyZ/SpO4FoV/WBKsd4o6NjE2D5NmjlLjQRWY8
        pi73CG2hhPYjwBPqKBFi9ztOa+VioMEOfw==
X-Google-Smtp-Source: APiQypK15qQS8QfvOaOTO5oUSlCHjy5bGszydTXCBRWiPzNJwrSqI/ak0pPcUKbCZMGfqUGwAyk+Wg==
X-Received: by 2002:a1c:b743:: with SMTP id h64mr4803580wmf.88.1585854696559;
        Thu, 02 Apr 2020 12:11:36 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id s15sm8442164wrt.16.2020.04.02.12.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:11:35 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 09/14] rpmsg: glink: Remove chunk size word align warning
Date:   Thu,  2 Apr 2020 20:12:15 +0100
Message-Id: <20200402191220.787381-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191220.787381-1-lee.jones@linaro.org>
References: <20200402191220.787381-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Lew <clew@codeaurora.org>

[ Upstream commit f0beb4ba9b185d497c8efe7b349363700092aee0 ]

It is possible for the chunk sizes coming from the non RPM remote procs
to not be word aligned. Remove the alignment warning and continue to
read from the FIFO so execution is not stalled.

Signed-off-by: Chris Lew <clew@codeaurora.org>
Signed-off-by: Arun Kumar Neelakantam <aneela@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/rpmsg/qcom_glink_native.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index 25c394a7077b8..facc577ab0acc 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -813,9 +813,6 @@ static int qcom_glink_rx_data(struct qcom_glink *glink, size_t avail)
 		return -EAGAIN;
 	}
 
-	if (WARN(chunk_size % 4, "Incoming data must be word aligned\n"))
-		return -EINVAL;
-
 	rcid = le16_to_cpu(hdr.msg.param1);
 	spin_lock_irqsave(&glink->idr_lock, flags);
 	channel = idr_find(&glink->rcids, rcid);
-- 
2.25.1

