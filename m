Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A13C19C9D3
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388745AbgDBTSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:18:08 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35878 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389416AbgDBTSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:18:08 -0400
Received: by mail-wm1-f66.google.com with SMTP id d202so4982527wmd.1
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=66ViJN+ZbAv/wx0SyJm9vds07oz/mQTCqp+w3CnCjhk=;
        b=bAZgLxMthTlKO8QgMVPs8MsNdBhzS1pLfuj7/vrSuYvUav+nkIpWGwYmqJlPoOMhG6
         wJF5WO8wQ8D2f+rvO8mnvywkz6kZtwXIUCr2RpyWg4gV1Bi6sNnUPGbe03zaIlM5Bodo
         9+fKnYHEP0wQ6M1ZIg07dbBsphRqHiOjouBeo8jIJYZQEXK4bt4JxdwxPtsgkEUU2wsX
         HJfuny/DJPWv30mPcdJbwdzePD40q5h+ljLNIhbi9sRmVG3pEGW48X5EweDfR/VgdHE+
         wIuxPbd9h2Holnr7kcXxhN37hxavHxJYeN8LGyA1fL3WjLPyR9sIQ/RsZXyNk6WVa/YB
         SkPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=66ViJN+ZbAv/wx0SyJm9vds07oz/mQTCqp+w3CnCjhk=;
        b=YbD8H4iJq66IIR4670oJvVQoBVbdf9+MqjxMowpkewmERXmubGn/UoKST6K3yL90K1
         Fctwq1VJyGvcy06M5R7g3//yDjyS22DF494LLWvJ/1uUJe+sUcOMhi3JDEEtR/YkfaJt
         +VneCqERcmURzCo1z7+yuUYfFQ3ebf0mpYUrK+FKW6XbYwfqVJSFIcBnmWHoXHvG13Y8
         R8jqMuDxOjNvZRcrvJSZPNZ7cF21KhsA/qDjUuNtBu9Mcy4kGWTxCOrXk7+npr/XSxa6
         /gc7wLAsrwDnCy8ugicZuCNhTaBP4q4hC51BqU6XJ+BEg0KDRxuN73Q4vf+a4t+Vn59f
         lVGQ==
X-Gm-Message-State: AGi0Pubr+dvWBmNJT1hvFA+X6IE0G9hwOpi1fo4FgkGM/d18OTICd6CF
        GYaxDWkeumYBDwf75boYLaqZDHsjJVy1Ig==
X-Google-Smtp-Source: APiQypKtJgoMKIj9uF8D3KdrbIjjTaf393Yxo5BaL5y+rL23IQJM4ORlQOD8kd8mH9Pbrz8fcp5Zdw==
X-Received: by 2002:a05:600c:2f17:: with SMTP id r23mr1702607wmn.20.1585855086204;
        Thu, 02 Apr 2020 12:18:06 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id l10sm8622707wrq.95.2020.04.02.12.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:18:05 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 04/20] devres: Align data[] to ARCH_KMALLOC_MINALIGN
Date:   Thu,  2 Apr 2020 20:18:40 +0100
Message-Id: <20200402191856.789622-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191856.789622-1-lee.jones@linaro.org>
References: <20200402191856.789622-1-lee.jones@linaro.org>
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

