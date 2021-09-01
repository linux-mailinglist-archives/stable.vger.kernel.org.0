Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650B63FDB78
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343633AbhIAMls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344894AbhIAMkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAFC060E98;
        Wed,  1 Sep 2021 12:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499766;
        bh=9dLoX9qhRExAidc7yab+5IM5sB1k09jKXcJrIlxLTeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GyP83F+S18IdwUOrgAV+A3FWcW14un1igAPq3XjcyjYym+kxfoSSUborvWZOXP45v
         i4RF2Y02TQPeCBcGXtMNBmCXrq6Q3RcE5R7rMVoMLwhlwBHIjp3d6iqqqzKN9A1JuG
         OxXKsh6EILXxHt0ZmNgP5YCkSHoZ3P8g7DDTARZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Subject: [PATCH 5.10 078/103] riscv: Fixup wrong ftrace remove cflag
Date:   Wed,  1 Sep 2021 14:28:28 +0200
Message-Id: <20210901122303.180582648@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

commit 67d945778099b14324811fe67c5aff2cda7a7ad5 upstream.

We must use $(CC_FLAGS_FTRACE) instead of directly using -pg. It
will cause -fpatchable-function-entry error.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/Makefile |    4 ++--
 arch/riscv/mm/Makefile     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -4,8 +4,8 @@
 #
 
 ifdef CONFIG_FTRACE
-CFLAGS_REMOVE_ftrace.o	= -pg
-CFLAGS_REMOVE_patch.o	= -pg
+CFLAGS_REMOVE_ftrace.o	= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_patch.o	= $(CC_FLAGS_FTRACE)
 endif
 
 extra-y += head.o
--- a/arch/riscv/mm/Makefile
+++ b/arch/riscv/mm/Makefile
@@ -2,7 +2,7 @@
 
 CFLAGS_init.o := -mcmodel=medany
 ifdef CONFIG_FTRACE
-CFLAGS_REMOVE_init.o = -pg
+CFLAGS_REMOVE_init.o = $(CC_FLAGS_FTRACE)
 endif
 
 KCOV_INSTRUMENT_init.o := n


