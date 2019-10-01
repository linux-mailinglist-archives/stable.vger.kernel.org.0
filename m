Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1518EC3BCE
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390120AbfJAQoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:44:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390115AbfJAQoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:44:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20605205C9;
        Tue,  1 Oct 2019 16:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948294;
        bh=d1cwlKNt2mnCdzZ5RHbHyTPGEAf/7X1xqYU1nu09wHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mdgTY4rP2ezKE+vGVg2GyvuKlbrIzOoyO3YnBT3uKI3o4FZxMTUYSPzuaXXnJJ012
         b/So622WNfDowW255WveaCIcXAvbNZqNofNRreDkUVnPys+hwJGYrp4P8F7+x5ItxW
         LhT3fE4S3ZfQqOSxRORE9EFWjVCR6QLdxdsz9dIQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 24/29] kernel/elfcore.c: include proper prototypes
Date:   Tue,  1 Oct 2019 12:44:18 -0400
Message-Id: <20191001164423.16406-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164423.16406-1-sashal@kernel.org>
References: <20191001164423.16406-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valdis Kletnieks <valdis.kletnieks@vt.edu>

[ Upstream commit 0f74914071ab7e7b78731ed62bf350e3a344e0a5 ]

When building with W=1, gcc properly complains that there's no prototypes:

  CC      kernel/elfcore.o
kernel/elfcore.c:7:17: warning: no previous prototype for 'elf_core_extra_phdrs' [-Wmissing-prototypes]
    7 | Elf_Half __weak elf_core_extra_phdrs(void)
      |                 ^~~~~~~~~~~~~~~~~~~~
kernel/elfcore.c:12:12: warning: no previous prototype for 'elf_core_write_extra_phdrs' [-Wmissing-prototypes]
   12 | int __weak elf_core_write_extra_phdrs(struct coredump_params *cprm, loff_t offset)
      |            ^~~~~~~~~~~~~~~~~~~~~~~~~~
kernel/elfcore.c:17:12: warning: no previous prototype for 'elf_core_write_extra_data' [-Wmissing-prototypes]
   17 | int __weak elf_core_write_extra_data(struct coredump_params *cprm)
      |            ^~~~~~~~~~~~~~~~~~~~~~~~~
kernel/elfcore.c:22:15: warning: no previous prototype for 'elf_core_extra_data_size' [-Wmissing-prototypes]
   22 | size_t __weak elf_core_extra_data_size(void)
      |               ^~~~~~~~~~~~~~~~~~~~~~~~

Provide the include file so gcc is happy, and we don't have potential code drift

Link: http://lkml.kernel.org/r/29875.1565224705@turing-police
Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/elfcore.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/elfcore.c b/kernel/elfcore.c
index fc482c8e0bd88..57fb4dcff4349 100644
--- a/kernel/elfcore.c
+++ b/kernel/elfcore.c
@@ -3,6 +3,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/binfmts.h>
+#include <linux/elfcore.h>
 
 Elf_Half __weak elf_core_extra_phdrs(void)
 {
-- 
2.20.1

