Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9B2A11DDA
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfEBPer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:34:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729055AbfEBPbt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:31:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D3B221670;
        Thu,  2 May 2019 15:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811108;
        bh=1dRUT11/rUs55WWYVal88wIVGfj/XQfUy034mNQWyWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qIGxGgwrgCYBseeCwwJV13/c3QiYZoJYcOPOu/Q36tQEt3cIsjf1/DgPqMJwUaQjm
         pqwqNzzlFOgQ+e8piJ1/HTFtDRgRj6WB7sxExb6ZPLLx0L1ua/R4DbMAzNOHJJPgYS
         5SlY97sDnyBu/PZaYpuKJZ7DDxRVivvAZf5VTi5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 078/101] kbuild: skip parsing pre sub-make code for recursion
Date:   Thu,  2 May 2019 17:21:20 +0200
Message-Id: <20190502143345.109624766@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 221cc2d27ddc49b3e06d4637db02bf78e70c573c ]

When Make recurses to the top Makefile with sub-make-done unset,
the code block surrounded by 'ifneq ($(sub-make-done),1) ... endif'
is parsed multiple times. This happens for in-tree building of
include/config/auto.conf, *-pkg, etc. with GNU Make 4.x.

This is a slight regression by commit 688931a5ad4e ("kbuild: skip
sub-make for in-tree build with GNU Make 4.x") in terms of performance
since that code block contains one $(shell ...) invocation.

Fix it by exporting the variable irrespective of sub-make being run.
I renamed it because GNU Make cannot properly export variables
containing hyphens. This is probably a bug of GNU Make, and the issue
in Kbuild had already been reported by commit 2bfbe7881ee0 ("kbuild:
Do not use hyphen in exported variable name").

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 Makefile | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index c3daaefa979c..12870303a029 100644
--- a/Makefile
+++ b/Makefile
@@ -31,7 +31,7 @@ _all:
 # descending is started. They are now explicitly listed as the
 # prepare rule.
 
-ifneq ($(sub-make-done),1)
+ifneq ($(sub_make_done),1)
 
 # Do not use make's built-in rules and variables
 # (this increases performance and avoids hard-to-debug behaviour)
@@ -159,6 +159,8 @@ need-sub-make := 1
 $(lastword $(MAKEFILE_LIST)): ;
 endif
 
+export sub_make_done := 1
+
 ifeq ($(need-sub-make),1)
 
 PHONY += $(MAKECMDGOALS) sub-make
@@ -168,12 +170,12 @@ $(filter-out _all sub-make $(CURDIR)/Makefile, $(MAKECMDGOALS)) _all: sub-make
 
 # Invoke a second make in the output directory, passing relevant variables
 sub-make:
-	$(Q)$(MAKE) sub-make-done=1 \
+	$(Q)$(MAKE) \
 	$(if $(KBUILD_OUTPUT),-C $(KBUILD_OUTPUT) KBUILD_SRC=$(CURDIR)) \
 	-f $(CURDIR)/Makefile $(filter-out _all sub-make,$(MAKECMDGOALS))
 
 endif # need-sub-make
-endif # sub-make-done
+endif # sub_make_done
 
 # We process the rest of the Makefile if this is the final invocation of make
 ifeq ($(need-sub-make),)
-- 
2.19.1



