Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44853E5AE7
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfJZNSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:18:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728037AbfJZNSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:18:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB06A21871;
        Sat, 26 Oct 2019 13:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095928;
        bh=uAWL3NA8DUTly3rqKaf/YA1hoi5jRjShZU7W9Wxjk6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y6Gr74z5WUPdYwC0mcAnvB9+y37EEWfU6eD8BaLvh2REfGljp+BIOdvhgiE2cpOHR
         RFX64hYTEZ1hg4QninZCzyy59gi/0U+FKiEfkaH8IITEu3/XJ0HpJQwUu75GV29sFV
         ltkBKHXRKAEycqJUoxt4N1CMQaVT7QOh49ICk4UI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joel Colledge <joel.colledge@linbit.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 94/99] scripts/gdb: fix lx-dmesg when CONFIG_PRINTK_CALLER is set
Date:   Sat, 26 Oct 2019 09:15:55 -0400
Message-Id: <20191026131600.2507-94-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Colledge <joel.colledge@linbit.com>

[ Upstream commit ca210ba32ef7537b02731bfe255ed8eb1e4e2b59 ]

When CONFIG_PRINTK_CALLER is set, struct printk_log contains an
additional member caller_id.  This affects the offset of the log text.
Account for this by using the type information from gdb to determine all
the offsets instead of using hardcoded values.

This fixes following error:

  (gdb) lx-dmesg
  Python Exception <class 'ValueError'> embedded null character:
  Error occurred in Python command: embedded null character

The read_u* utility functions now take an offset argument to make them
easier to use.

Link: http://lkml.kernel.org/r/20191011142500.2339-1-joel.colledge@linbit.com
Signed-off-by: Joel Colledge <joel.colledge@linbit.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/dmesg.py | 16 ++++++++++++----
 scripts/gdb/linux/utils.py | 25 +++++++++++++------------
 2 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/scripts/gdb/linux/dmesg.py b/scripts/gdb/linux/dmesg.py
index 6d2e09a2ad2f9..2fa7bb83885f0 100644
--- a/scripts/gdb/linux/dmesg.py
+++ b/scripts/gdb/linux/dmesg.py
@@ -16,6 +16,8 @@ import sys
 
 from linux import utils
 
+printk_log_type = utils.CachedType("struct printk_log")
+
 
 class LxDmesg(gdb.Command):
     """Print Linux kernel log buffer."""
@@ -42,9 +44,14 @@ class LxDmesg(gdb.Command):
             b = utils.read_memoryview(inf, log_buf_addr, log_next_idx)
             log_buf = a.tobytes() + b.tobytes()
 
+        length_offset = printk_log_type.get_type()['len'].bitpos // 8
+        text_len_offset = printk_log_type.get_type()['text_len'].bitpos // 8
+        time_stamp_offset = printk_log_type.get_type()['ts_nsec'].bitpos // 8
+        text_offset = printk_log_type.get_type().sizeof
+
         pos = 0
         while pos < log_buf.__len__():
-            length = utils.read_u16(log_buf[pos + 8:pos + 10])
+            length = utils.read_u16(log_buf, pos + length_offset)
             if length == 0:
                 if log_buf_2nd_half == -1:
                     gdb.write("Corrupted log buffer!\n")
@@ -52,10 +59,11 @@ class LxDmesg(gdb.Command):
                 pos = log_buf_2nd_half
                 continue
 
-            text_len = utils.read_u16(log_buf[pos + 10:pos + 12])
-            text = log_buf[pos + 16:pos + 16 + text_len].decode(
+            text_len = utils.read_u16(log_buf, pos + text_len_offset)
+            text_start = pos + text_offset
+            text = log_buf[text_start:text_start + text_len].decode(
                 encoding='utf8', errors='replace')
-            time_stamp = utils.read_u64(log_buf[pos:pos + 8])
+            time_stamp = utils.read_u64(log_buf, pos + time_stamp_offset)
 
             for line in text.splitlines():
                 msg = u"[{time:12.6f}] {line}\n".format(
diff --git a/scripts/gdb/linux/utils.py b/scripts/gdb/linux/utils.py
index bc67126118c4d..ea94221dbd392 100644
--- a/scripts/gdb/linux/utils.py
+++ b/scripts/gdb/linux/utils.py
@@ -92,15 +92,16 @@ def read_memoryview(inf, start, length):
     return memoryview(inf.read_memory(start, length))
 
 
-def read_u16(buffer):
+def read_u16(buffer, offset):
+    buffer_val = buffer[offset:offset + 2]
     value = [0, 0]
 
-    if type(buffer[0]) is str:
-        value[0] = ord(buffer[0])
-        value[1] = ord(buffer[1])
+    if type(buffer_val[0]) is str:
+        value[0] = ord(buffer_val[0])
+        value[1] = ord(buffer_val[1])
     else:
-        value[0] = buffer[0]
-        value[1] = buffer[1]
+        value[0] = buffer_val[0]
+        value[1] = buffer_val[1]
 
     if get_target_endianness() == LITTLE_ENDIAN:
         return value[0] + (value[1] << 8)
@@ -108,18 +109,18 @@ def read_u16(buffer):
         return value[1] + (value[0] << 8)
 
 
-def read_u32(buffer):
+def read_u32(buffer, offset):
     if get_target_endianness() == LITTLE_ENDIAN:
-        return read_u16(buffer[0:2]) + (read_u16(buffer[2:4]) << 16)
+        return read_u16(buffer, offset) + (read_u16(buffer, offset + 2) << 16)
     else:
-        return read_u16(buffer[2:4]) + (read_u16(buffer[0:2]) << 16)
+        return read_u16(buffer, offset + 2) + (read_u16(buffer, offset) << 16)
 
 
-def read_u64(buffer):
+def read_u64(buffer, offset):
     if get_target_endianness() == LITTLE_ENDIAN:
-        return read_u32(buffer[0:4]) + (read_u32(buffer[4:8]) << 32)
+        return read_u32(buffer, offset) + (read_u32(buffer, offset + 4) << 32)
     else:
-        return read_u32(buffer[4:8]) + (read_u32(buffer[0:4]) << 32)
+        return read_u32(buffer, offset + 4) + (read_u32(buffer, offset) << 32)
 
 
 target_arch = None
-- 
2.20.1

