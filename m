Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9393EA94B
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 19:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235385AbhHLRR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 13:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235044AbhHLRR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 13:17:28 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30752C061756
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 10:17:03 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id a7so11548766ljq.11
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 10:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=575RKXlVoqe+Vms4/CGvY3NT7USl2X3vSq6hXihEXlY=;
        b=xvX4r/aX94idi4fHu4lCa7oTqnjNocknJorx4oYDTTT6fAeLHu5ayytkWKbMG1Ll5b
         K5PX9uUXBSf/dHcYZsSBTNtC/59tQiYnI0qc5tl0e3ly8PEdUdp3xm7Nms0K5RKlhU6/
         To5hoHBNfcNaer+3ZrSMRy4Byxg3nU3vLVHeUVZ1J69EyTdILfguOksrOUMC2M7MHvGg
         nOOQFMOHrAcIgWrh+H0BNLBE+PLgK84UmnpCV7WU9Doz8nhiP3EPkv5jtO+2i/WABSv2
         +/8S20yPW2gPCeOSKQOTlYOIF0C0mx3aKq4Fz5by/mKwWW5qZoAetdeq0AK4b1ODpP08
         ss+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=575RKXlVoqe+Vms4/CGvY3NT7USl2X3vSq6hXihEXlY=;
        b=NHW4WCj/lSun4L5WjFaNUYV2Ag2prsQBWMfHO3cTxPI+4sNYMuJVamzrtCJiBwbN1y
         sjK/A8RK1R746638XnJ2p18TrhHE2l4OnxotG8MKF14jq+ha5W1bUDlfdWqkLWyOjJp1
         gk2zpe+UgYXWB/6PvRcorIgqEEmKNZxqK6e50Pscrvu8LmpAJAgtgJ6GZ0OtKpTMSX60
         3zVzlBvDEr3NEfmSDOrtyjOzj62QXP4jpkvye7+xiv66YCPaK73GVmTPnQa+fEe7FNdo
         4JVfCf4BwOb0vPrCsQMrGlhbjM78NyuSXdh496F0f10rLqIYWbi3lt474EhufQlGjMj+
         xmQA==
X-Gm-Message-State: AOAM532URxjrJ2Ya4dfiYhan29l/Lr8REPsjNoRs9ui+NusQCaeNvfMw
        eQJgGJfmvZoba3mo72Vh811f5A==
X-Google-Smtp-Source: ABdhPJwG6MDANbUKEUXAK9I5gImHrQxIL3/eETDl6f0sejCf6eHxXcn+VhpyPTEbNQDE0+z/u/olQA==
X-Received: by 2002:a2e:a80c:: with SMTP id l12mr3785999ljq.206.1628788621585;
        Thu, 12 Aug 2021 10:17:01 -0700 (PDT)
Received: from localhost ([31.134.121.151])
        by smtp.gmail.com with ESMTPSA id d27sm318979lfq.147.2021.08.12.10.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 10:17:01 -0700 (PDT)
From:   Sam Protsenko <semen.protsenko@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.4 5/7] usb: dwc3: gadget: Clear DEP flags after stop transfers in ep disable
Date:   Thu, 12 Aug 2021 20:16:50 +0300
Message-Id: <20210812171652.23803-6-semen.protsenko@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812171652.23803-1-semen.protsenko@linaro.org>
References: <20210812171652.23803-1-semen.protsenko@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

[ Upstream commit 5aef629704ad4d983ecf5c8a25840f16e45b6d59 ]

Ensure that dep->flags are cleared until after stop active transfers
is completed.  Otherwise, the ENDXFER command will not be executed
during ep disable.

Fixes: f09ddcfcb8c5 ("usb: dwc3: gadget: Prevent EP queuing while stopping transfers")
Cc: stable <stable@vger.kernel.org>
Reported-and-tested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/1616610664-16495-1-git-send-email-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 8702035d08f1..5f2e4a2638f5 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -754,10 +754,6 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 	reg &= ~DWC3_DALEPENA_EP(dep->number);
 	dwc3_writel(dwc->regs, DWC3_DALEPENA, reg);
 
-	dep->stream_capable = false;
-	dep->type = 0;
-	dep->flags = 0;
-
 	/* Clear out the ep descriptors for non-ep0 */
 	if (dep->number > 1) {
 		dep->endpoint.comp_desc = NULL;
@@ -766,6 +762,10 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 
 	dwc3_remove_requests(dwc, dep);
 
+	dep->stream_capable = false;
+	dep->type = 0;
+	dep->flags = 0;
+
 	return 0;
 }
 
-- 
2.30.2

