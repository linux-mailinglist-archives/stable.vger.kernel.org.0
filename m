Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16704F0F8D
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 08:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356338AbiDDGnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 02:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346168AbiDDGnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 02:43:52 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839C32B244
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 23:41:56 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id o10so1445852ple.7
        for <stable@vger.kernel.org>; Sun, 03 Apr 2022 23:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H3W01VymVDs0COr3eR7ZYNGagSlCtWPeaS90Ia+pCnQ=;
        b=HmEsVfgq0A+7eOcB4BnudSM7EvSYxXpV7awtlzzAS/97TEqDO4nNv0HepfTATpopCz
         dq1bSwgpNc3qhSPWhHq+6hyf3tV8MhCTF78n7WY/VDrRUx38rBcRaXMwSIe6hkiuqnP2
         JFUnwQrcoG1VUUKZBNCn0TzuA/ssNfym6bM36RTObsjR42VGiBHolgZbBy/FpCanenu+
         XlI7Lh27mkx0moVPP4QfN8CMukMmhxdKm3yytkz9wKEsxr8nejdLAy35lMNMSM0D5CsA
         Sa5YnbABfEVK57peEKUX9NDSJvwEYQBC6D/kpyDQqb4neYN0SUdxnYSoWvzYe/3Qic5V
         zpLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H3W01VymVDs0COr3eR7ZYNGagSlCtWPeaS90Ia+pCnQ=;
        b=rDLaLauxFR4kFNOhJHo3soVulKE+KwQYGQ7uh0/3U9kgQLMvF39Yi16+InDAUa5kip
         lgEJb9hyNr+YF3EaglbktQfY2JnE9toTI4/WxQeiXIP/SwAA/p2UPXW9z0RnuguczBZW
         gViX3B+QAGeXXoAZLUe8MNjYcnRa+j21YrFEdQbeBD8QpgeTJ0gtcSfP+Ux3g+RSxvEj
         1kYRYrQUf+CbkWOMw4XuivnScseAP7eAaFsqDogR8hSKWAJOc/wYjysrP05SDj6VHd4I
         O95PeAZHOJy19kSaialWJZON97B+SPk+cVLcuTJba7Q51NPaQXMOM7hYrk8hApo+FHS8
         eEcw==
X-Gm-Message-State: AOAM5303L/mDJMDKbILR1hz8l/VhlWvO26/NrXuUoipfOZA48u4YyQKe
        UBZkCS/yOMvR6paz/QQGZxJy
X-Google-Smtp-Source: ABdhPJxn6ub5ARRtRWc9EBKVEVPL2IlboiXysb8PEsNqUNtyfewDC/cWlFq219J0f/+ZB3ZkxuiX3A==
X-Received: by 2002:a17:90a:8c2:b0:1ca:a4a3:6833 with SMTP id 2-20020a17090a08c200b001caa4a36833mr2954493pjn.161.1649054515977;
        Sun, 03 Apr 2022 23:41:55 -0700 (PDT)
Received: from localhost.localdomain ([27.111.75.184])
        by smtp.gmail.com with ESMTPSA id b2-20020a056a000a8200b004f1111c66afsm11637442pfl.148.2022.04.03.23.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 23:41:55 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     mhi@lists.linux.dev
Cc:     quic_hemantk@quicinc.com, quic_bbhatt@quicinc.com,
        loic.poulain@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] bus: mhi: host: pci_generic: Add missing poweroff() PM callback
Date:   Mon,  4 Apr 2022 12:11:49 +0530
Message-Id: <20220404064149.59634-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During hibernation process, once thaw() stage completes, the MHI endpoint
devices will be in M0 state post recovery. After that, the devices will be
powered down so that the system can enter the target sleep state. During
this stage, the PCI core will put the devices in D3hot. But this transition
is allowed by the MHI spec. The devices can only enter D3hot when it is in
M3 state.

So for fixing this issue, let's add the poweroff() callback that will get
executed before putting the system in target sleep state during
hibernation. This callback will put the device in M3 state and that would
allow it to receive the D3hot afterwards.

Cc: stable@vger.kernel.org
Fixes: 5f0c2ee1fe8d ("bus: mhi: pci-generic: Fix hibernation")
Reported-by: Hemant Kumar <quic_hemantk@quicinc.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/host/pci_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
index 9527b7d63840..b1c0a8887496 100644
--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -1085,6 +1085,7 @@ static const struct dev_pm_ops mhi_pci_pm_ops = {
 	.resume = mhi_pci_resume,
 	.freeze = mhi_pci_freeze,
 	.thaw = mhi_pci_restore,
+	.poweroff = mhi_pci_suspend,
 	.restore = mhi_pci_restore,
 #endif
 };
-- 
2.25.1

