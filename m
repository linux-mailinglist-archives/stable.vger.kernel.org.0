Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992A01B266D
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbgDUMlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728898AbgDUMlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:41:07 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915E6C061A10
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:07 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id v4so2437778wme.1
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=egX0tfu7NRZXkI34xEHvcmq3oOPGI9lnyNWYVxggksI=;
        b=npoSRLpBjdLdDlhjUgIX3WhXryFFpXmLF5GO6fLIqIc2O3lNBEFVjfpKIMDNSHub1U
         W9l+UFTedIZH7f7Uy/Mqk9BPoKApCowMvWOl75G141pjhqBDQI/gptroQfF97yP+zKra
         1apR4uUrRlVwtWoHGQUrtvUuwLrvCLQgiMGGerJOkrH5B2rXOpIo0Lvak5p0c28WDudZ
         IAz8XXBMYvg+cWHostlfa3l3wY3rByfCQwcdumhnGBoWz/4r22Xe2RRrLeZ07nID2v/a
         PmJ9LLAafV4llX4f6N37xrggYiexdNRfgnPV6fsTxbwyAT5ywWkXClWD9PASMtv1aWj9
         7pnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=egX0tfu7NRZXkI34xEHvcmq3oOPGI9lnyNWYVxggksI=;
        b=HhQiVVPF3WaX5pGuheD7pST8XDoIQCF8YuoapvarSrwTkfhJcAmVpT7cvkgB3eRhao
         yzikGHdRY0EX5AvRA0oWqTbTNAxTllQwC0vqrk482sVposdUGRF4yEuvgkbMng4Neh+d
         qIXPhLsggthgTGaONZ4JQO8CkoSIEtU+qi/GkrekoAZe5YZkr1FIoVBVAektZuSOcDxy
         RbAHt1N34lUdIOhKvlE1HVkdLO5B90CuJG0bI8EyqwgbJ0eeEIS/mb3VLG1Vt/LPfPnc
         aMkAzZPBydb8r1whBCBIRbANkJSIC5wzqNZXrrkSZJ3h+ZMvOFq8f0457tQf3Fybx/xY
         fYRw==
X-Gm-Message-State: AGi0PuYxEhfjVzdwmL2m2oE5XAq67pVBiUgCv7QMn9PxHw7Ap71KghWa
        Jjy2axSQcvh02wfnDRDOllWfPzzR10Q=
X-Google-Smtp-Source: APiQypJwaDQmrykRLrWQJflqKHFkuDzvsIvJLB7YxoxEARHqfny1HcBgnDsQNg7Lbtsy0VS27Tkm8w==
X-Received: by 2002:a1c:7415:: with SMTP id p21mr4628517wmc.93.1587472866040;
        Tue, 21 Apr 2020 05:41:06 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:41:05 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 16/24] rpmsg: glink: Fix missing mutex_init() in qcom_glink_alloc_channel()
Date:   Tue, 21 Apr 2020 13:40:09 +0100
Message-Id: <20200421124017.272694-17-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit fb416f69900773d5a6030c909114099f92d07ab9 ]

qcom_glink_alloc_channel() allocates the mutex but not initialize it.
Use mutex_init() on it to initialize it correctly.

This is detected by Coccinelle semantic patch.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/rpmsg/qcom_glink_native.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index 114481c9fba12..7802663efe332 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -221,6 +221,7 @@ static struct glink_channel *qcom_glink_alloc_channel(struct qcom_glink *glink,
 	/* Setup glink internal glink_channel data */
 	spin_lock_init(&channel->recv_lock);
 	spin_lock_init(&channel->intent_lock);
+	mutex_init(&channel->intent_req_lock);
 
 	channel->glink = glink;
 	channel->name = kstrdup(name, GFP_KERNEL);
-- 
2.25.1

