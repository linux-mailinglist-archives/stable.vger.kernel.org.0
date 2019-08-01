Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3D5D7D747
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730656AbfHAIU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:59 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39185 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbfHAIU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:59 -0400
Received: by mail-pf1-f196.google.com with SMTP id f17so29614381pfn.6
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=83Q5DLuQYSva53SfstGNLwQ+WusgochK7tEX54DLnZk=;
        b=rI4dN04PCrS8oEfhhu1FimQvBZ8VBzO1CvaxoGD0C6HzZI6J1xXoWDHX2NESLp/Gu7
         7/G8HfBb07K3/rgxPknRTOvB3aLF023teB3bfyIRyAR+J8H4K9LaMWtxu70jFDgK74EX
         d5yKiB/4rRbxtd1QdEtqb0PY9C3bjQM4DYhFHaErCxKRZDpe+KlfB4THeuDtUHgMKne0
         tAcVx3VWyyaYMIEQmAFWy51kwzUYHaZxrC4iPgcfUez/yyp4OS9lBBifrZ0sEM4m2uBe
         HN9oapm4F9z9UV++zkll/G0/DnOcFJFTYG1xzjUUiBgS5qLQw/8M46c9Qq8EW4MJ4sTk
         pdDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=83Q5DLuQYSva53SfstGNLwQ+WusgochK7tEX54DLnZk=;
        b=rTt8gxpf4edvAhgXritg6cCEyyYCghZ9a2rjygmIDWs093v1FHvTgLQ6Wu8kwfZeOF
         ynU9yJ7bCLCOneKTNh4ReDkMKLejcjBYH++INbgUqfRTwLlZTkLAExU5Q6C50nha56C4
         3sft9i5teS18i2kdmvOINOvbUaEoqEwAiyyGgk0gU5aPBWULxySgIg/PEqa4dg0zV2LJ
         dpGeclXzTSns7omKQRKcyRnAmO0EfSA0POKNzx4cOKAmwWXUInXiRKxYQ5Dlfb/KREO/
         Gyuzj6l+mc4mJe6S4dmLuNznEre6KTPiGgVs6NxH8jK1tIPgaBRbT6MGPVyPVLpagRZX
         vKjw==
X-Gm-Message-State: APjAAAWK9Le13+BbAMUJLayscaSA7MVX+n/a8YerXaZdvGipeCElJrNP
        +Dt8rLhIYRCl6CNBlREfwO6duivIvnk=
X-Google-Smtp-Source: APXvYqzngxuyD04VCRkFZTzoAlqHmHgivTldcuqpxXRziSfFGEKiXB/CnfRGlITASbXm+JzerEuOIA==
X-Received: by 2002:a62:14c4:: with SMTP id 187mr50562879pfu.241.1564647658137;
        Thu, 01 Aug 2019 01:20:58 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id j1sm95276210pgl.12.2019.08.01.01.20.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:57 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 32/47] ARM: 8794/1: uaccess: Prevent speculative use of the current addr_limit
Date:   Thu,  1 Aug 2019 13:46:16 +0530
Message-Id: <74663c62c712201d35d012eba43ad611b6c5a3fe.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

Commit 621afc677465db231662ed126ae1f355bf8eac47 upstream.

A mispredicted conditional call to set_fs could result in the wrong
addr_limit being forwarded under speculation to a subsequent access_ok
check, potentially forming part of a spectre-v1 attack using uaccess
routines.

This patch prevents this forwarding from taking place, but putting heavy
barriers in set_fs after writing the addr_limit.

Porting commit c2f0ad4fc089cff8 ("arm64: uaccess: Prevent speculative use
of the current addr_limit").

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/include/asm/uaccess.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index ecd159b45f12..a782201a2629 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -99,6 +99,14 @@ extern int __put_user_bad(void);
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
+
 	modify_domain(DOMAIN_KERNEL, fs ? DOMAIN_CLIENT : DOMAIN_MANAGER);
 }
 
-- 
2.21.0.rc0.269.g1a574e7a288b

