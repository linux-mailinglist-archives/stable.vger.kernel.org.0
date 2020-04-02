Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2206319C99D
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389424AbgDBTNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:24 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35657 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389387AbgDBTNY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:24 -0400
Received: by mail-wm1-f67.google.com with SMTP id i19so4966779wmb.0
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3E+vUdmowT/01VGwN5LYzWxwrJnBqR/xu8ape7Fl+Ag=;
        b=y0SNIyxBQ8OGEqWHIiyrhp5fDO073K6m7UIkI9Ad6j7yV+K2P8go4L4GJZL4y301Ax
         jNF3JyQM5GM5oSp8jbvoJ25vCxAzs0w/DdXhQYdjeS/fKaP3nFLDgOa78oE1JotxNQ4k
         hvTmc04RssKAa2oJ5K2G3gNgtOdS7m/FhXfuWRNBkVtW/rYJLjcUjXDgptFw3uoNhUUn
         nMVkmjCIXAA/nc1wIT5XxXUNwB3z6djLk2X8jV0JpnifWTlrmeWhInhWrPN4uvDrqpto
         rdnTQuoofvu7Djt2L7OXNQ9RMS5ysmyNsAwVtjOAKVT734T+WAhN670Dfx32A1PQr/7p
         Oi0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3E+vUdmowT/01VGwN5LYzWxwrJnBqR/xu8ape7Fl+Ag=;
        b=J/i6GymclyDSyawUT98Wflx1hIXrfF0HL6zUL+YAjPviD3jz9pjjWse7+e0sHwAO/l
         /WFyqqmdqafZPjskxJTcKw+HTuU+MRK++1Wn05lsqvnyrSeeh7sNH3okMdHVMjnSxm8p
         lsfan08tFO57ZlxqdrpVOwcek7T3QgdF+Mh/DrHuLj7pui2e3LPs3xDvxZAC+EDc0yog
         86snVWNC57NGgCv1/v9NA7YxYW/Jq9LmgfaKty014r/1gyeQrjqVAqsVZ6g5I5oo8uzM
         QQSL79BBorNCkHxkpl+5v7K0pS2S7Vlp4RtdlK13SxL7nug51m4UErgBpxZBx0uV+O1n
         Vw0w==
X-Gm-Message-State: AGi0PuY74aer2ZHYSvvyWlMzM1qTa9AALhRKwYEkbAOVD68P6sTxUzJn
        R9equEY/iY6S1Hc53nXanHQiWKu/84VOmw==
X-Google-Smtp-Source: APiQypJEnWs4tkmzLMEQLLId3kpDGWoxUzwDMpn6GNG/++Bs8jj9GYRvBuMUS/rB4LPxPSF9+ILD3g==
X-Received: by 2002:a1c:2506:: with SMTP id l6mr4665358wml.44.1585854802029;
        Thu, 02 Apr 2020 12:13:22 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:21 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 23/33] rpmsg: glink: smem: Ensure ordering during tx
Date:   Thu,  2 Apr 2020 20:13:43 +0100
Message-Id: <20200402191353.787836-23-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 9d32497361ff89d2fc8306407de6f04b2bfb2836 ]

Ensure the ordering of the fifo write and the update of the write index,
so that the index is not updated before the data has landed in the fifo.

Acked-By: Chris Lew <clew@codeaurora.org>
Reported-by: Arun Kumar Neelakantam <aneela@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/rpmsg/qcom_glink_smem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/rpmsg/qcom_glink_smem.c b/drivers/rpmsg/qcom_glink_smem.c
index b1c15c64cdec3..c2a4467b5fcdf 100644
--- a/drivers/rpmsg/qcom_glink_smem.c
+++ b/drivers/rpmsg/qcom_glink_smem.c
@@ -185,6 +185,9 @@ static void glink_smem_tx_write(struct qcom_glink_pipe *glink_pipe,
 	if (head >= pipe->native.length)
 		head -= pipe->native.length;
 
+	/* Ensure ordering of fifo and head update */
+	wmb();
+
 	*pipe->head = cpu_to_le32(head);
 }
 
-- 
2.25.1

