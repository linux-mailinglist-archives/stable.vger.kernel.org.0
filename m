Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2354F3AED3D
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhFUQSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhFUQSs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 12:18:48 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2080C061574
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 09:16:34 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id v7so14576440pgl.2
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 09:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LL5t3H80yxVqcOP2FCE0oHwI5menyXESZwHRdH8Og6c=;
        b=dxFfFblIQ6U/Rla6caaO+KOyc4wsi6jn+qr1Embb7mlr3z+aaC9Kjnh0DPT9prslHT
         lxcfdQII69wpZqDMOk05ocxRuVS8dZSflAY5zXeFtNCcms4dWQuzw3I8CGe+XhLnBt1t
         NgK1KWB4p2/FqR9f05xWn7MF3atfzMzY4Tny6EmlPXuSThWtfSphb4IaXZt7Ff3Jr5ke
         pdfOtEd1flvVDonA6tbtEa4IU+w3KqWZguSuTpyPyXKZgV7zeURCL1dyzkXeofWCkpiD
         8ota8+jOf52NXwsWNPBnssKu5XqoBaLTOjd9WUjBW6IeDi/59VKhwluD1RFftzCzz1M4
         BsAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LL5t3H80yxVqcOP2FCE0oHwI5menyXESZwHRdH8Og6c=;
        b=uPkALHnDiGEUxPgBqx87s1cSTFF6TQcR8V7Ibc6ESfura9PwxlJ6RmfaMl+v+2mDY+
         jCWBXPgD0jt7VCSqposy2OCh1VrgJZ7DZwhchW11e16/mno+dmPk781wx71tqqJl0yVk
         sSf2FK99jd4VzO6hC0JVtzjODJRScoragekQCN8VO1qMu0r2qoHgU9AcUeSgQ5fHirQ3
         7MI/6+N3ccxAqXVfSsjWmidgKfGNWU6mFUOMEBo3qNgLd4B9HA2P9VSHUixwNSdfBb6o
         vGg+jMq2NkllLiqBbeDtfHTWrWdXyMs69WdPDqr0d5ejeGfLehk0I4z3ka24L3jcYtsj
         s3Cg==
X-Gm-Message-State: AOAM530z/V6VjDWz6VryjCB2U3aB8CfjbSl2PhZq38QSX+5YpJd8VM8N
        ykRVkjYADV23ONjtFKNqdmYv
X-Google-Smtp-Source: ABdhPJzOfIwdCda7XHHzbTSAOocHTD2Y11tIDzo1FpOag6yHuA/KdlLadm/j3CgSedMXQDiK6LRVkQ==
X-Received: by 2002:a63:5553:: with SMTP id f19mr24178169pgm.419.1624292194215;
        Mon, 21 Jun 2021 09:16:34 -0700 (PDT)
Received: from localhost.localdomain ([120.138.13.116])
        by smtp.gmail.com with ESMTPSA id k88sm10734730pjk.15.2021.06.21.09.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 09:16:33 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     hemantk@codeaurora.org, bbhatt@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        loic.poulain@linaro.org, stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Jeffrey Hugo <quic_jhugo@quicinc.com>
Subject: [PATCH 1/8] bus: mhi: core: Validate channel ID when processing command completions
Date:   Mon, 21 Jun 2021 21:46:09 +0530
Message-Id: <20210621161616.77524-2-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210621161616.77524-1-manivannan.sadhasivam@linaro.org>
References: <20210621161616.77524-1-manivannan.sadhasivam@linaro.org>
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
Link: https://lore.kernel.org/r/1619481538-4435-1-git-send-email-bbhatt@codeaurora.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/core/main.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
index 22acde118bc3..ed07421c4870 100644
--- a/drivers/bus/mhi/core/main.c
+++ b/drivers/bus/mhi/core/main.c
@@ -773,11 +773,16 @@ static void mhi_process_cmd_completion(struct mhi_controller *mhi_cntrl,
 	cmd_pkt = mhi_to_virtual(mhi_ring, ptr);
 
 	chan = MHI_TRE_GET_CMD_CHID(cmd_pkt);
-	mhi_chan = &mhi_cntrl->mhi_chan[chan];
-	write_lock_bh(&mhi_chan->lock);
-	mhi_chan->ccs = MHI_TRE_GET_EV_CODE(tre);
-	complete(&mhi_chan->completion);
-	write_unlock_bh(&mhi_chan->lock);
+	WARN_ON(chan >= mhi_cntrl->max_chan);
+
+	if (chan < mhi_cntrl->max_chan &&
+	    mhi_cntrl->mhi_chan[chan].configured) {
+		mhi_chan = &mhi_cntrl->mhi_chan[chan];
+		write_lock_bh(&mhi_chan->lock);
+		mhi_chan->ccs = MHI_TRE_GET_EV_CODE(tre);
+		complete(&mhi_chan->completion);
+		write_unlock_bh(&mhi_chan->lock);
+	}
 
 	mhi_del_ring_element(mhi_cntrl, mhi_ring);
 }
-- 
2.25.1

