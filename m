Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E983EA94C
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 19:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235413AbhHLRRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 13:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235388AbhHLRRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 13:17:30 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8D1C0613D9
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 10:17:04 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id h17so11517037ljh.13
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 10:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UP7SL7grh8pY0W8Sj4i0+eIen9AAWcvTpps57Rhi1w0=;
        b=NrK3gUcoU4w5a19APqFfYb7KMufsf/YO0t5C+J+PywZyJ0gEkEz/9Owe5V3ae1/5T4
         meAjxD9x5cRo08fC+XPhHAnRRYQgr8izMEssLOEpKzseW2MzzcdgW0uDyhuVhRii/eog
         4rbMJuSNggypzV0WMntZJMl4REcfZpsWKVa8CpVHB5c4zdjiH6HYkD4Bu5ZgPeLmkClk
         TYikJGbAPj3AflW057BZZmWHcHOWT9qvhcE1485A+A8egNyAApEKK977fS0G1cJmen9a
         B/4Q3LMxKFvME9lePgAiNvHrq+0lzdeNYayO9TS+SsclzLbqGQeZDUQVz26wp1lZLdaU
         Y4LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UP7SL7grh8pY0W8Sj4i0+eIen9AAWcvTpps57Rhi1w0=;
        b=TVcOXvpDMyR6zssO83gT+b9a91CRu42ZeFXxWJfFAB5P2MABwvR5UJhwKUAWHxxr2l
         EfJknoApDU4d81pO3AoQkZh8Fqrl9XST9nlAaG5ivaVeiRyPjvrvjtKS2ZcTY9f5pt4Q
         U//QDyIcGGYKCBJVikjEyjTgHTDZCn40nxDZsfztRpR2psGO0t3rr6yyc2H7NkDLY4/j
         2lwYUSDSglGXTeci9knt/Ouo9jI2Fn9zEfobszFAqzP+pdEgvI+Dg5tSjeONZv7aLQCo
         R/TkpKR7Ky1VY+B5qLaRbCK/kVGCglyknFI8y5IlG7bSB79gJfd+zedBUKuKP0U4tYkB
         Rtzw==
X-Gm-Message-State: AOAM530SAEje16I+7l/nEOZTKCZU8w1sodju3n2vYl9yQ+wem+kh0hhX
        Pnz0drq3ZmI+42Si9utm/O+4XA==
X-Google-Smtp-Source: ABdhPJy7Efy3xDnnlRLLOWtAU+eCnzYvwCT9q7DLqhU3BfQ/Js48s5xwlO2Zg148LTi1VilI6+4Vkw==
X-Received: by 2002:a05:651c:b24:: with SMTP id b36mr3625928ljr.223.1628788623069;
        Thu, 12 Aug 2021 10:17:03 -0700 (PDT)
Received: from localhost ([31.134.121.151])
        by smtp.gmail.com with ESMTPSA id o1sm320043lfl.67.2021.08.12.10.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 10:17:02 -0700 (PDT)
From:   Sam Protsenko <semen.protsenko@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.4 6/7] usb: dwc3: gadget: Disable gadget IRQ during pullup disable
Date:   Thu, 12 Aug 2021 20:16:51 +0300
Message-Id: <20210812171652.23803-7-semen.protsenko@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812171652.23803-1-semen.protsenko@linaro.org>
References: <20210812171652.23803-1-semen.protsenko@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

[ Upstream commit 8212937305f84ef73ea81036dafb80c557583d4b ]

Current sequence utilizes dwc3_gadget_disable_irq() alongside
synchronize_irq() to ensure that no further DWC3 events are generated.
However, the dwc3_gadget_disable_irq() API only disables device
specific events.  Endpoint events can still be generated.  Briefly
disable the interrupt line, so that the cleanup code can run to
prevent device and endpoint events. (i.e. __dwc3_gadget_stop() and
dwc3_stop_active_transfers() respectively)

Without doing so, it can lead to both the interrupt handler and the
pullup disable routine both writing to the GEVNTCOUNT register, which
will cause an incorrect count being read from future interrupts.

Fixes: ae7e86108b12 ("usb: dwc3: Stop active transfers before halting the controller")
Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/1621571037-1424-1-git-send-email-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 5f2e4a2638f5..78a4b9e438b7 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2030,13 +2030,10 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 	}
 
 	/*
-	 * Synchronize any pending event handling before executing the controller
-	 * halt routine.
+	 * Synchronize and disable any further event handling while controller
+	 * is being enabled/disabled.
 	 */
-	if (!is_on) {
-		dwc3_gadget_disable_irq(dwc);
-		synchronize_irq(dwc->irq_gadget);
-	}
+	disable_irq(dwc->irq_gadget);
 
 	spin_lock_irqsave(&dwc->lock, flags);
 
@@ -2074,6 +2071,8 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 
 	ret = dwc3_gadget_run_stop(dwc, is_on, false);
 	spin_unlock_irqrestore(&dwc->lock, flags);
+	enable_irq(dwc->irq_gadget);
+
 	pm_runtime_put(dwc->dev);
 
 	return ret;
-- 
2.30.2

