Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E91BC66C82
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfGLMUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:20:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727417AbfGLMUn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:20:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36B05208E4;
        Fri, 12 Jul 2019 12:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934042;
        bh=AOLOOMSEGhe4lIwl7gpI2otGa4PS0CAr/wrU3MXzVpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0TEnV4qhNC66PFecyi49vWfDJXZ6N4k1Gh20Fldd4wmn8usXg/NqlckIAJqrfRPV
         ZUbAGX3uX5au/jeccMHNq44ujZpXY5/rw79s0OrYuXAdCAFnM9I6KgPIdQ9bqQ0XD9
         MYW22dpBHx/yFKSqb7yHg+iuMvAUNzgY9wM8YT6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/91] s390/boot: disable address-of-packed-member warning
Date:   Fri, 12 Jul 2019 14:18:30 +0200
Message-Id: <20190712121622.850914408@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f9364df30420987e77599c4789ec0065c609a507 ]

Get rid of gcc9 warnings like this:

arch/s390/boot/ipl_report.c: In function 'find_bootdata_space':
arch/s390/boot/ipl_report.c:42:26: warning: taking address of packed member of 'struct ipl_rb_components' may result in an unaligned pointer value [-Waddress-of-packed-member]
   42 |  for_each_rb_entry(comp, comps)
      |                          ^~~~~

This is effectively the s390 variant of commit 20c6c1890455
("x86/boot: Disable the address-of-packed-member compiler warning").

Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index ee65185bbc80..e6c2e8925fef 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -24,6 +24,7 @@ KBUILD_CFLAGS_DECOMPRESSOR += -DDISABLE_BRANCH_PROFILING -D__NO_FORTIFY
 KBUILD_CFLAGS_DECOMPRESSOR += -fno-delete-null-pointer-checks -msoft-float
 KBUILD_CFLAGS_DECOMPRESSOR += -fno-asynchronous-unwind-tables
 KBUILD_CFLAGS_DECOMPRESSOR += $(call cc-option,-ffreestanding)
+KBUILD_CFLAGS_DECOMPRESSOR += $(call cc-disable-warning, address-of-packed-member)
 KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_DEBUG_INFO),-g)
 KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_DEBUG_INFO_DWARF4), $(call cc-option, -gdwarf-4,))
 UTS_MACHINE	:= s390x
-- 
2.20.1



