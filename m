Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6B4106F7B
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbfKVKvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:51:33 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42618 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729140AbfKVKvc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 05:51:32 -0500
Received: by mail-wr1-f66.google.com with SMTP id a15so8026736wrf.9
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 02:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hOK9c8LEfLGj1ZQvql1/dtYzUEEKXclu/9p6dFGwKr8=;
        b=WICBWhDIxvmJEc7PpyTMY93WSKHgLq3kfcXfcaEZfFENdrN1bqWqoqPBsjtJiGyZko
         wyRF6TmX6SqGKZwfy+9QqaVF2pYfN9quqczBr3TaEclRSjPKHUxTKjDqDEZJgtpgEYmD
         21AoLQdHdKXLEN9f633cO4K5eHjwRL+Vr7KA4LK9mV4956R8/6EA8RvDEcPySSgzvcAo
         KcwP9KDMebhwxeQgZVd6CcONWCdlmHLD0jNW1Dku7DM5Xa2KRSxhIbAwEUlB3dv5WmqO
         XFjR5DLOViJLI6Jwmd+EMIJtMMPfzv7z5KqRl8PEyXgKnhC7twcGx+8+Ac3bBtV97Ad5
         bg5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hOK9c8LEfLGj1ZQvql1/dtYzUEEKXclu/9p6dFGwKr8=;
        b=EHjICR1hwMiXu578DBzkCfcD7W+eZgCrYZBcDyUTWnmDzzD6muSAdQgbi2iLpv/Yxg
         SWz3x9haav0XXjlAPDHW+CpYUq80TQukgWQ1VLBwm7QZFwatN7S5qFMdbZNjXg4BlG/N
         VdOS4PMIUnF08B/LQ3LyVn85BkYqHjfhXj7FEX0Zov5a481IX8Hz1hT8vfUFcBsXl7Sz
         kfGewnihxhGfX5x/umX9TWzWGdHaPP/iUGk4kGxIDG0U4EK8NE3fatZOirCggkRXmpK+
         K6ht1sr73lmKwU6sAu4nD0Z8fycK+7DXEuVS/ZlbWgs98a01OQV6mINOtXSDwIeGAmQU
         QZ2Q==
X-Gm-Message-State: APjAAAV3dFjMBGLxN0M5r7cj8cZ7xYmGvmZJxAcqTzQxORHjAtvUsDfQ
        xmEv3Ac+ncis+3O5I08HUQL4vg==
X-Google-Smtp-Source: APXvYqxG15RnzO4RcYrT/fg5DLG7A9GisPxgTf/xPtBJI4s5EbVViGQY+AtAQlEyu44NuSLVk8XCcA==
X-Received: by 2002:adf:ef51:: with SMTP id c17mr18196011wrp.266.1574419891724;
        Fri, 22 Nov 2019 02:51:31 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.135])
        by smtp.gmail.com with ESMTPSA id w4sm2894338wmk.29.2019.11.22.02.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 02:51:31 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, gregkh@google.com, stable@vger.kernel.org
Subject: [PATCH 4.4 1/9] ARM: 8904/1: skip nomap memblocks while finding the lowmem/highmem boundary
Date:   Fri, 22 Nov 2019 10:51:05 +0000
Message-Id: <20191122105113.11213-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chester Lin <clin@suse.com>

[ Upstream commit 1d31999cf04c21709f72ceb17e65b54a401330da ]

adjust_lowmem_bounds() checks every memblocks in order to find the boundary
between lowmem and highmem. However some memblocks could be marked as NOMAP
so they are not used by kernel, which should be skipped while calculating
the boundary.

Signed-off-by: Chester Lin <clin@suse.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mm/mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index aead23f15213..d9ddb5721565 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1121,6 +1121,9 @@ void __init sanity_check_meminfo(void)
 		phys_addr_t block_end = reg->base + reg->size;
 		phys_addr_t size_limit = reg->size;
 
+		if (memblock_is_nomap(reg))
+			continue;
+
 		if (reg->base >= vmalloc_limit)
 			highmem = 1;
 		else
-- 
2.24.0

