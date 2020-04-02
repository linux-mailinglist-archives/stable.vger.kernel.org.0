Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC5819C993
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388499AbgDBTNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:13 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37917 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389221AbgDBTNN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:13 -0400
Received: by mail-wm1-f65.google.com with SMTP id f6so4942236wmj.3
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=F1RxqoVym4udjkgxIj1+YF/PQS5E7Vq+xOrBZvSu6QM=;
        b=LIGlLU5/bAbwidCwU9l9QKk1lu4QtcDHi9MzZwv6Y2Iz6hebYuBjljRMtGMuFkhwrX
         WI9NRTFCQWzCnadUoDHrneHeimWEp4YUweaxSiKb1gMqgyVV8Yj2jAkPZZM9wgAwZMYS
         +d8F73spLu0cVQjZOvouSLakck50GSx69rr+YQW9tJo9+auwFCduC5YYrSC2fXtHH4Ud
         0CLvRC3IuwVug4WX4tv2OuKteQT/mKF8QrOW0hcRst0ijmryZC7SfmnMhC+CDDPzSdNM
         /qou+pJV7FNr8DjzY9hDs/aZ3lG1n7i4OygO5wmmURUuQd14Z1SVI6grqU1Lr8bFFIna
         O2Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F1RxqoVym4udjkgxIj1+YF/PQS5E7Vq+xOrBZvSu6QM=;
        b=Yj3h10NxuzkuqiLPOaqPpG6PAcznRuQ9LrgvRIjwDMMVQ34WJLrL5joMY8PDrx+VjI
         nfxw7ZffWETBJ28IfrSIgH/brhrxbXcaVJprhkZZK6YqtzGbJVV9wmZVcxX/SZnQpB/Y
         VJGWp4wep9SDJgf2oRpXyV2yd9BrNEDpIUbDxbJWZruXGjG4156okBE6jtc9Rg0ik7vw
         1vCrEBwkHcYbhEn/1olUD9yf2KGP+574uMlaGKJzrNIzkcys6OMBXLxp7+Y+B0wKYPbh
         nhTEMv21Gh2LSH2NNo59l8tTryCVbi8RW+IPSJZ9xcU4ZircL8bVqR787TlrvB7vtf/j
         EA4w==
X-Gm-Message-State: AGi0Pub14+rNPvde4Rr9Siq2W34qivqNt4+w368yiILEyfdI30TY/LYC
        E9adBTMG70eXg+c18mXy19HFpjQVxhiFXg==
X-Google-Smtp-Source: APiQypKnL0aCIgdgESDBh64m99RpKZfOH2E4svbhfbmmh2xBIq5sp7L8/h5WRYJqCc8LWDw2rxgsfA==
X-Received: by 2002:a7b:c18c:: with SMTP id y12mr1781442wmi.56.1585854791141;
        Thu, 02 Apr 2020 12:13:11 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:10 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 12/33] rpmsg: glink: Remove chunk size word align warning
Date:   Thu,  2 Apr 2020 20:13:32 +0100
Message-Id: <20200402191353.787836-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
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
index 1e6253f1e070e..114481c9fba12 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -811,9 +811,6 @@ static int qcom_glink_rx_data(struct qcom_glink *glink, size_t avail)
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

