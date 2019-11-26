Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAB410A4FC
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 21:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfKZUBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 15:01:21 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36625 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfKZUBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 15:01:21 -0500
Received: by mail-lj1-f195.google.com with SMTP id k15so21713037lja.3
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 12:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9gYplPhtVE/YGLO3x1smraYGKvZdNPRdzDgfUGwplws=;
        b=GIRldqEdiwGN3YNe6c76Ggzly2TLHRFCWdEE02G+zF+8N2KcF8j+jZ7WokzK3KR1jo
         /yPaNkdQ0wHsOvzOfc/G7e+o6IifetbIk+4AiYUdw6r/FbJKR1y0htKWfJQiYuSzTiI6
         DosXBqB1wRDvH6FY5kC4YS7TjMZaLBpwXex/yrgMIpL8f13YiVi2lUSE3rs1r2p5urn+
         yxOGgZAJ+vHP4NVbQfWv14U0yXnPuqRtpRAwPApmMtb1cviCfSs/aUuO4+zCgIT8ecPB
         WttE4aMeG8NTlccrGQsIbB9JmiVoRfRr8gLGSKByL7PSvln/J5CBgFA0nBzYm3II9pyv
         l+Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9gYplPhtVE/YGLO3x1smraYGKvZdNPRdzDgfUGwplws=;
        b=EzrZLDRXcN+8iUGrSn1s2tHCldwBCKj8DwTOqCUmvYUteRJNKo9qbtU2UN0SUvEqka
         yQChjBIKuQJNZr9dATtgbNNNvUJnHU5xdF6Q38tt5lFl72+ai7osMD+zU+6WHbLIIPdc
         EkQz71lm5zzjW66xj338HsZRQdB9bYF9dSupnSx1PRJOQ9T/uGk0+4B2GX31tvBDXNeN
         52X+1h68t/zoL73FK4+sySrS80orSFaiygp4sfvmP5qLh13YwOtBjdSsnW7Yalnr2j/r
         nkRpEwKgJzkclar9oqC7GVGzUgXBUneF4UB2syEtrCqvC7zTYEOetc7YIWxdrBzYgEiy
         McAg==
X-Gm-Message-State: APjAAAXtEj2P5JdM+bdlNFIlnQjYjZslcZ9RVLlrmKeOlgDL55/hPnpm
        Jyx7GUOCHGcRHiRgPfr2leDdkyf5brI=
X-Google-Smtp-Source: APXvYqxMydKAw0SnQ/rYZD0FFMTLmbLErH0qXFuFIDX2swa/M1Ot0o1BirTQP/nA/jNMfD5RfERQkw==
X-Received: by 2002:a2e:81c1:: with SMTP id s1mr27477310ljg.83.1574798479363;
        Tue, 26 Nov 2019 12:01:19 -0800 (PST)
Received: from octofox.cadence.com (jcmvbkbc-1-pt.tunnel.tserv24.sto1.ipv6.he.net. [2001:470:27:1fa::2])
        by smtp.gmail.com with ESMTPSA id g11sm5767129lfb.94.2019.11.26.12.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 12:01:18 -0800 (PST)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] xtensa: fix syscall_set_return_value
Date:   Tue, 26 Nov 2019 12:01:07 -0800
Message-Id: <20191126200107.13008-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

syscall return value is in the register a2, not a0.

Cc: stable@vger.kernel.org # v5.0+
Fixes: 9f24f3c1067c ("xtensa: implement tracehook functions and enable HAVE_ARCH_TRACEHOOK")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/include/asm/syscall.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/xtensa/include/asm/syscall.h b/arch/xtensa/include/asm/syscall.h
index 359ab40e935a..c90fb944f9d8 100644
--- a/arch/xtensa/include/asm/syscall.h
+++ b/arch/xtensa/include/asm/syscall.h
@@ -51,7 +51,7 @@ static inline void syscall_set_return_value(struct task_struct *task,
 					    struct pt_regs *regs,
 					    int error, long val)
 {
-	regs->areg[0] = (long) error ? error : val;
+	regs->areg[2] = (long) error ? error : val;
 }
 
 #define SYSCALL_MAX_ARGS 6
-- 
2.20.1

