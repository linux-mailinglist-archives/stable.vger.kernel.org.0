Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1959712E94A
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 18:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgABRYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 12:24:19 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:32855 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbgABRYT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 12:24:19 -0500
Received: by mail-wm1-f66.google.com with SMTP id d139so5362821wmd.0;
        Thu, 02 Jan 2020 09:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U9wjKYaQcIlsbYXPy/YsIaQFJ4xpalfLis5wZruxKtw=;
        b=P3gsS/ZAFO4rR24+Almp/rb4kOrZetEaJ7F3U+iU/txuqOLkvrKTmX3vXQOyetQ2sN
         ytCC6zluK1xDIIaQ4NaCeZLVVjXngHX47ubcjDBzEyAU0VHX48lBXTHyVpBXfrcCQPhT
         wYcuc34lFvhjidePvkcjZ1eErTyb+hZI9Wv6/r0OefF0+LQ8JNEZsk6ZG1WY7l98WMfD
         aULsc0wZ375rCRHWpvTS0w724g597YIeyaO1i02bo+n7KBUj4FG8GpIeV10hXByouG6G
         OWPrOdrk+PAzkXQwaFIBpCZMMkbkW0IS1S/ArHY+lcK5T4nUaUFrWJF28YzmhzqWjnr5
         VUmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U9wjKYaQcIlsbYXPy/YsIaQFJ4xpalfLis5wZruxKtw=;
        b=Af4x3TkbjkgT9Tf4Yt66dlaNC5vP9DHdeRmQNN5M48ianW98ZEZBWGA9+JRQ5Xcm9G
         UBHGde18Tf/nJ/tzGqwVsRrdvI+vESM2z9rHUKt/vSLXhSq/hyf6KDKJIiZ3ooqXqfl9
         76RySMfIBY1/NQwR2fnS2aUqsGTlDWQ02/rMkEDseNr4FPoBoR7DEKncADhzbflBnnC3
         cZVhOpZqGRRnW0tOrDj11x7YNkxFI8jRjZf9NMAuQZygFHARSoPgCCHwTKRHcgYpDz1z
         QNNE/y7BHVYBnRrD3iKemf1F0k9sJputoPWWtAWFFJAAPxvX4+8q3Oa3IbjaiNlQXCaf
         AS+Q==
X-Gm-Message-State: APjAAAX69+lWDtzXnquht43N4Y4qEKz3Tla/JTQZGO6A4gq4GDAswDkU
        oPjTszqEsFKvfR9KF83O7CCRlKYi66dRjTGS
X-Google-Smtp-Source: APXvYqxMmMOtyKlgTiqfTvjBJc9+1aotTufCtLN2iSJ+lkIsQeXmdCm7NZR/v45FI2J6XlEBoj6ZDQ==
X-Received: by 2002:a1c:4907:: with SMTP id w7mr14872299wma.106.1577985857314;
        Thu, 02 Jan 2020 09:24:17 -0800 (PST)
Received: from amanieu-laptop.home ([2a01:cb19:8051:6200:3fe7:84:7f3:e713])
        by smtp.gmail.com with ESMTPSA id z21sm9480328wml.5.2020.01.02.09.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 09:24:16 -0800 (PST)
From:   Amanieu d'Antras <amanieu@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Christian Brauner <christian@brauner.io>, stable@vger.kernel.org,
        Amanieu d'Antras <amanieu@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/7] arm64: Move __ARCH_WANT_SYS_CLONE3 definition to uapi headers
Date:   Thu,  2 Jan 2020 18:24:07 +0100
Message-Id: <20200102172413.654385-2-amanieu@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102172413.654385-1-amanieu@gmail.com>
References: <20200102172413.654385-1-amanieu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Previously this was only defined in the internal headers which
resulted in __NR_clone3 not being defined in the user headers.

Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: <stable@vger.kernel.org> # 5.3.x
---
 arch/arm64/include/asm/unistd.h      | 1 -
 arch/arm64/include/uapi/asm/unistd.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index 2629a68b8724..5af82587909e 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -42,7 +42,6 @@
 #endif
 
 #define __ARCH_WANT_SYS_CLONE
-#define __ARCH_WANT_SYS_CLONE3
 
 #ifndef __COMPAT_SYSCALL_NR
 #include <uapi/asm/unistd.h>
diff --git a/arch/arm64/include/uapi/asm/unistd.h b/arch/arm64/include/uapi/asm/unistd.h
index 4703d218663a..f83a70e07df8 100644
--- a/arch/arm64/include/uapi/asm/unistd.h
+++ b/arch/arm64/include/uapi/asm/unistd.h
@@ -19,5 +19,6 @@
 #define __ARCH_WANT_NEW_STAT
 #define __ARCH_WANT_SET_GET_RLIMIT
 #define __ARCH_WANT_TIME32_SYSCALLS
+#define __ARCH_WANT_SYS_CLONE3
 
 #include <asm-generic/unistd.h>
-- 
2.24.1

