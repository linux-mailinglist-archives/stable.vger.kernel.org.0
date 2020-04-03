Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4246419D694
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 14:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403912AbgDCMSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 08:18:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51795 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403919AbgDCMSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 08:18:36 -0400
Received: by mail-wm1-f65.google.com with SMTP id z7so6912237wmk.1
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 05:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jummrcf5rvKAi6eH2KyVwYJGqNxV7PrPZlMxGnwq5Ts=;
        b=cdOdPovvi5BOGAKERw+EDH/PtKr03yzyrcERKJknD8/Dx/urDAxk2K+pdA3Yclqrqr
         8Ex6grK9KXleMfaWfj5kN9F+IwuFGKXNgAjcVlo0BULbISOotTxOuLJdk1o8JrBa3UvM
         YRqO0sPZKWM0UGdhOVKHUMSUqybc58So2t5bgVOEqX7LVAQmhFvVVDNJQ4WIRfRsF1pg
         BudO8/uw5sDO/dC56pwtFz2P2bmSEbk+EUw4TKVhCNNhY4jo1R5YSMJlwVpC60Av1GTo
         NHkKbxryxmAz9vNm67gPnInRbJYAib5Vb2kvqka2ODkG3BeVoQ5KxIYlrFGR398H7/6u
         760g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jummrcf5rvKAi6eH2KyVwYJGqNxV7PrPZlMxGnwq5Ts=;
        b=TwdZ/W158Zatv+uLsDh9LllDaNSL3cCPiTlfw5RYpURLxq0CwkVBEjBXjaxCwqBUmm
         3umi1CL4Wt1fngdzGSFI6bVwpc/t8daXDx2itUbGGgnEEToZ92oRQCtyghhgYU4hD5Kg
         DmVN+Um5txbHdk1+04rAqOPYHbbpUfzPkaoAcvvz4A84q1uovpUsuLYYoIkhPLL5ezVY
         vrqSfHGgwtM31jFxR9CP4nNeT3KnbowAvF5/OlTGPhloviFqVSa46iMEOjlY7q+ESsdp
         F3DaQuupXMM4e+6EKq9j/PwM6TYi0w3k9FeNIJcBhv/aWUOrt+hQlbydVwUOjZB9FtCG
         0BsA==
X-Gm-Message-State: AGi0PuZd1wAsle48VBzgynadnj5ss8tHDwCNDtDxMUPBolHVjynjGHkP
        0MYz7VGI4sqJ2jVgWQBzSzetDDE95Ow=
X-Google-Smtp-Source: APiQypKwIWTjRNEo5g3kjJTp/Xcu+LLwNNjiLKG9JvzS1M6FVI/sAUAFThD8VX6KwQIL4Fat5+hMxA==
X-Received: by 2002:a1c:5654:: with SMTP id k81mr8676061wmb.145.1585916313868;
        Fri, 03 Apr 2020 05:18:33 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.179])
        by smtp.gmail.com with ESMTPSA id l185sm11377712wml.44.2020.04.03.05.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 05:18:33 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Chris Lew <clew@codeaurora.org>,
        Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 09/13] rpmsg: glink: Remove chunk size word align warning
Date:   Fri,  3 Apr 2020 13:18:55 +0100
Message-Id: <20200403121859.901838-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200403121859.901838-1-lee.jones@linaro.org>
References: <20200403121859.901838-1-lee.jones@linaro.org>
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

