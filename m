Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A3F200BF1
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388076AbgFSOjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:39:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387594AbgFSOjq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:39:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 384502070A;
        Fri, 19 Jun 2020 14:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577585;
        bh=IjElmARq6eMzDOjlp6QPQm+41lcq/XlSv+UorJp2UCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Co60UGoFejsgh/VDl5tLuiR+0HdZlRriP7Tm01MzHcFW7hwUpUrX4WwOOhrtwAXr7
         Upd3oLEHwWqk+0eMzYnP3Ta5hlm5WLllMpukXZ3ePyv7xHzBSMXzb0FmBzetOFYj48
         CV2gmCqY3Krs8cagVqUcZZZ7pom/PBK4TVbsUxls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.4 096/101] kbuild: force to build vmlinux if CONFIG_MODVERSION=y
Date:   Fri, 19 Jun 2020 16:33:25 +0200
Message-Id: <20200619141618.992572618@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
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
@@ -313,12 +313,8 @@ KBUILD_MODULES :=
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
@@ -1156,6 +1152,13 @@ ifdef CONFIG_MODULES
 
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


