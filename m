Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403E62598EE
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730604AbgIAPaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:30:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730596AbgIAPaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:30:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F087207D3;
        Tue,  1 Sep 2020 15:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974217;
        bh=ALYJ0PwkIOyn+zIbpSyguYiW+bBvfEuoxI+K2epU1AY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjhrix+2SAHM8z9sT1Egxjsm13cbtuSmPnTrbcmwrZ8MHpJkt1DHkWE+hGNgoD/QR
         PTWNgFJAK9eX4EP5PkUfv2B8x4reLk4xLBsbB+U1E/hwYfNnXe9oQ0J1C0spszWBjR
         saQ1fbOaUHqvPZEOM6i0VWb4m4U+Ir8QfmsT4vQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harish Sriram <harish@linux.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/214] mm/vunmap: add cond_resched() in vunmap_pmd_range
Date:   Tue,  1 Sep 2020 17:09:29 +0200
Message-Id: <20200901150957.259958320@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e47110e90584a22e9980510b00d0dfad3a83354e ]

Like zap_pte_range add cond_resched so that we can avoid softlockups as
reported below.  On non-preemptible kernel with large I/O map region (like
the one we get when using persistent memory with sector mode), an unmap of
the namespace can report below softlockups.

22724.027334] watchdog: BUG: soft lockup - CPU#49 stuck for 23s! [ndctl:50777]
 NIP [c0000000000dc224] plpar_hcall+0x38/0x58
 LR [c0000000000d8898] pSeries_lpar_hpte_invalidate+0x68/0xb0
 Call Trace:
    flush_hash_page+0x114/0x200
    hpte_need_flush+0x2dc/0x540
    vunmap_page_range+0x538/0x6f0
    free_unmap_vmap_area+0x30/0x70
    remove_vm_area+0xfc/0x140
    __vunmap+0x68/0x270
    __iounmap.part.0+0x34/0x60
    memunmap+0x54/0x70
    release_nodes+0x28c/0x300
    device_release_driver_internal+0x16c/0x280
    unbind_store+0x124/0x170
    drv_attr_store+0x44/0x60
    sysfs_kf_write+0x64/0x90
    kernfs_fop_write+0x1b0/0x290
    __vfs_write+0x3c/0x70
    vfs_write+0xd8/0x260
    ksys_write+0xdc/0x130
    system_call+0x5c/0x70

Reported-by: Harish Sriram <harish@linux.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200807075933.310240-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmalloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ad4d00bd79147..5797e1eeaa7e6 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -85,6 +85,8 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end)
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
 		vunmap_pte_range(pmd, addr, next);
+
+		cond_resched();
 	} while (pmd++, addr = next, addr != end);
 }
 
-- 
2.25.1



