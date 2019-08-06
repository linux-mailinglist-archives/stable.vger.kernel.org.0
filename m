Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 109CF829E8
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 05:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbfHFDIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 23:08:12 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:43829 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731487AbfHFDIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 23:08:11 -0400
Received: by mail-ua1-f67.google.com with SMTP id o2so33107376uae.10;
        Mon, 05 Aug 2019 20:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bs0lmDNxa1aAKQKN0MVTNnd8nYHoFzSTA2dziDK99ZE=;
        b=uvjciLg/2rMNF9ijkXRPobQpKgmfo/ydHMGgu4GxJKxFzJBwyrpN+RChv7QwZtutE8
         m5utMFeOfsgoMxA4fQI4Fnr/Cl3KkzU3WWz5UOFWPtZ+UkUM3yib9prf5EOBprUE5Y8M
         ixjEoe47akhAGY8Smy6lnzseKdVIyykZS4daWDvbtGw8f8sR8Vl6jJLwFq3EgRA0Is0d
         g0Qp0u8cY2uoPlS+Nd22AG3WdJKVq9JZEfWDYnMpo9y2RquGYd8/Db16dc+7QOr2v0Ec
         JcU/CWRn38fT7dHWq3K24h/KCRHLKwbQtmMCNwAe6fj5TKgEJz8cI7/elvVnMwLRugqX
         KosQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bs0lmDNxa1aAKQKN0MVTNnd8nYHoFzSTA2dziDK99ZE=;
        b=K+mPNHcU6s5NDcjpG5VLzgCz4N5cp4pGVsoFAZ8I4q9zumJjkrSy18QtuIT4kCMGt+
         fzL0S850WS3SxPhlGD48UrjpJt1fXYvYJIHuZbo6jE9Hjh1ArpuaRW2ZY3zhpyO+6YF4
         tg72e3BrgIAPUKvNx0Vt9WrtgGNk8/+jlrLZLmiiX+mW/NMiOxW640/Cy30bFocaEnMM
         1erZ6AAe0Rl7u0Q/ZnD5PlQYK+POd+w83Qpj1ywY99yeO6fdPepMtmeucEwgcZdEK5H1
         jcwfVho536TOWc9XlpxZjTyHYSKm/Z4pacveE4qyS/4s+JzhHfsp61au/hzafNk60wyH
         cPWg==
X-Gm-Message-State: APjAAAUSAzdgZXtu4ESPQNQLrc9ILtHusqthg68S3a/JRti08cHnBU+V
        5+689NWE3HcKhagPvNJwD+JysX0mX3E=
X-Google-Smtp-Source: APXvYqz1jj9chZIr0Yf4E395LCJUYFXV1bMRm3+VXYW8Siypet9RS1vk/lBrCB7r6RHni4579BUOnA==
X-Received: by 2002:ab0:a1:: with SMTP id 30mr779825uaj.29.1565060890557;
        Mon, 05 Aug 2019 20:08:10 -0700 (PDT)
Received: from asus-S451LA.lan ([190.22.46.249])
        by smtp.gmail.com with ESMTPSA id v190sm22683156vkd.37.2019.08.05.20.08.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 20:08:10 -0700 (PDT)
From:   Luis Araneda <luaraneda@gmail.com>
To:     linux@armlinux.org.uk, michal.simek@xilinx.com
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Luis Araneda <luaraneda@gmail.com>
Subject: [PATCH 2/2] ARM: zynq: Use memcpy_toio instead of memcpy on smp bring-up
Date:   Mon,  5 Aug 2019 23:07:18 -0400
Message-Id: <20190806030718.29048-3-luaraneda@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190806030718.29048-1-luaraneda@gmail.com>
References: <20190806030718.29048-1-luaraneda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This fixes a kernel panic (read overflow) on memcpy when
FORTIFY_SOURCE is enabled.

The computed size of memcpy args are:
- p_size (dst): 4294967295 = (size_t) -1
- q_size (src): 1
- size (len): 8

Additionally, the memory is marked as __iomem, so one of
the memcpy_* functions should be used for read/write

Signed-off-by: Luis Araneda <luaraneda@gmail.com>
---
 arch/arm/mach-zynq/platsmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
index 38728badabd4..a10085be9073 100644
--- a/arch/arm/mach-zynq/platsmp.c
+++ b/arch/arm/mach-zynq/platsmp.c
@@ -57,7 +57,7 @@ int zynq_cpun_start(u32 address, int cpu)
 			* 0x4: Jump by mov instruction
 			* 0x8: Jumping address
 			*/
-			memcpy((__force void *)zero, &zynq_secondary_trampoline,
+			memcpy_toio(zero, &zynq_secondary_trampoline,
 							trampoline_size);
 			writel(address, zero + trampoline_size);
 
-- 
2.22.0

