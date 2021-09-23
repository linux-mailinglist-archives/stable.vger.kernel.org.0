Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9CE4156F4
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239433AbhIWDpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:45:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239543AbhIWDnA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:43:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 283BA6124A;
        Thu, 23 Sep 2021 03:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368434;
        bh=EOjRsXndgEJCGgH/hf63qiusVL92jYSBOV2Enjo0w8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVkwkW6k8cwdu5u4ZqMOyWtSR7rD9mMgFumVYPIxllT5RuMHdyIkT+om7+wSTY5eu
         nMpOvyns2RTzb4UkdYmDkai14qRCVGX+azjU9Xg6+TZkY4K+iKTEhaAgasXHoDhzhE
         o3MAXbumwMz3s/rQ2DK4AuR+LNX7FX5Md5Dh6iIdowMOXu1/WYMmTPXVOCz7G4QEOc
         Dhd0Gqg+y9qcXdo9LsoWhgorHzD0kCELZWs6KC22pQjy67gpMcA3v/zIbSyo4r8cFU
         1NxjCrxqiI0/2O5rEwDgi0Rif29DKPk7t0Zqyp/SgGkEIY4TadWDkzW289BQN1vCLz
         C4xbk9+ZFo+Aw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>, luc.vanoostenryck@gmail.com,
        linux-sparse@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 03/11] compiler.h: Introduce absolute_pointer macro
Date:   Wed, 22 Sep 2021 23:40:19 -0400
Message-Id: <20210923034028.1421876-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923034028.1421876-1-sashal@kernel.org>
References: <20210923034028.1421876-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
2.30.2

