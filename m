Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D40B86251
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 14:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732687AbfHHMyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 08:54:11 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:44309 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732678AbfHHMyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Aug 2019 08:54:11 -0400
Received: by mail-vs1-f66.google.com with SMTP id v129so62949734vsb.11;
        Thu, 08 Aug 2019 05:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=liwJ5aBiFK+WFsWUhJbvVPIczbQXc8RXANMWyv0DLGg=;
        b=kr5FQNqrT2Rg5Alzm8XnB07yLORUhHTijvKBwfOdk8JR/91h0GkAVli3s1oqUsOubx
         Iq4v64T7GbVQoJV9exfZHUZjTRDKtlJ8kXoZPjaJoCbLPa32KzzSppNSbsrU9v0+cFfk
         erqO++npLx/NrD+3IbANNkuHP4Oi3pyzfOMhy6DBO50cX6bl4gSfi8xLnGJxL8qziMSf
         ZalqO03UMfJkLpgUBiPfoXeskZ4jFO3UUgfuQlHIYCNG370o6P8AaKemiZoeicScpKCb
         Uw1P7aBcqzrsFvHBweB1Xm2ze7AwhypMpi9SCvflABonpF8gg2BJO7rTJzqUhd7gZrwc
         Aogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=liwJ5aBiFK+WFsWUhJbvVPIczbQXc8RXANMWyv0DLGg=;
        b=nGLd3E++fx6tOKXJ3XK1lHOM1plpKckNYaKUK/MVvHaHmEitmypJbS4uI+bZhIQqGA
         bzoTk9AExJW265b8oxCenW7WAT+q6aHMPUiX7yfYQMghp8mpOeesXsg74wgpTyEN5/T4
         xQZRY1tL8mCUXHpjgdyyNdLjMFMNcN383y7Ttrv3oYA0/yZBIXmBKcmz4pd3Q4EBUsVa
         TqDxHMkyIFE66cFQm/PX38J8I5bSPD+t/9MacvsM69NWRJ0Je+YAStiFkCMO+WWBN+py
         7R/sCXVNeGlXo8q+9cfnzPnQDlEXCI/I2TLfHByMGJ5kytlwRrVo4QdS855L9hZqzWp2
         LcLw==
X-Gm-Message-State: APjAAAWeN3oIdCk4vJvuJs/rcTzKyoyterl7M+ueddSVwLI/gRrCSpZl
        Dm7fPhbIVXD+ml+MSKuHBsI=
X-Google-Smtp-Source: APXvYqzUT4Jt9+UwYU5M6TPMDU1CqLQBhj07YUvs0GMfXEdfhpZ1/tEoercQdL79kkRiJPS4q41IZw==
X-Received: by 2002:a67:f9c1:: with SMTP id c1mr9615438vsq.22.1565268850029;
        Thu, 08 Aug 2019 05:54:10 -0700 (PDT)
Received: from asus-S451LA.lan ([190.22.21.218])
        by smtp.gmail.com with ESMTPSA id r190sm26961692vkr.8.2019.08.08.05.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2019 05:54:09 -0700 (PDT)
From:   Luis Araneda <luaraneda@gmail.com>
To:     linux@armlinux.org.uk, michal.simek@xilinx.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Luis Araneda <luaraneda@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2 2/2] ARM: zynq: Use memcpy_toio instead of memcpy on smp bring-up
Date:   Thu,  8 Aug 2019 08:52:43 -0400
Message-Id: <20190808125243.31046-3-luaraneda@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808125243.31046-1-luaraneda@gmail.com>
References: <20190808125243.31046-1-luaraneda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This fixes a kernel panic on memcpy when
FORTIFY_SOURCE is enabled.

The initial smp implementation on commit aa7eb2bb4e4a
("arm: zynq: Add smp support")
used memcpy, which worked fine until commit ee333554fed5
("ARM: 8749/1: Kconfig: Add ARCH_HAS_FORTIFY_SOURCE")
enabled overflow checks at runtime, producing a read
overflow panic.

The computed size of memcpy args are:
- p_size (dst): 4294967295 = (size_t) -1
- q_size (src): 1
- size (len): 8

Additionally, the memory is marked as __iomem, so one of
the memcpy_* functions should be used for read/write.

Fixes: aa7eb2bb4e4a ("arm: zynq: Add smp support")
Signed-off-by: Luis Araneda <luaraneda@gmail.com>
Cc: stable@vger.kernel.org
---
Changes:
v1 -> v2:
- Reword commit message to include related commits
- Add Fixes tag
- Add Cc to stable
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

