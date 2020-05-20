Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB751DC256
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 00:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgETWt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 18:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728261AbgETWt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 18:49:56 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12ACC061A0E
        for <stable@vger.kernel.org>; Wed, 20 May 2020 15:49:54 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id z15so453361pjb.0
        for <stable@vger.kernel.org>; Wed, 20 May 2020 15:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:date:message-id:mime-version:content-transfer-encoding:cc
         :from:to;
        bh=My1EMpvoYIRx22llhfpgyqC9YPWXHuLa0tK1BhFN750=;
        b=YEJ7VOe5PKEA6QjC9EMegJ+i/bxXF1ATt/07nspHUqK7DT5rj4pPCou2/ezqb4WsG9
         G19dRahkBbRKQ8FERSyfAyOJRkRboAQFRaDjhCIXFjg59utqMuhSf6h7jQdHy7pm5Sa5
         1f/BZ2kkuGCsUTF1J9Uz35z8QuH+0BDU/DuW+s1BxS3RPOj1K7GqNIi/3Bfa1GRG3JmS
         4ML6xI+GA2HUXqaP/FIsGN/Q8++1S1UA41I3vTQdXtPYdhSeorpSFYtpsKItrscY8MdU
         qUorqizzAfOCF+cZm/VvUXr2xp8zmmMHAPsPDPx7zlmCYW+5W873QrcBJ2H3AyrC11RE
         2Jqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:date:message-id:mime-version
         :content-transfer-encoding:cc:from:to;
        bh=My1EMpvoYIRx22llhfpgyqC9YPWXHuLa0tK1BhFN750=;
        b=JrIUTcASfjBNPs04cjMwlFmaf8rObAAOrv0X2drzNOsavmyINJEEFMaVrI/OWLXVNe
         OOAgZcOlJ0KxNKfV9NKYW8W57xQfDmwkkayPfLAx1FCn6upQc0Dt2boSTtifPh+Nhyq+
         S+GcDfoKNqiDgpgHWEvrmaqYS9gE53vrAmrbOpP9BoApGTUhiTe66kvUZ1MsuHlJkPoF
         mMeZAZboEBHvXEkon9wQQ0tw9yP3xtCwtrW0qiT80U50uKGEJ3+J9IcSBFayTA5E75oy
         leWzTRiTfGfVu9F0W4mRpg4gEa4bV4ONokd6GfvvNM7QR9QKAhPhuvyRxZczlO9BKK5G
         J9ZQ==
X-Gm-Message-State: AOAM532/kydIE6/++1kSOj+DlkRSGnV21F37PF+CJmwPvNqLKABJ4ISp
        emZ2JUNQ3J3vK4YD17ulrD/9mg==
X-Google-Smtp-Source: ABdhPJzrx78zu4nk+mO8oVH7UjcT4FEelNAOwyjCLRm/+J/lv3wNLsV21d6ubtDlLbVlxtpMY2tXKQ==
X-Received: by 2002:a17:90a:9606:: with SMTP id v6mr8060884pjo.20.1590014993958;
        Wed, 20 May 2020 15:49:53 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id i66sm2353489pfe.135.2020.05.20.15.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 15:49:52 -0700 (PDT)
Subject: [PATCH 4.19.y] riscv: set max_pfn to the PFN of the last page
Date:   Wed, 20 May 2020 15:38:44 -0700
Message-Id: <20200520223843.236080-1-palmerdabbelt@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:     Vincent Chen <vincent.chen@sifive.com>, stable@vger.kernel.org,
        Anup Patel <anup@brainfault.org>,
        Yash Shah <yash.shah@sifive.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Chen <vincent.chen@sifive.com>

commit c749bb2d554825e007cbc43b791f54e124dadfce upstream.

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

Cc: stable@vger.kernel.org
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Yash Shah <yash.shah@sifive.com>
Tested-by: Yash Shah <yash.shah@sifive.com>
[Palmer: back-ported to 4.19]
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
---
 arch/riscv/kernel/setup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 9713d4e8c22b..6558617bd2ce 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -19,6 +19,7 @@
  * to the Free Software Foundation, Inc.,
  */
 
+#include <linux/bootmem.h>
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/memblock.h>
@@ -187,6 +188,7 @@ static void __init setup_bootmem(void)
 
 	set_max_mapnr(PFN_DOWN(mem_size));
 	max_low_pfn = PFN_DOWN(memblock_end_of_DRAM());
+	max_pfn = max_low_pfn;
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	setup_initrd();
-- 
2.26.2.761.g0e0b3e54be-goog

