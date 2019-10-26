Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7648E5B2E
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbfJZNVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:21:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728800AbfJZNVI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:21:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A243222BE;
        Sat, 26 Oct 2019 13:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096068;
        bh=rXRtwToaCGuYjPFcWlslPVaS9rgJjmE4QAtIj0oVni0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dnuer8fx1PJNtlTZqT6Tkq6xgnatK21pyhL+1lrVZs97MivtSa5KntPwIY/ozdj0z
         JxXCm0r1uAyzbV5IJH3oV8I9NMZlV8Ae5CsTuU8taAmO+F+yRgrtgSyuOZgKqo+x+X
         7K6DIbVXAQYCb8JCOoatz5xPskiUztor8Z4Z/iD4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 59/59] scripts/gdb: fix debugging modules on s390
Date:   Sat, 26 Oct 2019 09:19:10 -0400
Message-Id: <20191026131910.3435-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131910.3435-1-sashal@kernel.org>
References: <20191026131910.3435-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 585d730d41120926e3f79a601edad3930fa28366 ]

Currently lx-symbols assumes that module text is always located at
module->core_layout->base, but s390 uses the following layout:

  +------+  <- module->core_layout->base
  | GOT  |
  +------+  <- module->core_layout->base + module->arch->plt_offset
  | PLT  |
  +------+  <- module->core_layout->base + module->arch->plt_offset +
  | TEXT |     module->arch->plt_size
  +------+

Therefore, when trying to debug modules on s390, all the symbol
addresses are skewed by plt_offset + plt_size.

Fix by adding plt_offset + plt_size to module_addr in
load_module_symbols().

Link: http://lkml.kernel.org/r/20191017085917.81791-1-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/symbols.py | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/scripts/gdb/linux/symbols.py b/scripts/gdb/linux/symbols.py
index 004b0ac7fa72d..d869e588f4ec4 100644
--- a/scripts/gdb/linux/symbols.py
+++ b/scripts/gdb/linux/symbols.py
@@ -15,7 +15,7 @@ import gdb
 import os
 import re
 
-from linux import modules
+from linux import modules, utils
 
 
 if hasattr(gdb, 'Breakpoint'):
@@ -116,6 +116,12 @@ lx-symbols command."""
             module_file = self._get_module_file(module_name)
 
         if module_file:
+            if utils.is_target_arch('s390'):
+                # Module text is preceded by PLT stubs on s390.
+                module_arch = module['arch']
+                plt_offset = int(module_arch['plt_offset'])
+                plt_size = int(module_arch['plt_size'])
+                module_addr = hex(int(module_addr, 0) + plt_offset + plt_size)
             gdb.write("loading @{addr}: {filename}\n".format(
                 addr=module_addr, filename=module_file))
             cmdline = "add-symbol-file {filename} {addr}{sections}".format(
-- 
2.20.1

