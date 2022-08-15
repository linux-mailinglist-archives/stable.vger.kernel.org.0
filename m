Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB7C5938EF
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244362AbiHOTVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344499AbiHOTVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:21:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E58B77;
        Mon, 15 Aug 2022 11:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30713B81082;
        Mon, 15 Aug 2022 18:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C69DC433B5;
        Mon, 15 Aug 2022 18:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588813;
        bh=sl4Fi1GtVI3xilBeMMiFXxAxo/7l7eg0v2oFNV/ihkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TyZ0HKj4cteyi7NuonNcqxXVZndXUp8t0E4Fa0E/G3kFhnY9AZKdaaNzKCH6bHoom
         njvzUnbwEyObiPjWbAEl43Hbx5h7gRAJjqPTs4GcIwteTUyJLvSlJWYm+MtKxjQWvw
         fyKjl17/kVPYyfd7eb0kObVqVyV3PQztSirFkPf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Ogness <john.ogness@linutronix.de>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 521/779] scripts/gdb: lx-dmesg: read records individually
Date:   Mon, 15 Aug 2022 20:02:45 +0200
Message-Id: <20220815180359.514327692@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit deaee2704a157dfcca77301ddaa10c62a9840952 ]

For the gdb command lx-dmesg, the entire descriptor, info, and text
data regions are read into memory before printing any records. For
large kernel log buffers, this not only causes a huge delay before
seeing any records, but it may also lead to python errors of too
much memory allocation.

Rather than reading in all these regions in advance, read them as
needed and only read the regions for the particular record that is
being printed.

The gdb macro "dmesg" in Documentation/admin-guide/kdump/gdbmacros.txt
already prints out the kernel log buffer like this.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/874k79c3a9.fsf@jogness.linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/dmesg.py | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/scripts/gdb/linux/dmesg.py b/scripts/gdb/linux/dmesg.py
index a92c55bd8de5..d5983cf3db7d 100644
--- a/scripts/gdb/linux/dmesg.py
+++ b/scripts/gdb/linux/dmesg.py
@@ -44,19 +44,17 @@ class LxDmesg(gdb.Command):
         sz = prb_desc_ring_type.get_type().sizeof
         desc_ring = utils.read_memoryview(inf, addr, sz).tobytes()
 
-        # read in descriptor array
+        # read in descriptor count, size, and address
         off = prb_desc_ring_type.get_type()['count_bits'].bitpos // 8
         desc_ring_count = 1 << utils.read_u32(desc_ring, off)
         desc_sz = prb_desc_type.get_type().sizeof
         off = prb_desc_ring_type.get_type()['descs'].bitpos // 8
-        addr = utils.read_ulong(desc_ring, off)
-        descs = utils.read_memoryview(inf, addr, desc_sz * desc_ring_count).tobytes()
+        desc_addr = utils.read_ulong(desc_ring, off)
 
-        # read in info array
+        # read in info size and address
         info_sz = printk_info_type.get_type().sizeof
         off = prb_desc_ring_type.get_type()['infos'].bitpos // 8
-        addr = utils.read_ulong(desc_ring, off)
-        infos = utils.read_memoryview(inf, addr, info_sz * desc_ring_count).tobytes()
+        info_addr = utils.read_ulong(desc_ring, off)
 
         # read in text data ring structure
         off = printk_ringbuffer_type.get_type()['text_data_ring'].bitpos // 8
@@ -64,12 +62,11 @@ class LxDmesg(gdb.Command):
         sz = prb_data_ring_type.get_type().sizeof
         text_data_ring = utils.read_memoryview(inf, addr, sz).tobytes()
 
-        # read in text data
+        # read in text data size and address
         off = prb_data_ring_type.get_type()['size_bits'].bitpos // 8
         text_data_sz = 1 << utils.read_u32(text_data_ring, off)
         off = prb_data_ring_type.get_type()['data'].bitpos // 8
-        addr = utils.read_ulong(text_data_ring, off)
-        text_data = utils.read_memoryview(inf, addr, text_data_sz).tobytes()
+        text_data_addr = utils.read_ulong(text_data_ring, off)
 
         counter_off = atomic_long_type.get_type()['counter'].bitpos // 8
 
@@ -102,17 +99,20 @@ class LxDmesg(gdb.Command):
             desc_off = desc_sz * ind
             info_off = info_sz * ind
 
+            desc = utils.read_memoryview(inf, desc_addr + desc_off, desc_sz).tobytes()
+
             # skip non-committed record
-            state = 3 & (utils.read_u64(descs, desc_off + sv_off +
-                                        counter_off) >> desc_flags_shift)
+            state = 3 & (utils.read_u64(desc, sv_off + counter_off) >> desc_flags_shift)
             if state != desc_committed and state != desc_finalized:
                 if did == head_id:
                     break
                 did = (did + 1) & desc_id_mask
                 continue
 
-            begin = utils.read_ulong(descs, desc_off + begin_off) % text_data_sz
-            end = utils.read_ulong(descs, desc_off + next_off) % text_data_sz
+            begin = utils.read_ulong(desc, begin_off) % text_data_sz
+            end = utils.read_ulong(desc, next_off) % text_data_sz
+
+            info = utils.read_memoryview(inf, info_addr + info_off, info_sz).tobytes()
 
             # handle data-less record
             if begin & 1 == 1:
@@ -125,16 +125,17 @@ class LxDmesg(gdb.Command):
                 # skip over descriptor id
                 text_start = begin + utils.get_long_type().sizeof
 
-                text_len = utils.read_u16(infos, info_off + len_off)
+                text_len = utils.read_u16(info, len_off)
 
                 # handle truncated message
                 if end - text_start < text_len:
                     text_len = end - text_start
 
-                text = text_data[text_start:text_start + text_len].decode(
-                    encoding='utf8', errors='replace')
+                text_data = utils.read_memoryview(inf, text_data_addr + text_start,
+                                                  text_len).tobytes()
+                text = text_data[0:text_len].decode(encoding='utf8', errors='replace')
 
-            time_stamp = utils.read_u64(infos, info_off + ts_off)
+            time_stamp = utils.read_u64(info, ts_off)
 
             for line in text.splitlines():
                 msg = u"[{time:12.6f}] {line}\n".format(
-- 
2.35.1



