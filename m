Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CF31B9749
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 08:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgD0GTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 02:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726246AbgD0GTQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 02:19:16 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2A8C061A0F
        for <stable@vger.kernel.org>; Sun, 26 Apr 2020 23:19:16 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y25so8489754pfn.5
        for <stable@vger.kernel.org>; Sun, 26 Apr 2020 23:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=rvwOMHyXDNyImD45ns9UEbHv3lzL0MdhHR3ZheOkyjk=;
        b=PhE2X16hFZl7dA8VvsBnxP1uZ0UyNDlbZ6CJsx4AlTU5hrnHgXpO91ijdKvtCyOjnw
         FoC4CKm7TGdFQbKw0D5kGyS51XmHFYM7TWaIgz8alxW9qgc59U1+6vyw1lx42229ZJJn
         z3hqmc6kXpr+pUhmdvahYyCmo8v6TpDE+55gTR684o7TndPAvoIYMG09sheeyxei8byG
         YvDh13ZDU/vjuYyvodgvb16l1fOu9cNt8W6V/CyfmhfPQa2l93RV6zEhlFGZd4LOWtiT
         75944L8bCuqTfQEd04Ln2M7qeZD+c01yK4ZtiEBzJVzkcxwfi/NhdBj+tsUnO/3FQATp
         BAmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rvwOMHyXDNyImD45ns9UEbHv3lzL0MdhHR3ZheOkyjk=;
        b=m2ALDJ9Zvpky8eFlz3WJC8Rq+3IJi9sqSU6I/ZpqJV+ME37P8toU2KWtB6iSALTub2
         fBwHknUW2DlydUDVD4DfVfDIwzzYrfHPF7OXnOGGgEzY2ZffhmuCbqDEpIzsQa8TVQuO
         qz+/P4wYRXiNjqmD9rImmte60tNuYYJmCXDJTecqSEp7suW8WL01NGWwcJj7Sc0IdBFV
         cODB9PqzMnFMx6JsGW9R3LjmAxFhhb+HjJrkNZU3lMfTgjHX2oi7VN29ry9skWGIG5XQ
         gJJeTEYZY0pY9LT9moYpB2iOBzFC4gc2GwIA0xk891VMaFWpBuuWhF1Ko1TH3ewl8uCL
         clkw==
X-Gm-Message-State: AGi0PuY6wvTnFbKYqsZrDPBeEH7vSTvhA0n19uEuKHTv4oj+Tz43s72n
        zfKvxBdjm3KToPBQe/hBO4dek5HkS7w=
X-Google-Smtp-Source: APiQypLWdVIMX05zEFe7fzI3CwEBd5MJ5syuCYCeK1133zCeIWMiUiTUrAFRbLvCCurzvbLt881Xng==
X-Received: by 2002:aa7:943c:: with SMTP id y28mr22599617pfo.171.1587968355594;
        Sun, 26 Apr 2020 23:19:15 -0700 (PDT)
Received: from VincentChen-ThinkPad-T480s.internal.sifive.com (114-34-229-221.HINET-IP.hinet.net. [114.34.229.221])
        by smtp.gmail.com with ESMTPSA id y186sm11256676pfy.66.2020.04.26.23.19.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Apr 2020 23:19:15 -0700 (PDT)
From:   Vincent Chen <vincent.chen@sifive.com>
To:     paul.walmsley@sifive.com, palmer@dabbelt.com
Cc:     linux-riscv@lists.infradead.org,
        Vincent Chen <vincent.chen@sifive.com>, stable@vger.kernel.org
Subject: [PATCH v2] riscv: set max_pfn to the PFN of the last page
Date:   Mon, 27 Apr 2020 14:19:11 +0800
Message-Id: <1587968351-9507-1-git-send-email-vincent.chen@sifive.com>
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
Reviewed-by: Anup Patel <anup@brainfault.ort>
Reviewed-by: Yash Shah <yash.shah@sifive.com>
Tested-by: Yash Shah <yash.shah@sifive.com>

Changes since v1:
1. Add Fixes line and Cc stable kernel
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

