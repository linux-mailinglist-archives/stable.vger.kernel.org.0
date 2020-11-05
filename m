Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C112A845F
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 18:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730975AbgKERC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 12:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729980AbgKERC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 12:02:56 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D7CC0613CF;
        Thu,  5 Nov 2020 09:02:54 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id y7so788801pfq.11;
        Thu, 05 Nov 2020 09:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MFo6Y7rYb87Eb88yyF9Bn0rmWzJw6Hl9bFsypbTQVcY=;
        b=SsicXe73212qOk3V2lmG298fU6pI6n8NPV5V83gOgrX2NYmDvjMmXX1oMK7aaz9UYY
         J3NhFT+8ZM7p8/B5DYIqkAMY4OzBqRCWDljXx0IPDzxt6SmPGWFkVQtbwrwOHMwrenVA
         BQDlA54czjuSjNJrnXW+ovEvH0/WXPKCCbLcvb5eeyNb+Uf5x3vwci6jrgBhgQMl/6bD
         iHu2i7q88SMGpWQH59nvzEuu1nJN5s8FbTK09fJQd0tDfeQMKKQ7QaMHkm/3s04Qx1xY
         9t2pxYyp65HYTwEa0xNc20qyhA8mtLEXPCybpu4UJ92KWrADaJ/Q++gC4rUwOyiQX2b4
         dSTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=MFo6Y7rYb87Eb88yyF9Bn0rmWzJw6Hl9bFsypbTQVcY=;
        b=iwb+qpJTMmLmpjQjK7ch1q/Ub8F9tPXAHCEdYH3PwsrTOsKhOpB62os3es1iW1sqUK
         JetRKCaLuzcm3KHsqpDZHK6Yojaa3SlTnmRK/xIlu7sAbdSqesqWLSr7TmkoZQsmm817
         QKy+ssIPBZVVl+s8k/E5oXHUTo0pf/TpH9XDzHribudkYLWiyBwuj2vFvS4xl6z8zBNR
         6KmxXet7+BFySoEij7sGAJkVtNM4l9RF/vV+0mRRXAsrk9n+mAY/2x21pZ/JLaDujUa3
         jdGl0ncxT4dfKe/AJZ05Jn/qDhG+USetL2S1DbNGxQc5vUMhheCNrz1nSl1dZ5gPfnSC
         Jvqw==
X-Gm-Message-State: AOAM533LJ1ZAORE3EVK7xuE/aBpWQ/GY6y0Nugjj6OFOet7a7++W1Obi
        s6p6Uck3wAfvPYZsuWcUdn4=
X-Google-Smtp-Source: ABdhPJwE7qwJZo1qbYdWfUdjZNFKU/vsS216FqHbSWwFFHJIQ/6Dy/foejFEnMsWpMoV6D7q8QaVrQ==
X-Received: by 2002:a63:c945:: with SMTP id y5mr3274005pgg.118.1604595774281;
        Thu, 05 Nov 2020 09:02:54 -0800 (PST)
Received: from bbox-1.mtv.corp.google.com ([2620:15c:211:201:7220:84ff:fe09:5e58])
        by smtp.gmail.com with ESMTPSA id b185sm2972745pgc.68.2020.11.05.09.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 09:02:53 -0800 (PST)
Sender: Minchan Kim <minchan.kim@gmail.com>
From:   Minchan Kim <minchan@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        Minchan Kim <minchan@kernel.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Harish Sriram <harish@linux.ibm.com>, stable@vger.kernel.org
Subject: [PATCH] Revert "mm/vunmap: add cond_resched() in vunmap_pmd_range"
Date:   Thu,  5 Nov 2020 09:02:49 -0800
Message-Id: <20201105170249.387069-1-minchan@kernel.org>
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit e47110e90584a22e9980510b00d0dfad3a83354e.

While I was doing zram testing, I found sometimes decompression failed
since the compression buffer was corrupted. With investigation,
I found below commit calls cond_resched unconditionally so it could
make a problem in atomic context if the task is reschedule.

Revert the original commit for now.

[   55.109012] BUG: sleeping function called from invalid context at mm/vmalloc.c:108^M
[   55.110774] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 946, name: memhog^M
[   55.111973] 3 locks held by memhog/946:^M
[   55.112807]  #0: ffff9d01d4b193e8 (&mm->mmap_lock#2){++++}-{4:4}, at: __mm_populate+0x103/0x160^M
[   55.114151]  #1: ffffffffa3d53de0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0xa98/0x1160^M
[   55.115848]  #2: ffff9d01d56b8110 (&zspage->lock){.+.+}-{3:3}, at: zs_map_object+0x8e/0x1f0^M
[   55.118947] CPU: 0 PID: 946 Comm: memhog Not tainted 5.9.3-00011-gc5bfc0287345-dirty #316^M
[   55.121265] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014^M
[   55.122540] Call Trace:^M
[   55.122974]  dump_stack+0x8b/0xb8^M
[   55.123588]  ___might_sleep.cold+0xb6/0xc6^M
[   55.124328]  unmap_kernel_range_noflush+0x2eb/0x350^M
[   55.125198]  unmap_kernel_range+0x14/0x30^M
[   55.125920]  zs_unmap_object+0xd5/0xe0^M
[   55.126604]  zram_bvec_rw.isra.0+0x38c/0x8e0^M
[   55.127462]  zram_rw_page+0x90/0x101^M
[   55.128199]  bdev_write_page+0x92/0xe0^M
[   55.128957]  ? swap_slot_free_notify+0xb0/0xb0^M
[   55.129841]  __swap_writepage+0x94/0x4a0^M
[   55.130636]  ? do_raw_spin_unlock+0x4b/0xa0^M
[   55.131462]  ? _raw_spin_unlock+0x1f/0x30^M
[   55.132261]  ? page_swapcount+0x6c/0x90^M
[   55.133038]  pageout+0xe3/0x3a0^M
[   55.133702]  shrink_page_list+0xb94/0xd60^M
[   55.134626]  shrink_inactive_list+0x158/0x460^M

Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Harish Sriram <harish@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/vmalloc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6ae491a8b210..a4f1d39ce710 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -102,8 +102,6 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
 		vunmap_pte_range(pmd, addr, next, mask);
-
-		cond_resched();
 	} while (pmd++, addr = next, addr != end);
 }
 
-- 
2.29.1.341.ge80a0c044ae-goog

