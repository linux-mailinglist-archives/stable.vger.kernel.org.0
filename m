Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E8132751F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 00:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhB1XLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 18:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbhB1XK7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 18:10:59 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD1EC06174A;
        Sun, 28 Feb 2021 15:10:19 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id bm21so6032280ejb.4;
        Sun, 28 Feb 2021 15:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wdxemGBy4u4SaMjaDQDpqTi0AcRXyjzG6DEYFc4fJWY=;
        b=TC5ZxJiYcJnAR6DNazwFrjmw0QYBNQsYxt7nvbT0zVx744R7RKUCmxNFiptYCl8nUk
         nycT3ydDClpQQTgqFI0TlxIpuNA+XQ2GPzHBQ0uqwdgzytp+4948VyiR0Bhe1/BhmDbu
         NLnizk1AnqIRKi6K9KktXSDSUzzQ7DZ40oopV+26aVrMp6NTYxApW0GRskZ9a2uSjyFN
         uc3YO4Dq6zYi59Ljt8cVtJgQi/9Bc6Ckl7g41isKlyobXr0ojp0cT6EtxpeK6F2cbNBL
         gWGGtY1rGBLuIiaB35bn7s6EChJYw1I8JnSpDdDKDJ8+Uo6pz2lWc/7WbKg6odXfWTjt
         rt0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wdxemGBy4u4SaMjaDQDpqTi0AcRXyjzG6DEYFc4fJWY=;
        b=l/McWCfhz84AL8Jy6QQC7rkUOK8e9ThJYp1hluA0mpZoFOv4Gy4wE/zaS9gSQOlrpt
         e3TLadfYjdDG8NP2f3sRg8/btVDxhVl53IoMTgjRrCmRF2E99a+3xRvttFd+FGYiB6U+
         iFhM74Q7I5bYaNy+FLthWODtUmU53e6Ym0ZoHNKsTqYIGbS9U1ZJ+SawptnW3W0IOqkF
         hM6QSq/PBztqiJoR5j2zX/26N/MWhDAGo7a1mZLomeuNROHtXShT7qTTehI4PmO2nk/3
         ilAysVEcCZTstpK+BP8hcgaAbySglJXMWcMFxKfUJvnuIc7Gry0wM63Y1tXzB0lcd/oo
         IO0Q==
X-Gm-Message-State: AOAM532mz1RCA/NjDimkUz1AVRwbTx7Midph/ddde0VpSDCBCsYD378S
        lLuJ/a3z36Tpppg/H3wogmZcAXE1CZA=
X-Google-Smtp-Source: ABdhPJwS0btJKYVpA+Ovf535h7FGg54S2ASq/ImH7vMDej4WPkIOnOeRfSY+/yYNhtBIM4KTwxPBKA==
X-Received: by 2002:a17:906:3444:: with SMTP id d4mr13200598ejb.410.1614553817920;
        Sun, 28 Feb 2021 15:10:17 -0800 (PST)
Received: from Ansuel-xps.localdomain (host-79-26-248-106.retail.telecomitalia.it. [79.26.248.106])
        by smtp.googlemail.com with ESMTPSA id r24sm6048132edw.11.2021.02.28.15.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 15:10:17 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, stable@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] arm: Enlarge IO_SPACE_LIMIT needed for some SoC
Date:   Sun, 28 Feb 2021 15:44:04 +0100
Message-Id: <20210228144405.24979-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ipq8064 SoC requires larger IO_SPACE_LIMIT or second and third pci port
fails to register the IO addresses and connected device doesn't work.

Cc: <stable@vger.kernel.org> # 4.9+
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 arch/arm/include/asm/io.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index fc748122f1e0..6f3e89f08bd8 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -197,7 +197,7 @@ void __iomem *pci_remap_cfgspace(resource_size_t res_cookie, size_t size);
 #ifdef CONFIG_NEED_MACH_IO_H
 #include <mach/io.h>
 #elif defined(CONFIG_PCI)
-#define IO_SPACE_LIMIT	((resource_size_t)0xfffff)
+#define IO_SPACE_LIMIT	((resource_size_t)0xffffff)
 #define __io(a)		__typesafe_io(PCI_IO_VIRT_BASE + ((a) & IO_SPACE_LIMIT))
 #else
 #define __io(a)		__typesafe_io((a) & IO_SPACE_LIMIT)
-- 
2.30.0

