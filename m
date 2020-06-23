Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19553205D80
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389143AbgFWUOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389142AbgFWUN5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:13:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26D5D20E65;
        Tue, 23 Jun 2020 20:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943237;
        bh=e7XNA3NyJvJ+D+dDaW23mx4G+/j4Lrz+d79qZ8wiZwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NwmR9FUqzquk0eFJd9287tEef6rb1O0Z6sfqAnPotXmvb4XzFOa2K1WY282OY9ZxP
         Hfr0kIB/BQEmAh+HhUBK40BlkSIu8rciG5epDY7OwgJd3bfiP0NUpIIvnYcrmF2cYB
         lvYGf2MT1XahLIiaAvoQ+ccM0YfzrsUKihxJVMX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 314/477] modpost: fix -i (--ignore-errors) MAKEFLAGS detection
Date:   Tue, 23 Jun 2020 21:55:11 +0200
Message-Id: <20200623195422.373088978@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 91e6ee581270b8ae970f028b898314d73f16870b ]

$(filter -i,$(MAKEFLAGS)) works only in limited use-cases.

The representation of $(MAKEFLAGS) depends on various factors:
  - GNU Make version (version 3.8x or version 4.x)
  - The presence of other flags like -j

In my experiments, $(MAKEFLAGS) is expanded as follows:

  * GNU Make 3.8x:

    * without -j option:
      --no-print-directory -Rri

    * with -j option:
      --no-print-directory -Rr --jobserver-fds=3,4 -j -i

  * GNU Make 4.x:

    * without -j option:
      irR --no-print-directory

    * with -j option:
      irR -j --jobserver-fds=3,4 --no-print-directory

For GNU Make 4.x, the flags are grouped as 'irR', which does not work.

For the single thread build with GNU Make 3.8x, the flags are grouped
as '-Rri', which does not work either.

To make it work for all cases, do likewise as commit 6f0fa58e4596
("kbuild: simplify silent build (-s) detection").

BTW, since commit ff9b45c55b26 ("kbuild: modpost: read modules.order
instead of $(MODVERDIR)/*.mod"), you also need to pass -k option to
build final *.ko files. 'make -i -k' ignores compile errors in modules,
and build as many remaining *.ko as possible.

Please note this feature is kind of dangerous if other modules depend
on the broken module because the generated modules will lack the correct
module dependency or CRC. Honestly, I am not a big fan of it, but I am
keeping this feature.

Fixes: eed380f3f593 ("modpost: Optionally ignore secondary errors seen if a single module build fails")
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.modpost | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 957eed6a17a54..33aaa572f686b 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -66,7 +66,7 @@ __modpost:
 
 else
 
-MODPOST += $(subst -i,-n,$(filter -i,$(MAKEFLAGS))) -s -T - \
+MODPOST += -s -T - \
 	$(if $(KBUILD_NSDEPS),-d $(MODULES_NSDEPS))
 
 ifeq ($(KBUILD_EXTMOD),)
@@ -82,6 +82,11 @@ include $(if $(wildcard $(KBUILD_EXTMOD)/Kbuild), \
              $(KBUILD_EXTMOD)/Kbuild, $(KBUILD_EXTMOD)/Makefile)
 endif
 
+# 'make -i -k' ignores compile errors, and builds as many modules as possible.
+ifneq ($(findstring i,$(filter-out --%,$(MAKEFLAGS))),)
+MODPOST += -n
+endif
+
 # find all modules listed in modules.order
 modules := $(sort $(shell cat $(MODORDER)))
 
-- 
2.25.1



