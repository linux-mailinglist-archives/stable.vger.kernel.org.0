Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58BDEFBD51
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 02:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfKNBIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 20:08:46 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44604 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbfKNBIq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 20:08:46 -0500
Received: by mail-lf1-f66.google.com with SMTP id z188so3516960lfa.11;
        Wed, 13 Nov 2019 17:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wBQHB2EzlG/RSRWYzzXHGHn7Pgw3gzypxOnIpXuT5fc=;
        b=dLdhF2PzyQ/jFoL4zrJ4qhDA2R7hCREOwWVwawyuVHALBhJHtbEXnCQz1uUxkzTNLq
         wCyutaWHNPjDEhXkiQn8T65OcpDyFgntNJWyA9noEO11ZSotKuO8nD+93Q+0PS/BMbYD
         JF+fT85rjf2Z0MQfsES+fuUDd5zXynLC9SCN8gKCYXwzdfNUnQRZNJLTgOch7duW1qyU
         6X31e2ITWOiWXpzgnOrTxuO9KfNtX7z6XWxKSt17khUaC/c68B05BjDz5rhqOdIUuXHy
         ZOY9HXj8XNP4Ox8HFRpuAZaoE/ALG4L6YOVT7bqNFoE0bxAJ/IiJeUggbYcKtM4roz5S
         pw2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wBQHB2EzlG/RSRWYzzXHGHn7Pgw3gzypxOnIpXuT5fc=;
        b=pEQ9AsWrOo5q89uX/8rtrqgwemvp8sPJhOgO5NX8XvhVrBUlUEJXB33SDX0ixVH4dY
         Vv27gFxURPeWV9o4JXhYf69arYGRrMtf4z7E9osULssEyd3mHyBBy623NE3LTp1X/VCr
         kT6xXHQAb7J3wecFfaaY+FCwG8PhZAMcYkMVGyISXE/RSkS0I7WxJlllriGPjBe6TPl+
         +coKehksw7DGhaoZTxTqp1ytODRyFtotiFhSuhkf7ELzXFK1u6yaNE0wmW6PYwhmaIAv
         sdzE4ltObhsuka2Pl/1rjVAetkbwXzRuX+esqkaPONhI01s1/uPbvK8EtktbxcCPn7l8
         yUHw==
X-Gm-Message-State: APjAAAU1DcTJW71IssO3gVJ5NMUzCEspRRd6mLAI85Ze1Phu5TAOefgR
        kIE0uD8Z1QSfzZ6yHGa/pEY=
X-Google-Smtp-Source: APXvYqyjODrUidyRiNtKsHWwCmupyjlQdwCeGsh09cvSNBIORfw8Pm8KVk1OyhKrkpCWYVOWGegIsg==
X-Received: by 2002:a19:ee17:: with SMTP id g23mr4590004lfb.121.1573693723677;
        Wed, 13 Nov 2019 17:08:43 -0800 (PST)
Received: from octofox.cadence.com (jcmvbkbc-1-pt.tunnel.tserv24.sto1.ipv6.he.net. [2001:470:27:1fa::2])
        by smtp.gmail.com with ESMTPSA id b14sm1726678lfa.14.2019.11.13.17.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 17:08:43 -0800 (PST)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>,
        Mike Rapoport <rppt@linux.ibm.com>,
        linux-kernel@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] xtensa: use MEMBLOCK_ALLOC_ANYWHERE for KASAN shadow map
Date:   Wed, 13 Nov 2019 17:08:24 -0800
Message-Id: <20191114010824.29540-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

KASAN shadow map doesn't need to be accessible through the linear kernel
mapping, allocate its pages with MEMBLOCK_ALLOC_ANYWHERE so that high
memory can be used. This frees up to ~100MB of low memory on xtensa
configurations with KASAN and high memory.

Cc: stable@vger.kernel.org # v5.1+
Fixes: f240ec09bb8a ("memblock: replace memblock_alloc_base(ANYWHERE)
		     with memblock_phys_alloc")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/mm/kasan_init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/xtensa/mm/kasan_init.c b/arch/xtensa/mm/kasan_init.c
index 9c957791bb33..e3baa21ff24c 100644
--- a/arch/xtensa/mm/kasan_init.c
+++ b/arch/xtensa/mm/kasan_init.c
@@ -60,7 +60,9 @@ static void __init populate(void *start, void *end)
 
 		for (k = 0; k < PTRS_PER_PTE; ++k, ++j) {
 			phys_addr_t phys =
-				memblock_phys_alloc(PAGE_SIZE, PAGE_SIZE);
+				memblock_phys_alloc_range(PAGE_SIZE, PAGE_SIZE,
+							  0,
+							  MEMBLOCK_ALLOC_ANYWHERE);
 
 			if (!phys)
 				panic("Failed to allocate page table page\n");
-- 
2.20.1

