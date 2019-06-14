Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4C2345261
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbfFNDMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:12:03 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38055 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDMD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:12:03 -0400
Received: by mail-pg1-f193.google.com with SMTP id v11so676599pgl.5
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q2UDagaQQzh/lIVkivR+vaM0gPa+GGbgrufLmqcYVmM=;
        b=z3CUixoaajCn7ukcAhM7vkUe1zw7MOgiuw2Yef1G/TazLJGzHQAa4ZoBlMwRUSAVfL
         PfJPSuV4wbp5CAeEtjL34L+ogPzomyWYKTmVBJt0BL7qU3BxUINc0UIEseTbWjNsGYPv
         P3oKFJanLdaBaPZdNokLjFrQTZ65RGkSFmelnFN5ycYOEOXsSD0CiFz0u8Bji79hnW6e
         ne7WJ2kUmZSMvQKp/F7I7BrGpSRUBVpIjcMBJGESvXsfNOVx440zFhkywbsKP9fvJI0f
         mWWiFnykxAGVuYgqhbzMe+ENGiY9PnMZMfudq6xxIoRW0OrCE3I6qZgy7fqigeaGtuYQ
         9FVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q2UDagaQQzh/lIVkivR+vaM0gPa+GGbgrufLmqcYVmM=;
        b=Ep6UqtkN8zyf8Iy3sKmw14/KVz7it+gsoi/QW3U0l46D/tEgMCfwqsTQssbgiAOWrd
         mhhcMOuItg/Nn5DddW9aGRMb/OQifrpVOX02wcQH9iJ/8mJCJA7A+Bq5fhSScH4LET1y
         FPSel1mRB60cDt7ad8o4Vaa/P0l5TW7T674KAunH4tG+HcZIxql9ocQTVCCd7D13wZuc
         rouhUPtJbfwfO4+tY48g/qgp24UIZPcrHRCZCwChNwmHxa/T/rBc3/heVr/aqn0iu0kW
         zpY/cwdFi8slmLbb3LoFuEnIfPjBGSfcw1TnHH8tshpHhyi1X53f9/fpTVf1v09vy0z9
         c7NA==
X-Gm-Message-State: APjAAAVDh+gD12gaVFRl0G8U94dnLeTi7YnEGQiVOhXRMZRoAMAgdVO4
        a3xHeDosbp3VOGjqYkdnWaDslA==
X-Google-Smtp-Source: APXvYqw0YdgiXz5axjmwP8zKQfiE6/6qJ1tgfUBgYclyADpY01E8vwVgnU4EZUdMf24QwT3WxVf5hg==
X-Received: by 2002:a62:78c2:: with SMTP id t185mr27057268pfc.142.1560481922495;
        Thu, 13 Jun 2019 20:12:02 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id 23sm1006127pfn.176.2019.06.13.20.12.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:12:02 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 03/45] arm64: remove duplicate macro __KERNEL__ check
Date:   Fri, 14 Jun 2019 08:37:46 +0530
Message-Id: <397130f9dfb4aa9a600872fb5ed66c90664b830f.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zijun_hu <zijun_hu@htc.com>

commit a842789837c0e3734357c6b4c54d39d60a1d24b1 upstream.

remove duplicate macro __KERNEL__ check

Signed-off-by: zijun_hu <zijun_hu@htc.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/processor.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index d08559528927..b1126eea73ae 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -35,7 +35,6 @@
 #include <asm/ptrace.h>
 #include <asm/types.h>
 
-#ifdef __KERNEL__
 #define STACK_TOP_MAX		TASK_SIZE_64
 #ifdef CONFIG_COMPAT
 #define AARCH32_VECTORS_BASE	0xffff0000
@@ -47,7 +46,6 @@
 
 extern phys_addr_t arm64_dma_phys_limit;
 #define ARCH_LOW_ADDRESS_LIMIT	(arm64_dma_phys_limit - 1)
-#endif /* __KERNEL__ */
 
 struct debug_info {
 	/* Have we suspended stepping by a debugger? */
-- 
2.21.0.rc0.269.g1a574e7a288b

