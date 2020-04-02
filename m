Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2972A19C9B3
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388686AbgDBTRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:17:01 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51507 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388571AbgDBTRB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:17:01 -0400
Received: by mail-wm1-f68.google.com with SMTP id z7so4621919wmk.1
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=66ViJN+ZbAv/wx0SyJm9vds07oz/mQTCqp+w3CnCjhk=;
        b=RzMlWpsV5dMVnYM1uKgXZ5VbPWG/d3NjD+ELFfmEvXR0RvtI0mQunhqeEBydAOQw7v
         b4AueH5K15VqZ4ja8tLxjNWWP1AkiUVp4+emvkG1oaVFqNGLQ68/M2lAtwAljYM0krqd
         3l8+hSKDTwNqrHxd8zMK8i7Bq0F4Y+MYR10MQSYBLmo/6loJkNqwdBw3rnaFO4PYWFfq
         ioMiIWH7wpqCO/oYozIkPlONFs0VsPLHIpQFcyC3lna0u2gXhhzAXx4etWxC2JSopn7u
         Ye4XeGCdX4adq+Axm9gkcNFIlCZCSoWVplDw7Zigsuw6E8IFO5DivUUdObZs4d6n8dC2
         sirA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=66ViJN+ZbAv/wx0SyJm9vds07oz/mQTCqp+w3CnCjhk=;
        b=A91CF2j4WXGgNQcFCZ+fjeucWUXOLODJ2Debkz19LrFXyBSTJlVG28FqMfywgmyguw
         JZD9lWTvQjhluVStBl9wUBNV6jky36pcSdY2auJRJzR1q7qt8LlVXScFle1/bC+79vK/
         SuP5+73UB2PYNaBIEuuA658ek406lxCQ/koQ1jC1jp/Lo1KLdilZJDnQsHoxMhSI4bYH
         Ay1qoJfFcKObMlmi1w+o4KjvneNJ0Qf7qv0TlAG46V0Whsou9xmOtBHQLNNO0LxkNS8X
         QtReG4AeL2SW5GEHNpLfKRMziW5czoEwmUbB4jzI2eDFvl//fsKMtT3MtJcian+C3xW5
         sGZQ==
X-Gm-Message-State: AGi0PuZ8FnL5gEZfU9pe8qUwBrNJFE1XZVNCgDmQcml+44r1t397ks3A
        jO5rLB5mENVnDzwQDxAWEcd8ZSAgRjpWMg==
X-Google-Smtp-Source: APiQypJzyzHLGgEac7mnNUt9WpfHXBv05pmSKP6Z5gMDMb7FGgGMtV2xTcGRkCBRqq+lOvY4rAl3eg==
X-Received: by 2002:a7b:c24a:: with SMTP id b10mr4870866wmj.84.1585855017996;
        Thu, 02 Apr 2020 12:16:57 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:16:57 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 04/24] devres: Align data[] to ARCH_KMALLOC_MINALIGN
Date:   Thu,  2 Apr 2020 20:17:27 +0100
Message-Id: <20200402191747.789097-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191747.789097-1-lee.jones@linaro.org>
References: <20200402191747.789097-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Brodkin <alexey.brodkin@synopsys.com>

[ Upstream commit a66d972465d15b1d89281258805eb8b47d66bd36 ]

Initially we bumped into problem with 32-bit aligned atomic64_t
on ARC, see [1]. And then during quite lengthly discussion Peter Z.
mentioned ARCH_KMALLOC_MINALIGN which IMHO makes perfect sense.
If allocation is done by plain kmalloc() obtained buffer will be
ARCH_KMALLOC_MINALIGN aligned and then why buffer obtained via
devm_kmalloc() should have any other alignment?

This way we at least get the same behavior for both types of
allocation.

[1] http://lists.infradead.org/pipermail/linux-snps-arc/2018-July/004009.html
[2] http://lists.infradead.org/pipermail/linux-snps-arc/2018-July/004036.html

Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@vger.kernel.org> # 4.8+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/base/devres.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 8fc654f0807bf..9763325a9c944 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -24,8 +24,14 @@ struct devres_node {
 
 struct devres {
 	struct devres_node		node;
-	/* -- 3 pointers */
-	unsigned long long		data[];	/* guarantee ull alignment */
+	/*
+	 * Some archs want to perform DMA into kmalloc caches
+	 * and need a guaranteed alignment larger than
+	 * the alignment of a 64-bit integer.
+	 * Thus we use ARCH_KMALLOC_MINALIGN here and get exactly the same
+	 * buffer alignment as if it was allocated by plain kmalloc().
+	 */
+	u8 __aligned(ARCH_KMALLOC_MINALIGN) data[];
 };
 
 struct devres_group {
-- 
2.25.1

