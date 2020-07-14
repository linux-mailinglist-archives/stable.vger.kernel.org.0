Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1991221E507
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 03:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgGNBVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 21:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgGNBVY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jul 2020 21:21:24 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63C6C061755
        for <stable@vger.kernel.org>; Mon, 13 Jul 2020 18:21:24 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gc9so779347pjb.2
        for <stable@vger.kernel.org>; Mon, 13 Jul 2020 18:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:date:message-id:mime-version:content-transfer-encoding:cc
         :from:to;
        bh=VmDhhDgTu8bitXq1iZew/NUmGohT7Wuy/FvS0rrJGXQ=;
        b=Tdeet8EvRDaTtWDzWgQvTn4KEIgIGAvIZYhUzYee7Pk6WWtSWxASEsDha/qBdBFBn9
         mE/hoaavMp/IyycuDvogQZnqv0Xw99qL8ejowqrdusZCMkHl3IeKnZnH2WpRzz+9vhiB
         TJH8ZVm0b7FvlJXUklAZc90qpub8JPZFgoOgSOvtX8WdI5n9QXngkYC8zy4vPtDDirJb
         yPnYt92eAjWtbgywHQHEbR6rXYiyHQX3wLaZAXOq8dQWvKlGF3lOdYvHgxzS8szlCtFL
         v17XdsrPEq5RWa/uVVR8JdDG28QThJmRXOJWPYYQiJLi97vtp3TzmEqfiIsbm27182fN
         hx+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:date:message-id:mime-version
         :content-transfer-encoding:cc:from:to;
        bh=VmDhhDgTu8bitXq1iZew/NUmGohT7Wuy/FvS0rrJGXQ=;
        b=KRokGiNQeW51Iy5YgucEOdlBOSJgVPDSUJIbFEU2tGkWso7I6uJKfYRklSbrp2BgG3
         ux/q1+f582fpJ7Fdoax7jE/CiAVTZi0SAapy/baSJQ0K72Ysp+FtRXsQA742lgvuH5RM
         lsj7sx+4AEFdEhtrbm6Av76chYO1NNGVxu7aAnXgzIlCkFkODW9v4GKFz3qC62UJjeE6
         FNCOgZYumdNnuRPH353R+Vh040EPgHF1DhbqNbBjsB6+OdLG3wWRxHx0/8iEbJl6XD6Y
         2rvFStp4qXQxwyS/cw55/IIDncekZL06wPBP8qiPrfIq6TbUDqNKRMoiW+ZX5KZEfRxs
         b4Lw==
X-Gm-Message-State: AOAM530HsKRiFH1eVBFICkLmarsXtHZFVJ7wicmOWMl6ye9oDbiNpYqb
        RiOwwzz3KdlJXnabTp9Re3yOiA==
X-Google-Smtp-Source: ABdhPJxWsth4zPvtSfnuToBEPBCUNhjgzKz8npOCTMDqjy+lKxmJJGV2UjSLFLTSrhDjNwy6C7MLpw==
X-Received: by 2002:a17:90a:9bc5:: with SMTP id b5mr2140055pjw.76.1594689683937;
        Mon, 13 Jul 2020 18:21:23 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id lx2sm715779pjb.16.2020.07.13.18.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 18:21:23 -0700 (PDT)
Subject: [PATCH] RISC-V: Double the stack size on rv64
Date:   Mon, 13 Jul 2020 18:19:23 -0700
Message-Id: <20200714011922.138617-1-palmerdabbelt@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:         linux-riscv@lists.infradead.org,
            Palmer Dabbelt <palmerdabbelt@google.com>,
            stable@vger.kernel.org
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     colin.king@canonical.com, schwab@suse.de,
        david.abdurachmanov@gmail.com, dvyukov@google.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This was suggested in the syzkaller thread as a fix for a bunch of issues.  It
seems in line with what other architectures are doing, and while I haven't
personally figured out how to reproduce the issues they seem believable enough
to just change it.

Fixes: 7db91e57a0ac ("RISC-V: Task implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
---
I've put this on fixes as I don't see a patch from anyone on that thread, and
it seems straight-forward enough to just do it.  If there's any issues I'm
happy to listen, otherwise this is going up later this week.
---
 arch/riscv/include/asm/thread_info.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/include/asm/thread_info.h b/arch/riscv/include/asm/thread_info.h
index 1dd12a0cbb2b..2026076b1d30 100644
--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -12,7 +12,11 @@
 #include <linux/const.h>
 
 /* thread information allocation */
+#if defined(CONFIG_32BIT)
 #define THREAD_SIZE_ORDER	(1)
+#elif defined(CONFIG_64BIT)
+#define THREAD_SIZE_ORDER   (2)
+#endif
 #define THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)
 
 #ifndef __ASSEMBLY__
-- 
2.27.0.389.gc38d7665816-goog

