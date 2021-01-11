Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7D52F1752
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730492AbhAKOEc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 09:04:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:50168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729653AbhAKNEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:04:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1B4222510;
        Mon, 11 Jan 2021 13:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370254;
        bh=DRoRqQQBswdCBl55XS8JkjM5qZJDY4mRCE1SmEDpnhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wag5+dTFSeNmlAuENHinu71wEjXrvwK318/RJ0LtjGhWbBh5RbxqqVa15rbekzFFw
         NIDL+iTSoNfVXvXEywC0iOr820xvj03lYZSDYsH8Yl66hWgY5nK7MQY6EoyFgL7jwC
         fSc9QW1zalDUk3mikoZFal+KCSfcBGUpUBjCuMao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Andr=C3=A9=20Draszik?= <git@andred.net>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 17/45] scripts/gdb: make lx-dmesg command work (reliably)
Date:   Mon, 11 Jan 2021 14:00:55 +0100
Message-Id: <20210111130034.486455041@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.676306636@linuxfoundation.org>
References: <20210111130033.676306636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: André Draszik <git@andred.net>

commit d6c9708737c2107c38bd75f133d14d5801b8d6d5 upstream

lx-dmesg needs access to the log_buf symbol from printk.c.
Unfortunately, the symbol log_buf also exists in BPF's verifier.c and
hence gdb can pick one or the other.  If it happens to pick BPF's
log_buf, lx-dmesg doesn't work:

  (gdb) lx-dmesg
  Python Exception <class 'gdb.MemoryError'> Cannot access memory at address 0x0:
  Error occurred in Python command: Cannot access memory at address 0x0
  (gdb) p log_buf
  $15 = 0x0

Luckily, GDB has a way to deal with this, see
  https://sourceware.org/gdb/onlinedocs/gdb/Symbols.html

  (gdb) info variables ^log_buf$
  All variables matching regular expression "^log_buf$":

  File <linux.git>/kernel/bpf/verifier.c:
  static char *log_buf;

  File <linux.git>/kernel/printk/printk.c:
  static char *log_buf;
  (gdb) p 'verifier.c'::log_buf
  $1 = 0x0
  (gdb) p 'printk.c'::log_buf
  $2 = 0x811a6aa0 <__log_buf> ""
  (gdb) p &log_buf
  $3 = (char **) 0x8120fe40 <log_buf>
  (gdb) p &'verifier.c'::log_buf
  $4 = (char **) 0x8120fe40 <log_buf>
  (gdb) p &'printk.c'::log_buf
  $5 = (char **) 0x8048b7d0 <log_buf>

By being explicit about the location of the symbol, we can make lx-dmesg
work again.  While at it, do the same for the other symbols we need from
printk.c

Link: http://lkml.kernel.org/r/20170526112222.3414-1-git@andred.net
Signed-off-by: André Draszik <git@andred.net>
Tested-by: Kieran Bingham <kieran@bingham.xyz>
Acked-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/dmesg.py | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/scripts/gdb/linux/dmesg.py b/scripts/gdb/linux/dmesg.py
index f9b92ece78343..5afd1098e33a1 100644
--- a/scripts/gdb/linux/dmesg.py
+++ b/scripts/gdb/linux/dmesg.py
@@ -23,10 +23,11 @@ class LxDmesg(gdb.Command):
         super(LxDmesg, self).__init__("lx-dmesg", gdb.COMMAND_DATA)
 
     def invoke(self, arg, from_tty):
-        log_buf_addr = int(str(gdb.parse_and_eval("log_buf")).split()[0], 16)
-        log_first_idx = int(gdb.parse_and_eval("log_first_idx"))
-        log_next_idx = int(gdb.parse_and_eval("log_next_idx"))
-        log_buf_len = int(gdb.parse_and_eval("log_buf_len"))
+        log_buf_addr = int(str(gdb.parse_and_eval(
+            "'printk.c'::log_buf")).split()[0], 16)
+        log_first_idx = int(gdb.parse_and_eval("'printk.c'::log_first_idx"))
+        log_next_idx = int(gdb.parse_and_eval("'printk.c'::log_next_idx"))
+        log_buf_len = int(gdb.parse_and_eval("'printk.c'::log_buf_len"))
 
         inf = gdb.inferiors()[0]
         start = log_buf_addr + log_first_idx
-- 
2.27.0



