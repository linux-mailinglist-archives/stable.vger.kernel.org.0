Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D08330BB6
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 11:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhCHKwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 05:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbhCHKw0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 05:52:26 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8B2C061761
        for <stable@vger.kernel.org>; Mon,  8 Mar 2021 02:52:26 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id bd6so13931824edb.10
        for <stable@vger.kernel.org>; Mon, 08 Mar 2021 02:52:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nu5tkdFsaHazmRd4/55M771FR4RELHyaxuVaBLaaiaE=;
        b=nPiYOkvqpxOFvenVXbshjw+7ue8UcdngITP3Sc2q0OMxuvLvE1iLAgDD0kEXI1Oi2X
         iVoxHCNlKRcZ1UDTmVoy1EddhAVFAXQp7fDPOHnQ5rVwN4uOtw0Ios0vhPRiioS4LjDT
         UQT7+jt3RP9nIau/UNZKAey75BzkItjF/yEYXERQWRE34VICWmsEGMjSlS5MQkPrANDz
         zl47MnYwfHTb2utiHgCFg/PxM7bfqBuUp/VF1/Nb1zVPQf5prUFWFooMVBpEC5U07K07
         Ic0wQxw9y7463ThW4pGK2htYBvJ/foc/0VtJM+z35a0/EVsfiiQ5CPeMVL69WjVW1B6Y
         K8EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nu5tkdFsaHazmRd4/55M771FR4RELHyaxuVaBLaaiaE=;
        b=sqUp2Xi9yXsCkJIsKFPRoAxBa6HQXnkAdCjHaa6GmxCURAQqDHuJeisvvFDkuZMPuS
         cDctH8t72cxplxdaBp4Cm+By3bJUJQa1MBJ4Nk37qtF47CnUeHfyOdo/Cp3nEBKiJYLs
         Upg9fWdyi9mVENMH43y67BNk3/jcXq06tlbCl3KE1GlQqY8qSXcRU1q+j4ix57OX7bLI
         Vq1YhvxYCFkAPJnFIOkI6n4sVU5C8ejhULUMNkAMZJk0khJDgUFuZx62Ur+Rw2Y50ixU
         leP4m5fj9MkmRBFj+jiIHTho65sz1Z54B/EfqiMwskcsZWBBnofSKwj1d8jW1DqaaKr1
         wDxg==
X-Gm-Message-State: AOAM531RllmNZoakIki3bANk8s3/xuowWd6zpmUPDn6QDeaTKwgsUN8w
        dHbDQmOQevD6H5rs9xIpbNMCUw==
X-Google-Smtp-Source: ABdhPJwtB41uQgy6Aa0WZYDSOeWQN28nOY9y1x3RwRq26SVOFIPISX2rp1z0BBMxNVTeul4+0cePHw==
X-Received: by 2002:aa7:cb8f:: with SMTP id r15mr21684254edt.130.1615200744772;
        Mon, 08 Mar 2021 02:52:24 -0800 (PST)
Received: from localhost.localdomain (95-43-196-84.ip.btc-net.bg. [95.43.196.84])
        by smtp.gmail.com with ESMTPSA id y9sm6386297ejd.110.2021.03.08.02.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 02:52:24 -0800 (PST)
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
To:     linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     bryan.odonoghue@linaro.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 2/5] venus: hfi_parser: Check for instance after hfi platform get
Date:   Mon,  8 Mar 2021 12:52:02 +0200
Message-Id: <20210308105205.445148-3-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210308105205.445148-1-stanimir.varbanov@linaro.org>
References: <20210308105205.445148-1-stanimir.varbanov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The inst function argument is != NULL only for Venus v1 and
we did not migrate v1 to a hfi_platform abstraction yet. So
check for instance != NULL only after hfi_platform_get returns
no error.

Fixes: e29929266be1 ("media: venus: Get codecs and capabilities from hfi platform")
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi_parser.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_parser.c b/drivers/media/platform/qcom/venus/hfi_parser.c
index ce230974761d..5b8389b98299 100644
--- a/drivers/media/platform/qcom/venus/hfi_parser.c
+++ b/drivers/media/platform/qcom/venus/hfi_parser.c
@@ -235,13 +235,13 @@ static int hfi_platform_parser(struct venus_core *core, struct venus_inst *inst)
 	u32 enc_codecs, dec_codecs, count = 0;
 	unsigned int entries;
 
-	if (inst)
-		return 0;
-
 	plat = hfi_platform_get(core->res->hfi_version);
 	if (!plat)
 		return -EINVAL;
 
+	if (inst)
+		return 0;
+
 	if (plat->codecs)
 		plat->codecs(&enc_codecs, &dec_codecs, &count);
 
-- 
2.25.1

