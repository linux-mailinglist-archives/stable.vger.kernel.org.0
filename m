Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB26B24BE50
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730539AbgHTNXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:23:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728089AbgHTJeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:34:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C970722BEF;
        Thu, 20 Aug 2020 09:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916048;
        bh=vlgI/GcQFDEuwsf31liFVaSoA4yqFdptOoUDqNhNW0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nf10lQGBL4dLRPyrtQm/A28Lf8mkuYwfWH3bN8RRC7Qlcyp6WbtVdXFePF5Mq2Jeo
         rkqLn/7JZof9yBnOGuvqDz/xHU01+MM9XfgE3I1ndErsv8qzepz3zGU/KhH4PdG04N
         iu3zf7fQtUAgGfBEA6SgyGjTV6mP8+Sq9FVXFLUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Gregory Herrero <gregory.herrero@oracle.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 196/232] recordmcount: Fix build failure on non arm64
Date:   Thu, 20 Aug 2020 11:20:47 +0200
Message-Id: <20200820091622.284965844@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 3df14264ad9930733a8166e5bd0eccc1727564bb ]

Commit ea0eada45632 leads to the following build failure on powerpc:

  HOSTCC  scripts/recordmcount
scripts/recordmcount.c: In function 'arm64_is_fake_mcount':
scripts/recordmcount.c:440: error: 'R_AARCH64_CALL26' undeclared (first use in this function)
scripts/recordmcount.c:440: error: (Each undeclared identifier is reported only once
scripts/recordmcount.c:440: error: for each function it appears in.)
make[2]: *** [scripts/recordmcount] Error 1

Make sure R_AARCH64_CALL26 is always defined.

Fixes: ea0eada45632 ("recordmcount: only record relocation of type R_AARCH64_CALL26 on arm64.")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Acked-by: Gregory Herrero <gregory.herrero@oracle.com>
Cc: Gregory Herrero <gregory.herrero@oracle.com>
Link: https://lore.kernel.org/r/5ca1be21fa6ebf73203b45fd9aadd2bafb5e6b15.1597049145.git.christophe.leroy@csgroup.eu
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/recordmcount.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index e59022b3f1254..b9c2ee7ab43fa 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -42,6 +42,8 @@
 #define R_ARM_THM_CALL		10
 #define R_ARM_CALL		28
 
+#define R_AARCH64_CALL26	283
+
 static int fd_map;	/* File descriptor for file being modified. */
 static int mmap_failed; /* Boolean flag. */
 static char gpfx;	/* prefix for global symbol name (sometimes '_') */
-- 
2.25.1



