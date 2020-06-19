Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5AD620148D
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391217AbgFSQM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:12:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390728AbgFSPE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:04:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7337721941;
        Fri, 19 Jun 2020 15:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579098;
        bh=G55nFWnpw32hiv2wW5Qw8jEXLGNHxJVBMoYUIUI9F18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6hvhPqA0NPLu11xjNwfH/XnquQSrK+W5D4OBPIUCeRbLOeciH/U1EAdi1Igkdi2l
         Ht2qNiYnPy3aScqn5LmqGyE02S04gfgwbjD2HPoDTctePAWy3YezczpB0PYCIbKQ/w
         ZLeEegCQ9xGPcl2Ecx+4pK+QsNclM5SNHXezoTR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.19 258/267] kbuild: force to build vmlinux if CONFIG_MODVERSION=y
Date:   Fri, 19 Jun 2020 16:34:03 +0200
Message-Id: <20200619141701.041984692@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 4b50c8c4eaf06a825d1c005c0b1b4a8307087b83 upstream.

This code does not work as stated in the comment.

$(CONFIG_MODVERSIONS) is always empty because it is expanded before
include/config/auto.conf is included. Hence, 'make modules' with
CONFIG_MODVERSION=y cannot record the version CRCs.

This has been broken since 2003, commit ("kbuild: Enable modules to be
build using the "make dir/" syntax"). [1]

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/history/history.git/commit/?id=15c6240cdc44bbeef3c4797ec860f9765ef4f1a7
Cc: linux-stable <stable@vger.kernel.org> # v2.5.71+
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Makefile |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -554,12 +554,8 @@ KBUILD_MODULES :=
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
@@ -1229,6 +1225,13 @@ ifdef CONFIG_MODULES
 
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


