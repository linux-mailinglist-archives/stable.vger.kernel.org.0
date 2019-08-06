Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC6FF829E6
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 05:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbfHFDIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 23:08:10 -0400
Received: from mail-vk1-f196.google.com ([209.85.221.196]:43982 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729334AbfHFDIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 23:08:10 -0400
Received: by mail-vk1-f196.google.com with SMTP id b200so17056442vkf.10;
        Mon, 05 Aug 2019 20:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+qUM9EyfPNq2M7gA+PSnVqo/pTJqSgIuBxaIciINGpo=;
        b=FPk5zpwQyjWszkhHLErDdhfgFxvQvRNJZz6lyLYMy3j0yAPZJ01R4a4qB3d/ifzsno
         FRM/Tqi9kSnf3oCMNFuWSFeh3wjqMjX0MzGHj85aCmYp4YxOjxrqPakpy90IMQjUP3VR
         vrqqmxHM3oP7+tXY06MPUIILvgLDXAZtmHL+W6rgGP3AeVRUXii91s/RkBXpUlOh1drO
         iA9oXI+0V1P7UKfAA41OZC6awsy1pk7nvVvWikrMbsuTh1vkbx26l98h/ievsCzPQhR8
         cfGULkT+9/9CwJtlGBFux0Fd5Qr9Hg9+Fi1PfphhbKtezm/TTUBuU6LUrX62I4I5X0ae
         ZJZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+qUM9EyfPNq2M7gA+PSnVqo/pTJqSgIuBxaIciINGpo=;
        b=Ir1S2QATxqNuWlo6Izi9j2b2TXlo2VoQfwjvzc6lgY9cVFmGRTK5hUahQfeDBBpfYD
         rtbPmA+H9D/lGUg6S6ozo3nr62OjRMndqe09LpwkezzEqaGkjf3FjIBMi0PEvWoFrkS5
         Q90XdWP2XuUuRQGHDhnU9KzQ+By0wVOEuWbMv/Mh4b2W/6fZ0cgjrUQijhFhKOhFu2cT
         l8Igs5H0xmvwG4c6PB4qo7OPQd6prqW5llUwxmO5JNEtdBifW8iVQGipnLT56O972NTB
         qOO1UoCHtlPUDVyffgIa6GXltVRXZfsPeimdQF1omlKilYYhlCuXPWdQ6jyJj7Xl7E2j
         d9Lg==
X-Gm-Message-State: APjAAAX3do/79NF14mBOcaez+PbZnfHglBuk3eSEBAFXyNzp+N0TXmLc
        VO8d4lU4eOreJBebMx4MBO4=
X-Google-Smtp-Source: APXvYqzpZjOH4z8+B+VY6CHxesR3IrgEInsXZojfemjLqREXXsCAimavEtIWjbL/xdGCLL56YwkGEw==
X-Received: by 2002:a1f:d1c3:: with SMTP id i186mr357136vkg.26.1565060888692;
        Mon, 05 Aug 2019 20:08:08 -0700 (PDT)
Received: from asus-S451LA.lan ([190.22.46.249])
        by smtp.gmail.com with ESMTPSA id v190sm22683156vkd.37.2019.08.05.20.08.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 20:08:08 -0700 (PDT)
From:   Luis Araneda <luaraneda@gmail.com>
To:     linux@armlinux.org.uk, michal.simek@xilinx.com
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Luis Araneda <luaraneda@gmail.com>
Subject: [PATCH 1/2] ARM: zynq: support smp in thumb mode
Date:   Mon,  5 Aug 2019 23:07:17 -0400
Message-Id: <20190806030718.29048-2-luaraneda@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190806030718.29048-1-luaraneda@gmail.com>
References: <20190806030718.29048-1-luaraneda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add .arm directive to headsmp.S to ensure that the
CPU starts in 32-bit ARM mode and the correct code
size is copied on smp bring-up

Additionally, start secondary CPUs on secondary_startup_arm
to automatically switch from ARM to thumb on a thumb kernel

Suggested-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Luis Araneda <luaraneda@gmail.com>
---
 arch/arm/mach-zynq/headsmp.S | 2 ++
 arch/arm/mach-zynq/platsmp.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-zynq/headsmp.S b/arch/arm/mach-zynq/headsmp.S
index ab85003cf9ad..3449e0d1f990 100644
--- a/arch/arm/mach-zynq/headsmp.S
+++ b/arch/arm/mach-zynq/headsmp.S
@@ -7,6 +7,8 @@
 #include <linux/init.h>
 #include <asm/assembler.h>
 
+	.arm
+
 ENTRY(zynq_secondary_trampoline)
 ARM_BE8(setend	be)				@ ensure we are in BE8 mode
 	ldr	r0, zynq_secondary_trampoline_jump
diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
index a7cfe07156f4..38728badabd4 100644
--- a/arch/arm/mach-zynq/platsmp.c
+++ b/arch/arm/mach-zynq/platsmp.c
@@ -81,7 +81,7 @@ EXPORT_SYMBOL(zynq_cpun_start);
 
 static int zynq_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
-	return zynq_cpun_start(__pa_symbol(secondary_startup), cpu);
+	return zynq_cpun_start(__pa_symbol(secondary_startup_arm), cpu);
 }
 
 /*
-- 
2.22.0

