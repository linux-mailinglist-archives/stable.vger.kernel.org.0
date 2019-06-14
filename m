Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB61745267
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbfFNDMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:12:16 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45352 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:12:16 -0400
Received: by mail-pg1-f195.google.com with SMTP id s21so654929pga.12
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gNlfncScxDREAT7VjTEXAFzdaeKYbTqQ4JYCBMZ7gaA=;
        b=wDBo+IsE5CxYBr/gG7jlwGTkzvTi/KgR2RgJSMhJe7bSxoaXzF0+TdDNJK6dLehXAQ
         KEE7UfEPuEEdzLtOeDJj3d79e7YtVNq/zUYfIVHlxutsUIdQWnMOok8xzhUVGO/wTU68
         ulCOJAXaMZaEp6vk5Lt1C67hIvkuulYIejzeRyCLcBuX3IVSZwH8JSIlylhk7jf5ZZAp
         ekJFzgWJkOPfXRXpgRLg5XEs6n3l8kd4NqIboYgsZw8aMww1p5p+juY2j8+fPoHS7L27
         QCdRJg5NSWYQy3xOzfV5YkvCjGSfOV9srWU2QmGPVppmd2e1TGCJfqCvS3ceOE1+BmUc
         vgBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gNlfncScxDREAT7VjTEXAFzdaeKYbTqQ4JYCBMZ7gaA=;
        b=YsqKHugJFKF64pqYBz4Ekr4RpHUVH5do3LIEaSH44EZOP1r6N7AuLHNSOKXFDvlYJF
         G8f6KfgbR1qmBV6A0kfRiAEGQm4UKjnAxBf2SjmodWb597URVxjMwyle0do+Vml+hKBa
         RizgKW6cdl4q+9RDR+GHpbK4TJ7IhwaAWgdBANmZqtEMDZi/CJTR+oPBEA64Z2xFzSqT
         FbFSaHRVVAyN6w82JYt/272gvFLsQwM1HYnZLN9HmYaU7KjW2rYqJ/ifwyH4AG2M3efr
         levUnNnflThquLqyMxB4oETAmDahlponzxYX3LMd0X+DSt4Yc4D0RhYNNom45sXsWuH9
         uuwQ==
X-Gm-Message-State: APjAAAUVBKClRp3PnISZp+Owwd7Wrd4nF1U4GrhsvKTvWuKTU+j92D/Z
        biDx1xmGQZ//SPJ0bG1XbOf6wg==
X-Google-Smtp-Source: APXvYqxXLdh+hW79HVWpzsOUs22+BCA1RGWX6SL5TD48wRXqUskcIIBZrBw2ipSX0bh2MrBWtNwIEg==
X-Received: by 2002:a63:e60b:: with SMTP id g11mr13414619pgh.172.1560481935400;
        Thu, 13 Jun 2019 20:12:15 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id g8sm1048468pfi.8.2019.06.13.20.12.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:12:14 -0700 (PDT)
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
Subject: [PATCH v4.4 08/45] arm64: uaccess: Prevent speculative use of the current addr_limit
Date:   Fri, 14 Jun 2019 08:37:51 +0530
Message-Id: <d74517ad6c0ca7d077063c18cd1930aa6bcb503c.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit c2f0ad4fc089cff81cef6a13d04b399980ecbfcc upstream.

A mispredicted conditional call to set_fs could result in the wrong
addr_limit being forwarded under speculation to a subsequent access_ok
check, potentially forming part of a spectre-v1 attack using uaccess
routines.

This patch prevents this forwarding from taking place, but putting heavy
barriers in set_fs after writing the addr_limit.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/uaccess.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 75363d723262..fc11c50af558 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -62,6 +62,13 @@ extern int fixup_exception(struct pt_regs *regs);
 static inline void set_fs(mm_segment_t fs)
 {
 	current_thread_info()->addr_limit = fs;
+
+	/*
+	 * Prevent a mispredicted conditional call to set_fs from forwarding
+	 * the wrong address limit to access_ok under speculation.
+	 */
+	dsb(nsh);
+	isb();
 }
 
 #define segment_eq(a, b)	((a) == (b))
-- 
2.21.0.rc0.269.g1a574e7a288b

