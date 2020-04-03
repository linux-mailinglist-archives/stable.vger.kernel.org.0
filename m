Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C16E19D68D
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 14:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgDCMS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 08:18:29 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45955 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403879AbgDCMS3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 08:18:29 -0400
Received: by mail-wr1-f68.google.com with SMTP id t7so8226485wrw.12
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 05:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+qhXDspqzMy/AjzcIY5DO4b+V5ek/qsdVK5p3wmyDGc=;
        b=fhekaYUUgpELQx5YegKMndJn/H0gp3A0oJLrCtPGM7LsisLSxrkAK+uwCtNZsn1riv
         f2ClAoyD3BuOiWZRSQ9sZcrHG7QoVgRp4PBLaxZW/uldvI7AtqPNakRsvbDJCkfM7IdT
         3XSzhxNUG9woorRJ94GvvT5eKhx/yLKPxE8SoaDyghuBsoGtNWRcAtxiW4SlGQYB4Qbt
         7rAcxoOPACRCs842RNxxmnnQcQLnB4egeqc1XQmEGzMEBJyriSXSNbS0M5H3Aggn3SG9
         wQjU1LIhjhmy3z6iDP4H5/6CrDoQBEMUPxZVXQ7TOPel2bukl3+f8x7P/f2nHHDLKZW8
         OZPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+qhXDspqzMy/AjzcIY5DO4b+V5ek/qsdVK5p3wmyDGc=;
        b=mta90l28H1g0xy5h++KvMOgsLKy2SyZO0VV+SxrZEgBp9Ub2KiuwrA3pLD73UmgyDB
         ex1j/tjA8mffgU1gozjkc3fTKPgVUwwYoaiDKo25j5bVYKZfLmG6zLGjA2ztosK7jWYs
         1Hs6n5Mtg6QClZkGfW+S3cSyfMRjgAO0PdPp1HLKYqEaFKeZr83rkX9fg611+5Z1ifk6
         zO0TzokKSPlHxwZcqZpuOpxvwSg007dDiBXPCx7JD7UxUkH5gXfs49qwl4DwmyUO2DLc
         ihvcv4BVcmY/jnPJczJz3SG3Sgt9FulhVLuFh6XbsczR5ccJDo8jtlRvBvkG6p2CK4LE
         fh0Q==
X-Gm-Message-State: AGi0PuZ96ZddpYBex1V08HmylaiFNCE0Ya1IiaxMunJoy5iRUju+TB7O
        OnqlbweG6w6vJlVE0A6HkdNT5hR67Xg=
X-Google-Smtp-Source: APiQypLv5QaTJOaf4AmYT0fY3p3dIakFSmQ3GLW+iCIwCrUOZYrl/BqB3cHon9dcD6N9lglbtVxzAg==
X-Received: by 2002:a5d:4003:: with SMTP id n3mr8404420wrp.176.1585916308329;
        Fri, 03 Apr 2020 05:18:28 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.179])
        by smtp.gmail.com with ESMTPSA id l185sm11377712wml.44.2020.04.03.05.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 05:18:27 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Arun KS <arunks@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 03/13] arm64: Fix size of __early_cpu_boot_status
Date:   Fri,  3 Apr 2020 13:18:49 +0100
Message-Id: <20200403121859.901838-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200403121859.901838-1-lee.jones@linaro.org>
References: <20200403121859.901838-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun KS <arunks@codeaurora.org>

[ Upstream commit 61cf61d81e326163ce1557ceccfca76e11d0e57c ]

__early_cpu_boot_status is of type long. Use quad
assembler directive to allocate proper size.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Arun KS <arunks@codeaurora.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm64/kernel/head.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 06058fba5f86c..d22ab8d9edc95 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -667,7 +667,7 @@ ENTRY(__boot_cpu_mode)
  * with MMU turned off.
  */
 ENTRY(__early_cpu_boot_status)
-	.long 	0
+	.quad 	0
 
 	.popsection
 
-- 
2.25.1

