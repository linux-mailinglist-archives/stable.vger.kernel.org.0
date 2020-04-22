Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3493B1B4309
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgDVLUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725787AbgDVLUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 07:20:07 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B114AC03C1A8
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:06 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x4so1878124wmj.1
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=66ViJN+ZbAv/wx0SyJm9vds07oz/mQTCqp+w3CnCjhk=;
        b=BpT0goxjuEp+qriBJSoPiA1zc/nrod2taha3SrEMHcjRnQFpqLeuuqQyPulPSYhgLc
         KrwQp4AinXBBe6raBNdJwAg2gcGC40VQ2MJCNsTAPkkZpE8dYCB36VnCoyfY5QnBNYLL
         3SWbOBSb8rMSEh7i1UFHnsZCOvLQAiDW9EZWxyuQwSj9S+3IJL6JHYPf2WLWDhWFGkdJ
         wTzGAsVjKiVPFJfm167mY/fj2RsIQQlWkm9K4rB47ixvfDqVKX2b4x6+871UpqlleWjh
         ojWYkMHqpseKL+dLrCRJg2Pgkfi22TOzaDb/17VbvRlELPoMuCUUVS8JR1QMdbMUwXni
         SaPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=66ViJN+ZbAv/wx0SyJm9vds07oz/mQTCqp+w3CnCjhk=;
        b=VKIwPT4L5pOy4iA1L1lNZUFcU3KjJTsSDfeccmt4AVGUGPcZ6as41i8bGHU6MxIEHO
         tD3sIJBOlKMXGnmtnx11PdKqPvzWRaSCKe84+h9j6I/Xf5U4g1K94HUKOL7JttMH5Ev1
         a3a3yxnb36pNvjGkMF4nA/9ghqCVXxD5n/2MYvjThmq1fmAfmKPcN79rZrx905CHtwHz
         S2eSctjY9ynB5LQsCKbF2AEHFOe4enHyMsSDSGoqabx+vssGSTSwHjhk7yUbL5l2sf+7
         1ReKbdnoc0QpOgO70J99N8odVw7feNoAnSoFHCCMt3OPPYj2mXGKbi6jlHb6c4G01MDk
         vvTw==
X-Gm-Message-State: AGi0PuacR76/cJAVseNp5LhdYym8guLVk80O6yuAfeEmBsQzdAqYoGF+
        1WWhuE9avIs5JUMMq2xxU3oYXPtEbpY=
X-Google-Smtp-Source: APiQypL6SO6DrGk8ivtbdReK9an4nerwnJXQTmGxSvFxTs8BxFhPJAyX/8MKP0auEhefIMzkv13YTQ==
X-Received: by 2002:a1c:678a:: with SMTP id b132mr10263580wmc.107.1587554405183;
        Wed, 22 Apr 2020 04:20:05 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id n6sm8247255wrs.81.2020.04.22.04.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:20:04 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Alexey Brodkin <alexey.brodkin@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vineet Gupta <vgupta@synopsys.com>,
        Will Deacon <will.deacon@arm.com>, Greg KH <greg@kroah.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 04/21] devres: Align data[] to ARCH_KMALLOC_MINALIGN
Date:   Wed, 22 Apr 2020 12:19:40 +0100
Message-Id: <20200422111957.569589-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200422111957.569589-1-lee.jones@linaro.org>
References: <20200422111957.569589-1-lee.jones@linaro.org>
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

