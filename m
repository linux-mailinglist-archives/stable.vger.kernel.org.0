Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDFDD420BB0
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 14:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbhJDM7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 08:59:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233912AbhJDM6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 08:58:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16AAE61391;
        Mon,  4 Oct 2021 12:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352180;
        bh=f3PYHvSS/h9aH3/PFO+upfkycodzjBQ4iBEagWkIBiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ex/9S6xytz5V6QzyGsl1BpAy0SjVQpL/qRbkhxa+n6NzyqnvdM5f9q1WMasSV/kFj
         9+H69e00txbaPps4HuENMAj6MQ1IjXi2dx+a2Uq+yLYQjqZeGKq8XgKCITcFn9yHfc
         fk0Fnc6SSOaRdIwSZSXN1UkfXHNLLmvypaXwOA58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 21/57] compiler.h: Introduce absolute_pointer macro
Date:   Mon,  4 Oct 2021 14:52:05 +0200
Message-Id: <20211004125029.606007511@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125028.940212411@linuxfoundation.org>
References: <20211004125028.940212411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit f6b5f1a56987de837f8e25cd560847106b8632a8 ]

absolute_pointer() disassociates a pointer from its originating symbol
type and context. Use it to prevent compiler warnings/errors such as

  drivers/net/ethernet/i825xx/82596.c: In function 'i82596_probe':
  arch/m68k/include/asm/string.h:72:25: error:
	'__builtin_memcpy' reading 6 bytes from a region of size 0 [-Werror=stringop-overread]

Such warnings may be reported by gcc 11.x for string and memory
operations on fixed addresses.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 824b1b97f989..10937279b152 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -233,6 +233,8 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
     (typeof(ptr)) (__ptr + (off)); })
 #endif
 
+#define absolute_pointer(val)	RELOC_HIDE((void *)(val), 0)
+
 #ifndef OPTIMIZER_HIDE_VAR
 #define OPTIMIZER_HIDE_VAR(var) barrier()
 #endif
-- 
2.33.0



