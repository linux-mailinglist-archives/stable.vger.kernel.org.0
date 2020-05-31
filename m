Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546171E9673
	for <lists+stable@lfdr.de>; Sun, 31 May 2020 11:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgEaJFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 May 2020 05:05:42 -0400
Received: from condef-01.nifty.com ([202.248.20.66]:36832 "EHLO
        condef-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbgEaJFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 May 2020 05:05:42 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 May 2020 05:05:40 EDT
Received: from conuserg-11.nifty.com ([10.126.8.74])by condef-01.nifty.com with ESMTP id 04V8lSTV027271
        for <stable@vger.kernel.org>; Sun, 31 May 2020 17:47:28 +0900
Received: from oscar.flets-west.jp (softbank126090202047.bbtec.net [126.90.202.47]) (authenticated)
        by conuserg-11.nifty.com with ESMTP id 04V8l9cJ006559;
        Sun, 31 May 2020 17:47:09 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-11.nifty.com 04V8l9cJ006559
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1590914829;
        bh=HDhRo4kqOH4ocemAQ9KPEM8Ho6xTL2L0HechK3GQK0k=;
        h=From:To:Cc:Subject:Date:From;
        b=EjdPXK2fyvmZg0CNOXktJh+hdjF9A4MugD94NHc2/00MGEvs9S2CuURCgByrxM5Fd
         hte8n92AhbHArD95gJ0EBzncqaFzloY8Lwf6cYjHqPnTKKQ6u4/yHlnRu/kb3MmmbP
         0UJz5iz+vjiawPL6mx+MYWKB9pPBVaRpN6jN8IuDVatDPHGMVURC0OuZpSoE6mTJu/
         1PcWEhD/BiwNDoEHuQoK4+e49DuYTxShSYJ04EObYLq9aWYRBHA7tVVmodcBw+GS6l
         DB+JaVZACmxNINmLbvLw4XRcPNRsLy7X9BYRA4H4zlpG7lYWsSMhPnhk7sClVFvGjt
         gsTU5oH3hsORw==
X-Nifty-SrcIP: [126.90.202.47]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     linux-kbuild@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: force to build vmlinux if CONFIG_MODVERSION=y
Date:   Sun, 31 May 2020 17:47:06 +0900
Message-Id: <20200531084707.1238909-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This code does not work as stated in the comment.

$(CONFIG_MODVERSIONS) is always empty because it is expanded before
include/config/auto.conf is included. Hence, 'make modules' with
CONFIG_MODVERSION=y cannot record the version CRCs.

This has been broken since 2003, commit ("kbuild: Enable modules to be
build using the "make dir/" syntax"). [1]

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/history/history.git/commit/?id=15c6240cdc44bbeef3c4797ec860f9765ef4f1a7
Cc: linux-stable <stable@vger.kernel.org> # v2.5.71+
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 Makefile | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 2df903429d31..b856f84e28c9 100644
--- a/Makefile
+++ b/Makefile
@@ -619,12 +619,8 @@ KBUILD_MODULES :=
 KBUILD_BUILTIN := 1
 
 # If we have only "make modules", don't compile built-in objects.
-# When we're building modules with modversions, we need to consider
-# the built-in objects during the descend as well, in order to
-# make sure the checksums are up to date before we record them.
-
 ifeq ($(MAKECMDGOALS),modules)
-  KBUILD_BUILTIN := $(if $(CONFIG_MODVERSIONS),1)
+  KBUILD_BUILTIN :=
 endif
 
 # If we have "make <whatever> modules", compile modules
@@ -1337,6 +1333,13 @@ ifdef CONFIG_MODULES
 
 all: modules
 
+# When we're building modules with modversions, we need to consider
+# the built-in objects during the descend as well, in order to
+# make sure the checksums are up to date before we record them.
+ifdef CONFIG_MODVERSIONS
+  KBUILD_BUILTIN := 1
+endif
+
 # Build modules
 #
 # A module can be listed more than once in obj-m resulting in
-- 
2.25.1

