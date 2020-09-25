Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E99278847
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgIYMyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729541AbgIYMyQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:54:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63C7F2075E;
        Fri, 25 Sep 2020 12:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038456;
        bh=3A5Z+0wLGFkxkrmaNck/0RAb6jdeZ0pikk3M2UFVIlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIG/CmEERU+Y7zYD7PilzvytSrx19q8QUeZMd7ezbxYa0i8HAl5rbx5a7SKAduDa5
         CmCEsQX3kPAYzWVfDB77vbafVw3/ePX6uO/vLRP1ekTt7Jcglxv9EoEhlXXeJg0Zco
         VuvQDT4jJ+/+sgpj9FSTB2B5fcgbN/rrA50Ak5Ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.19 25/37] kbuild: add OBJSIZE variable for the size tool
Date:   Fri, 25 Sep 2020 14:48:53 +0200
Message-Id: <20200925124724.755101607@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124720.972208530@linuxfoundation.org>
References: <20200925124720.972208530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

commit 7bac98707f65b93bf994ef4e99b1eb9e7dbb9c32 upstream.

Define and export OBJSIZE variable for "size" tool from binutils to be
used in architecture specific Makefiles (naming the variable just "SIZE"
would be too risky). In particular this tool is useful to perform checks
that early boot code is not using bss section (which might have not been
zeroed yet or intersects with initrd or other files boot loader might
have put right after the linux kernel).

Link: http://lkml.kernel.org/r/patch-1.thread-2257a1.git-188f5a3d81d5.your-ad-here.call-01565088755-ext-5120@work.hours
Acked-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
[nd: conflict in exported vars list from not backporting commit
 e83b9f55448a ("kbuild: add ability to generate BTF type info for vmlinux")]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -377,6 +377,7 @@ NM		= $(CROSS_COMPILE)nm
 STRIP		= $(CROSS_COMPILE)strip
 OBJCOPY		= $(CROSS_COMPILE)objcopy
 OBJDUMP		= $(CROSS_COMPILE)objdump
+OBJSIZE		= $(CROSS_COMPILE)size
 LEX		= flex
 YACC		= bison
 AWK		= awk
@@ -433,7 +434,7 @@ GCC_PLUGINS_CFLAGS :=
 CLANG_FLAGS :=
 
 export ARCH SRCARCH CONFIG_SHELL HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE AS LD CC
-export CPP AR NM STRIP OBJCOPY OBJDUMP KBUILD_HOSTLDFLAGS KBUILD_HOSTLDLIBS
+export CPP AR NM STRIP OBJCOPY OBJDUMP OBJSIZE KBUILD_HOSTLDFLAGS KBUILD_HOSTLDLIBS
 export MAKE LEX YACC AWK GENKSYMS INSTALLKERNEL PERL PYTHON PYTHON2 PYTHON3 UTS_MACHINE
 export HOSTCXX KBUILD_HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 


