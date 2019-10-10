Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D230AD2464
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387901AbfJJIob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:44:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388949AbfJJIob (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:44:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2F4F21929;
        Thu, 10 Oct 2019 08:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697070;
        bh=d1cwlKNt2mnCdzZ5RHbHyTPGEAf/7X1xqYU1nu09wHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltCFWw71eab1LvbsQzZyYEfGa0srBinnJ1Y2owDbH4a3v74i7wnok+4TVFmUJcbPJ
         SFbtgDPjcwM+XtmIOXZaji8jwboU+c3j2w1YUFuNhKqI95fizd6XzSj0BGS0GFgvUf
         +qoX4yCBoLKd8F9ce8FuUztOLufCSEDh/Onva80I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 126/148] kernel/elfcore.c: include proper prototypes
Date:   Thu, 10 Oct 2019 10:36:27 +0200
Message-Id: <20191010083618.678356038@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



