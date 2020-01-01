Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F31712DFD4
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 18:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbgAAR5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 12:57:13 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46880 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727237AbgAAR5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 12:57:13 -0500
Received: by mail-pg1-f196.google.com with SMTP id z124so20815555pgb.13;
        Wed, 01 Jan 2020 09:57:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bxdqVdO/ZL+zRgdpxmrLZZskW1wmCQ5oo+9ANDQKquo=;
        b=RkfcffGvZM4B1Du++mQh+XQ87vFJ5sNSmkOCxH7yvIDeKeuzT85InDVScXwOExfHQc
         qj132xME9AzW+0fCu8giVjSHMCd0MJSqVS+Q+pDFVXlWUdSuOQHAvQvs44J+Sx8toSXN
         j/gvYkOSHN2w2HmEiWxjSeQb9BfU7TeyRt6rgrZZKCbIwoZcoA+jIPcweir7m3AaHKD3
         U8071/qrJf6cLT4d+WS/65ajx4DzNb7EkevaxXFwQJ74vLJVW85//Hlu9/1YD+X9QJD9
         U7ba1zu6Oyn0ORDSRqFCSV6ih06ld2P6Yl0EiVPUeGNbQ30Za64Lq0MGkJUrvlYn1Z1/
         ylvA==
X-Gm-Message-State: APjAAAUp5tH9yVi7PFDNlvItcCM+8dJusjEytseHbBa5f5xkNQjZxU1F
        XKrpgjpFKZJgO+x2H8JdWnZl2Gt5Cz+fQw==
X-Google-Smtp-Source: APXvYqyZucI4PVpaoOQEHydKhO2Srq7KWwqL8s2UhtF95GurMFNMaadG0zKfGjvTzAoizEICcCCFEQ==
X-Received: by 2002:a65:48cb:: with SMTP id o11mr85941450pgs.313.1577901431976;
        Wed, 01 Jan 2020 09:57:11 -0800 (PST)
Received: from localhost ([2601:646:8a00:9810:5af3:56d9:f882:39d4])
        by smtp.gmail.com with ESMTPSA id o19sm8712565pjr.2.2020.01.01.09.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2020 09:57:11 -0800 (PST)
From:   Paul Burton <paulburton@kernel.org>
To:     linux-mips@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Christian Brauner <christian.brauner@canonical.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        stable@vger.kernel.org
Subject: [PATCH] MIPS: Don't declare __current_thread_info globally
Date:   Wed,  1 Jan 2020 09:59:16 -0800
Message-Id: <20200101175916.558284-1-paulburton@kernel.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Declaring __current_thread_info as a global register variable has the
effect of preventing GCC from saving & restoring its value in cases
where the ABI would typically do so.

To quote GCC documentation:

> If the register is a call-saved register, call ABI is affected: the
> register will not be restored in function epilogue sequences after the
> variable has been assigned. Therefore, functions cannot safely return
> to callers that assume standard ABI.

When our position independent VDSO is built for the n32 or n64 ABIs all
functions it exposes should be preserving the value of $gp/$28 for their
caller, but in the presence of the __current_thread_info global register
variable GCC stops doing so & simply clobbers $gp/$28 when calculating
the address of the GOT.

In cases where the VDSO returns success this problem will typically be
masked by the caller in libc returning & restoring $gp/$28 itself, but
that is by no means guaranteed. In cases where the VDSO returns an error
libc will typically contain a fallback path which will now fail
(typically with a bad memory access) if it attempts anything which
relies upon the value of $gp/$28 - eg. accessing anything via the GOT.

Fix this by moving the declaration of __current_thread_info inside the
current_thread_info() function, demoting it from global register
variable to local register variable & avoiding inadvertently creating a
non-standard calling ABI for the VDSO.

Signed-off-by: Paul Burton <paulburton@kernel.org>
Reported-by: "Jason A. Donenfeld" <Jason@zx2c4.com>
Fixes: ebb5e78cc634 ("MIPS: Initial implementation of a VDSO")
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Brauner <christian.brauner@canonical.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org> # v4.4+
---
 arch/mips/include/asm/thread_info.h | 4 ++--
 arch/mips/kernel/relocate.c         | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
index 4993db40482c..aceefc3f9a1a 100644
--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -50,10 +50,10 @@ struct thread_info {
 }
 
 /* How to get the thread information struct from C.  */
-register struct thread_info *__current_thread_info __asm__("$28");
-
 static inline struct thread_info *current_thread_info(void)
 {
+	register struct thread_info *__current_thread_info __asm__("$28");
+
 	return __current_thread_info;
 }
 
diff --git a/arch/mips/kernel/relocate.c b/arch/mips/kernel/relocate.c
index 3d80a51256de..c9afdc39b003 100644
--- a/arch/mips/kernel/relocate.c
+++ b/arch/mips/kernel/relocate.c
@@ -296,6 +296,7 @@ static inline int __init relocation_addr_valid(void *loc_new)
 
 void *__init relocate_kernel(void)
 {
+	register struct thread_info *__current_thread_info __asm__("$28");
 	void *loc_new;
 	unsigned long kernel_length;
 	unsigned long bss_length;
-- 
2.24.0

