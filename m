Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B171B6598
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 22:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgDWUkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 16:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgDWUkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 16:40:22 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C196C09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:22 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id d15so6627527wrx.3
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=66ViJN+ZbAv/wx0SyJm9vds07oz/mQTCqp+w3CnCjhk=;
        b=WzDYhDFQM/2pjutTBgryIaO1DpIKReI0rISqK3Jqok7kpFSj1eagDSr5ywq2WRyBNW
         eukh90hKQfwuKx8LpDrlhC1NPRlGPay9ANIrLEhRS/nMKx+S8dZCgxs5rc96UJM6ZYCe
         2OAnVLe7aDR/fOHJWY74441+b5FKiOk127YIeVMIjYbTLXB4BPoVqs81EpGpF1utAwLK
         Jv5RIxojmhx8Zn3OtgCdzSLyHt3AK+/WL2+YKHML7RA+mFczS/D8SoA52yOhi8AMmY1s
         KAS9kmCGfRcZL9sKEPWzwW7OEaKFc0FW+ks7klEwlOsfijWZFcPGqDqpsRKCe952HHsQ
         woYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=66ViJN+ZbAv/wx0SyJm9vds07oz/mQTCqp+w3CnCjhk=;
        b=h7cGNKGnOf0CaaMfVoQksKfLhYPdXavc5mVRBAafi/dcDb0dtf/lb45Y7WAEDIlx2e
         slqucmDaJM+qI9RBHlX+QdXPBpw/54PLKdWwhozE+LRdvWc1KqIge3JqO5IPh5UzefLo
         7HapExaGW/xQEY4shFmMnSWuPzhLnk6lgWtQywSI0dEXzCdWOQW2ou+npdixFuXROtmL
         T7cpZ09j+ufIfuEuSV0wFiX1Wn5rIMulsklhBjcOEpjU9aOSBX7z2xY/cNGP0UZiUVai
         Y0vBfoVh/XRj+UvVxux1cEIRsMuUKgO7zlW8gBZYDv5VjzQ+2TMQQV6VpZi3sOrXsfyP
         WPuQ==
X-Gm-Message-State: AGi0PuZqQlcDHmYZSz8cGiwFk8ENXS5ET+pGTIRWvCrotPe/cz6O7B/m
        5Fng4YE8NGh4Osm1yurapzz13Z3HWJ0=
X-Google-Smtp-Source: APiQypI0ovxnSnLxg4sonbzSoaCoggnNvGwbnayVuFhFszPHXdDB8xcLJKhFvQWxMr94hs1LH2dhlg==
X-Received: by 2002:adf:e681:: with SMTP id r1mr7492314wrm.213.1587674420911;
        Thu, 23 Apr 2020 13:40:20 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u17sm5933726wra.63.2020.04.23.13.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 13:40:20 -0700 (PDT)
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
Subject: [PATCH 4.4 03/16] devres: Align data[] to ARCH_KMALLOC_MINALIGN
Date:   Thu, 23 Apr 2020 21:40:01 +0100
Message-Id: <20200423204014.784944-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200423204014.784944-1-lee.jones@linaro.org>
References: <20200423204014.784944-1-lee.jones@linaro.org>
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

