Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59799594C06
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244668AbiHPA11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356153AbiHPA0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:26:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD18F17FC9F;
        Mon, 15 Aug 2022 13:34:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FC7E6120D;
        Mon, 15 Aug 2022 20:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D366C433C1;
        Mon, 15 Aug 2022 20:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595673;
        bh=tcRxpjtw1HiPUhUHNS8nboJEdUsZZ/FIKajP6IXJOMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mCW6M2rgPUChKa3bsqvQRUm7zpBhOAt79xbDgytRmpqYPPynD4kfaytzhAizR5xMK
         WKzd0TNqqzBSlau37Gp03c1bvAjFdQNoUNDrDySGV27bB4+YwsD2UghFhnuxwDbpE7
         QPY0UKn+P7yyPRNkiZgjMGlQg9HV12XtYvcFVwYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Antonio Borneo <antonio.borneo@foss.st.com>,
        John Ogness <john.ogness@linutronix.de>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0839/1157] scripts/gdb: fix lx-dmesg on 32 bits arch
Date:   Mon, 15 Aug 2022 20:03:15 +0200
Message-Id: <20220815180513.053395810@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antonio Borneo <antonio.borneo@foss.st.com>

[ Upstream commit e3c8d33e0d62175c31ca7ab7ab01b18f0b6318d3 ]

The type atomic_long_t can have size 4 or 8 bytes, depending on
CONFIG_64BIT; it's only content, the field 'counter', is either an
int or a s64 value.

Current code incorrectly uses the fixed size utils.read_u64() to
read the field 'counter' inside atomic_long_t.

On 32 bits architectures reading the last element 'tail_id' of the
struct prb_desc_ring:
	struct prb_desc_ring {
		...
		atomic_long_t tail_id;
	};
causes the utils.read_u64() to access outside the boundary of the
struct and the gdb command 'lx-dmesg' exits with error:
	Python Exception <class 'IndexError'>: index out of range
	Error occurred in Python: index out of range

Query the really used atomic_long_t counter type size.

Link: https://lore.kernel.org/r/20220617143758.137307-1-antonio.borneo@foss.st.com
Fixes: e60768311af8 ("scripts/gdb: update for lockless printk ringbuffer")
Signed-off-by: Antonio Borneo <antonio.borneo@foss.st.com>
[pmladek@suse.com: Query the really used atomic_long_t counter type size]
Tested-by: Antonio Borneo <antonio.borneo@foss.st.com>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20220719122831.19890-1-pmladek@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/dmesg.py |  9 +++------
 scripts/gdb/linux/utils.py | 14 ++++++++++++--
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/scripts/gdb/linux/dmesg.py b/scripts/gdb/linux/dmesg.py
index d5983cf3db7d..c771831eb077 100644
--- a/scripts/gdb/linux/dmesg.py
+++ b/scripts/gdb/linux/dmesg.py
@@ -22,7 +22,6 @@ prb_desc_type = utils.CachedType("struct prb_desc")
 prb_desc_ring_type = utils.CachedType("struct prb_desc_ring")
 prb_data_ring_type = utils.CachedType("struct prb_data_ring")
 printk_ringbuffer_type = utils.CachedType("struct printk_ringbuffer")
-atomic_long_type = utils.CachedType("atomic_long_t")
 
 class LxDmesg(gdb.Command):
     """Print Linux kernel log buffer."""
@@ -68,8 +67,6 @@ class LxDmesg(gdb.Command):
         off = prb_data_ring_type.get_type()['data'].bitpos // 8
         text_data_addr = utils.read_ulong(text_data_ring, off)
 
-        counter_off = atomic_long_type.get_type()['counter'].bitpos // 8
-
         sv_off = prb_desc_type.get_type()['state_var'].bitpos // 8
 
         off = prb_desc_type.get_type()['text_blk_lpos'].bitpos // 8
@@ -89,9 +86,9 @@ class LxDmesg(gdb.Command):
 
         # read in tail and head descriptor ids
         off = prb_desc_ring_type.get_type()['tail_id'].bitpos // 8
-        tail_id = utils.read_u64(desc_ring, off + counter_off)
+        tail_id = utils.read_atomic_long(desc_ring, off)
         off = prb_desc_ring_type.get_type()['head_id'].bitpos // 8
-        head_id = utils.read_u64(desc_ring, off + counter_off)
+        head_id = utils.read_atomic_long(desc_ring, off)
 
         did = tail_id
         while True:
@@ -102,7 +99,7 @@ class LxDmesg(gdb.Command):
             desc = utils.read_memoryview(inf, desc_addr + desc_off, desc_sz).tobytes()
 
             # skip non-committed record
-            state = 3 & (utils.read_u64(desc, sv_off + counter_off) >> desc_flags_shift)
+            state = 3 & (utils.read_atomic_long(desc, sv_off) >> desc_flags_shift)
             if state != desc_committed and state != desc_finalized:
                 if did == head_id:
                     break
diff --git a/scripts/gdb/linux/utils.py b/scripts/gdb/linux/utils.py
index ff7c1799d588..1553f68716cc 100644
--- a/scripts/gdb/linux/utils.py
+++ b/scripts/gdb/linux/utils.py
@@ -35,13 +35,12 @@ class CachedType:
 
 
 long_type = CachedType("long")
-
+atomic_long_type = CachedType("atomic_long_t")
 
 def get_long_type():
     global long_type
     return long_type.get_type()
 
-
 def offset_of(typeobj, field):
     element = gdb.Value(0).cast(typeobj)
     return int(str(element[field].address).split()[0], 16)
@@ -129,6 +128,17 @@ def read_ulong(buffer, offset):
     else:
         return read_u32(buffer, offset)
 
+atomic_long_counter_offset = atomic_long_type.get_type()['counter'].bitpos
+atomic_long_counter_sizeof = atomic_long_type.get_type()['counter'].type.sizeof
+
+def read_atomic_long(buffer, offset):
+    global atomic_long_counter_offset
+    global atomic_long_counter_sizeof
+
+    if atomic_long_counter_sizeof == 8:
+        return read_u64(buffer, offset + atomic_long_counter_offset)
+    else:
+        return read_u32(buffer, offset + atomic_long_counter_offset)
 
 target_arch = None
 
-- 
2.35.1



