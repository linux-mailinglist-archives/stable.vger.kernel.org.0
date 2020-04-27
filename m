Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E31D1B97DE
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 08:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgD0G7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 02:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbgD0G7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 02:59:30 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D417FC061A0F
        for <stable@vger.kernel.org>; Sun, 26 Apr 2020 23:59:28 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t16so6635412plo.7
        for <stable@vger.kernel.org>; Sun, 26 Apr 2020 23:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Sq2wT2SFz3pYBy4+J5vMJ7XXvctBcG1IxWJshVIua6Q=;
        b=ab7k3NG46suCxET8F01kdzOzWHGD65fFSUPegXgEFsaHjgSn5k2TbD6QAumAjKuSDj
         emsmDBoUGQx5xfZ/etovDtYdBSePjlyJW9x9cwQOXG+/TpOteXT+CQMLKbf4soJAZYzn
         4UxjYPL0k045JkXzIMRNY7MNhsrw08G91ynuiGYLGxSOfy2Y/xcmJFvCRI7FbsnrvKnw
         1I+3AFgRm94TvDn7OWuENqoNi2cPXfJNGU2LoyUo4quaCnFNFLZkKnozS+s6htA3yw3t
         Djf6yGG5n2jiEOkBM5xP6c8CsNk0N0+Bak/stiJUxNdWtRMxbG/7LK79e3uXagbj5trC
         hnSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Sq2wT2SFz3pYBy4+J5vMJ7XXvctBcG1IxWJshVIua6Q=;
        b=VbpQ301c9XS+xt00x6vipiRrsD2kUOX7oDTIHnfM5MeDrq1Eydj8V+uCwBJOJUZXVt
         8dgEk3JpInr0j1D/p7dBKSYwJc/W+q50yn67+LkeKUGx2Rp4++jH4ROvLi9FYoRPSsWx
         J+B7Hlm0DwG+hRYDLEduJ+yqcxP8Ok5UbHrz6FNgTgftyBhSHD1tm17IlaXN046ZlaUF
         XdZ8T59zW8yrX3s0B7KU63qzqYOGQp80of+RHM600G+AebF7jinJ3XLrjCaUmelX8AdW
         pPKnCMoQZjYxXK+YirJOmAQqsqHlIsxtLxCFQLnAdLd5NpVEGfesUnRImxlavbyH9Nxt
         ZUqA==
X-Gm-Message-State: AGi0PubuqbBjlP7aZwawQcG4XFY/HmQic0MnPVMNotP+YJ23qvyL2bsB
        YiJ/1ELMsQPE/nmhEutoOMGc3A==
X-Google-Smtp-Source: APiQypJvhkTSISccdZ6P3eYi4EPU7GzAmyZm7mkfmmwhCAS6iHT+zJ2NfajrZcy1Ctz04qUSZgpubA==
X-Received: by 2002:a17:902:164:: with SMTP id 91mr11664335plb.207.1587970768283;
        Sun, 26 Apr 2020 23:59:28 -0700 (PDT)
Received: from VincentChen-ThinkPad-T480s.internal.sifive.com (114-34-229-221.HINET-IP.hinet.net. [114.34.229.221])
        by smtp.gmail.com with ESMTPSA id g40sm10442139pje.38.2020.04.26.23.59.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Apr 2020 23:59:27 -0700 (PDT)
From:   Vincent Chen <vincent.chen@sifive.com>
To:     paul.walmsley@sifive.com, palmer@dabbelt.com
Cc:     linux-riscv@lists.infradead.org,
        Vincent Chen <vincent.chen@sifive.com>, stable@vger.kernel.org
Subject: [PATCH v3] riscv: set max_pfn to the PFN of the last page
Date:   Mon, 27 Apr 2020 14:59:24 +0800
Message-Id: <1587970764-4393-1-git-send-email-vincent.chen@sifive.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The current max_pfn equals to zero. In this case, I found it caused users
cannot get some page information through /proc such as kpagecount in v5.6
kernel because of new sanity checks. The following message is displayed by
stress-ng test suite with the command "stress-ng --verbose --physpage 1 -t
1" on HiFive unleashed board.

 # stress-ng --verbose --physpage 1 -t 1
 stress-ng: debug: [109] 4 processors online, 4 processors configured
 stress-ng: info: [109] dispatching hogs: 1 physpage
 stress-ng: debug: [109] cache allocate: reducing cache level from L3 (too high) to L0
 stress-ng: debug: [109] get_cpu_cache: invalid cache_level: 0
 stress-ng: info: [109] cache allocate: using built-in defaults as no suitable cache found
 stress-ng: debug: [109] cache allocate: default cache size: 2048K
 stress-ng: debug: [109] starting stressors
 stress-ng: debug: [109] 1 stressor spawned
 stress-ng: debug: [110] stress-ng-physpage: started [110] (instance 0)
 stress-ng: error: [110] stress-ng-physpage: cannot read page count for address 0x3fd34de000 in /proc/kpagecount, errno=0 (Success)
 stress-ng: error: [110] stress-ng-physpage: cannot read page count for address 0x3fd32db078 in /proc/kpagecount, errno=0 (Success)
 ...
 stress-ng: error: [110] stress-ng-physpage: cannot read page count for address 0x3fd32db078 in /proc/kpagecount, errno=0 (Success)
 stress-ng: debug: [110] stress-ng-physpage: exited [110] (instance 0)
 stress-ng: debug: [109] process [110] terminated
 stress-ng: info: [109] successful run completed in 1.00s
 #

After applying this patch, the kernel can pass the test.

 # stress-ng --verbose --physpage 1 -t 1
 stress-ng: debug: [104] 4 processors online, 4 processors configured stress-ng: info: [104] dispatching hogs: 1 physpage
 stress-ng: info: [104] cache allocate: using defaults, can't determine cache details from sysfs
 stress-ng: debug: [104] cache allocate: default cache size: 2048K
 stress-ng: debug: [104] starting stressors
 stress-ng: debug: [104] 1 stressor spawned
 stress-ng: debug: [105] stress-ng-physpage: started [105] (instance 0) stress-ng: debug: [105] stress-ng-physpage: exited [105] (instance 0) stress-ng: debug: [104] process [105] terminated
 stress-ng: info: [104] successful run completed in 1.01s
 #

Fixes: 0651c263c8e3 (RISC-V: Move setup_bootmem() to mm/init.c)
Cc: stable@vger.kernel.org

Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Yash Shah <yash.shah@sifive.com>
Tested-by: Yash Shah <yash.shah@sifive.com>

Changes since v1:
1. Add Fixes line and Cc stable kernel
Changes since v2:
1. Fix typo in Anup email address
---
 arch/riscv/mm/init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index fab855963c73..157924baa191 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -149,7 +149,8 @@ void __init setup_bootmem(void)
 	memblock_reserve(vmlinux_start, vmlinux_end - vmlinux_start);
 
 	set_max_mapnr(PFN_DOWN(mem_size));
-	max_low_pfn = PFN_DOWN(memblock_end_of_DRAM());
+	max_pfn = PFN_DOWN(memblock_end_of_DRAM());
+	max_low_pfn = max_pfn;
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	setup_initrd();
-- 
2.7.4

