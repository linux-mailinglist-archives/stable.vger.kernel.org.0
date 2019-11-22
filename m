Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E106F106F29
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbfKVLN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:13:57 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36304 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbfKVKye (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 05:54:34 -0500
Received: by mail-wm1-f66.google.com with SMTP id n188so5132358wme.1
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 02:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xBQD+e/TnUVrvhwSCfQXht9+xwZCKiD7itNG4fU+Fq0=;
        b=WVUjmzQgnmX9m9kz5Ox6beljyZDlaEOGtdNKL53tvC5vFnYupaCa4+1B5efUOrUjp/
         +3yPYvcxdmY2MQMujBBqIPPIW3WxqrARpninMsxm0Zv5NV/Pm64YmpM2OK4Wafd/c020
         pvWCkw4hL6HAaxZxx53i+UdQ//rLOBsHtAoLVlJaXr+0cRcAhZ3BvW0DiqySruDsMBcl
         9/5uZNM0vZGQYC0rmV/NYFoX7bzOrRFKngDQVP2TcklGt242gOBznQRp+a/aLPiG3jJp
         quRBo6cW/H+KgYfBhuxfKHG8R19vkhUH+uw/dD7t65o8qlHltNuyTl3cQfShP5MubHq5
         1g0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xBQD+e/TnUVrvhwSCfQXht9+xwZCKiD7itNG4fU+Fq0=;
        b=hixpgrEnlHVJAWPSrfzGQu4EE3H2ePOINhIu6/WhuH0Mkt0nmPG60xV6KsRn322mQb
         5Nat0k0d+obBIRQHiaKiyIZfcO4meGYk/Dk7QgJTNDmPQtqmtHcQU/PEG4UNKOaQ2+Tr
         1zAmWzU4RXyMqNbNZ/79TXJAysFB+JdjB80ty6CDvJePLE5oL2A867ETACnMnRy6lDmJ
         bRhq0wqTRz8Njh7a/6PLSEl4RJMLmOSWmqJpkmSzHudi6dJlmVtNELarA9J7mBwSv1XJ
         OBOweUzjsRygsrGfdGWhYVFeOOYSeMPeIB04Dj73GWre0p0kmNo2zaG4Pz6Ey9DPOEHO
         Xw6g==
X-Gm-Message-State: APjAAAU1IWyifIxjFA4BjPDuxB5K7HiMJ4sFC7gWHBjUVHXkoZcwMKzk
        wtPSyFB2DKl7UYH2PKTnW6yI3MSEiXI=
X-Google-Smtp-Source: APXvYqyrWnOfdBFKsXmZeDpqxV5FXnA4shVI/ksqX+a5CWzkS6ruJq6wAJHziImDEv13ehjG/LONOA==
X-Received: by 2002:a1c:7fd8:: with SMTP id a207mr15933896wmd.10.1574420072495;
        Fri, 22 Nov 2019 02:54:32 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.135])
        by smtp.gmail.com with ESMTPSA id p14sm7498912wrq.72.2019.11.22.02.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 02:54:31 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, gregkh@google.com, stable@vger.kernel.org
Subject: [PATCH 5.3 1/2] ARM: 8904/1: skip nomap memblocks while finding the lowmem/highmem boundary
Date:   Fri, 22 Nov 2019 10:54:16 +0000
Message-Id: <20191122105417.11503-1-lee.jones@linaro.org>
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
index d5e0b908f0ba..25da9b2d9610 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1197,6 +1197,9 @@ void __init adjust_lowmem_bounds(void)
 		phys_addr_t block_start = reg->base;
 		phys_addr_t block_end = reg->base + reg->size;
 
+		if (memblock_is_nomap(reg))
+			continue;
+
 		if (reg->base < vmalloc_limit) {
 			if (block_end > lowmem_limit)
 				/*
-- 
2.24.0

