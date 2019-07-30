Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 536617B436
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 22:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbfG3UQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 16:16:50 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45761 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387406AbfG3UQt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 16:16:49 -0400
Received: by mail-pf1-f195.google.com with SMTP id r1so30405583pfq.12
        for <stable@vger.kernel.org>; Tue, 30 Jul 2019 13:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MunFz2lTShwR26VZ4w2FwMukvVD2WiHHyR9u5VL0/FM=;
        b=O0sgUBMmEVpuYzSdIhpoJHYNdPFG1Wy1qJ37KN+PwiFAJmdOsuuYvjImrBg5oRDGzg
         v1fRzWZc7wQSkFwkmQ04Wmmm3cTUnZFJMS0YAzSShidmCBhlBth2BEYbVq2r03h4g2of
         EPQkmhkEpqq5AB4lycKJmHq8JtWO/NmRnMBBVKDFYRJr7ezH/yBqYidFXwHiC631ArCG
         OkGHhQnum43cky9PAUD5NS7e4Rtt8JIqP0qSO7U/PZ2xqGNjCGXqzesoK5LfhSVBhxJd
         tAnm4ETsjj7Es9dfA9vHolHfhwQ+0kyNqD4xm6yrwMcjJDKmMMjMU+XCm6iRYV58JqTi
         Eelw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MunFz2lTShwR26VZ4w2FwMukvVD2WiHHyR9u5VL0/FM=;
        b=AnGg82aLQOTDlDLzCcBE51RWZaBodoPfB2CQM2Uo5Xx0al0wtB1wivOVi/VZ0rl8g/
         8+eE7HPjK5aeNXF0YjBKkNGnAn9psoP22CRamHpOycbCsV60n8BkifVMZIy2zY+xcHtj
         EcbeaZ3iutNsSrHMiU8UQQxh17hLX1ESyUZzgROyiNdB8ZE3Qqt/SbPAEy/sG5iQnHZx
         Ka80Un5Noc8Lij2d3FU57bZW00RBw1kSM9+VgOlZtHGZDmxsGMJXpbQGGF3bvpEqUCs9
         qQNZWZjWIXD64XgS3LZanIGFOtH1bi6JnKKHBGvmeK1flqz9sejFIkqJdHZ9stMP45+i
         mG5Q==
X-Gm-Message-State: APjAAAUFTBq71RaCnCYQUijafs5yApMmJdoPLfOn7j8h/eERwxs6x1DB
        I0LwGbnVra+nXZLPrM/kRFW71g==
X-Google-Smtp-Source: APXvYqyCh3yUtQI3VkNGClveToc2ZHZf54acs8Khx2ApsRSmRvTf4hjvqCaGBxHfuo78BDRcwtZOGw==
X-Received: by 2002:a63:f807:: with SMTP id n7mr114040472pgh.119.1564517808943;
        Tue, 30 Jul 2019 13:16:48 -0700 (PDT)
Received: from localhost.localdomain ([49.207.49.136])
        by smtp.gmail.com with ESMTPSA id 135sm67603659pfb.137.2019.07.30.13.16.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 30 Jul 2019 13:16:48 -0700 (PDT)
From:   Amit Pundir <amit.pundir@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Stable <stable@vger.kernel.org>,
        Christian Lamparter <chunkeey@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH for-4.19.y 3/3] powerpc/4xx/uic: clear pending interrupt after irq type/pol change
Date:   Wed, 31 Jul 2019 01:46:39 +0530
Message-Id: <1564517799-16880-3-git-send-email-amit.pundir@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564517799-16880-1-git-send-email-amit.pundir@linaro.org>
References: <1564517799-16880-1-git-send-email-amit.pundir@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

commit 3ab3a0689e74e6aa5b41360bc18861040ddef5b1 upstream.

When testing out gpio-keys with a button, a spurious
interrupt (and therefore a key press or release event)
gets triggered as soon as the driver enables the irq
line for the first time.

This patch clears any potential bogus generated interrupt
that was caused by the switching of the associated irq's
type and polarity.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
Cherry-picked from lede/openwrt tree
https://git.lede-project.org/?p=source.git.
To be picked up for 4.14.y as well.

 arch/powerpc/platforms/4xx/uic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/4xx/uic.c b/arch/powerpc/platforms/4xx/uic.c
index 8b4dd0da0839..9e27cfe27026 100644
--- a/arch/powerpc/platforms/4xx/uic.c
+++ b/arch/powerpc/platforms/4xx/uic.c
@@ -158,6 +158,7 @@ static int uic_set_irq_type(struct irq_data *d, unsigned int flow_type)
 
 	mtdcr(uic->dcrbase + UIC_PR, pr);
 	mtdcr(uic->dcrbase + UIC_TR, tr);
+	mtdcr(uic->dcrbase + UIC_SR, ~mask);
 
 	raw_spin_unlock_irqrestore(&uic->lock, flags);
 
-- 
2.7.4

