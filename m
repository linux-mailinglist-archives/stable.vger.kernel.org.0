Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEF6466628
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfGLF3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:29:19 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46782 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLF3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:29:19 -0400
Received: by mail-pf1-f193.google.com with SMTP id c73so3776202pfb.13
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gNlfncScxDREAT7VjTEXAFzdaeKYbTqQ4JYCBMZ7gaA=;
        b=cKXVVMIE78QmcDsJ8R1sTpeboiLZLLwZ56moXlqZPVbf8aD8vMMu4Pvrm2aCvGwZUe
         /q51yWLi8ZVUyVOJ+XpmDnfQMDM0AlfnbywjiCvIB8wYmBsxXtXVZiSU4BC7t9OVilng
         DG/7xeCbeqrNVTU6/lMYNfpfYsOAMgVe6IN/V03s1mYMoXp5axz+HSBQ0IKiyltXMSFr
         wRoTudkSz8nW8zy40AXY6gIncpiXe57jVQfwyA15sxy9Dh5Oy0kVl+sjVutCkc/aoLA5
         8lD5nJwig2b9lUBOJtdhwXQbno+v6eTUCAbdE1ByEBqwET4r6XcsfkpaytrzUd0dbnYx
         uTmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gNlfncScxDREAT7VjTEXAFzdaeKYbTqQ4JYCBMZ7gaA=;
        b=toa87nRIySIZjBRF5MkY7zhkfRm2viFKQidbGMSsDED3OdOWfq8UQm5kfCRDxaRUVB
         nmcrXcyP2oTKnc3/oNtwjemgqmKGfKMwy0EIyFI1ZjeJU3AFO0jW9oy6OD6lbZqDTXTi
         LJpbenZLk48POiVU3jvhys5XwauJ2WZnSW6GpvgPXLU4qKeXs2FKRM3VPVaOMNcjs5qO
         0PAqv8smFU7Xr/4pc/tEix4qfxFfMNOaP0VYgwzoDXNcPoyk04D1LzyBL15+jBMy8Pyt
         8gH4hTeAFjFPyIThK1rktUiqBmOnPk4wIYF/1jXuUbsFvtHmlSsAjaiGtzNV1IdTXwa5
         2OZg==
X-Gm-Message-State: APjAAAW7HMMG/qhDXJ/2L4eWFBKqWNsGi1r99vGvqAJFz7GLnSkMpokj
        M8G52wY0pSFoD7UAUovFMYG58dIa2Xo=
X-Google-Smtp-Source: APXvYqzOs7AoxIeTNlLbUFu/r10BOMxy5Hb11XJhBZ3loQ0w6O6qKzqvd0UQkPq53twoAlpesJxRqQ==
X-Received: by 2002:a17:90a:cb12:: with SMTP id z18mr9007071pjt.82.1562909358269;
        Thu, 11 Jul 2019 22:29:18 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id o14sm13901475pfh.153.2019.07.11.22.29.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:29:17 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 V2 07/43] arm64: uaccess: Prevent speculative use of the current addr_limit
Date:   Fri, 12 Jul 2019 10:57:55 +0530
Message-Id: <ff66d290deda6313f175c9462a29054c58e8414a.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
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

