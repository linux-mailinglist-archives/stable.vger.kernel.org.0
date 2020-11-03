Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503F12A59BF
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbgKCUiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:38:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729876AbgKCUiE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:04 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FBD42224E;
        Tue,  3 Nov 2020 20:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435883;
        bh=zfJuloXClB7aFVYq/TyXuVNHAJDMc1ICC7OdoGMRBhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LOHnvpg+C2WfRrENRF2Y7TUPYeZCcFhabHoPNhZ+wqaPXBAIkO+nF5dZJh0orZRdW
         IfQ8J50PKp2RRrdi+EFhuMW6rrjqOZka+pDWn6SwHkYa2zl6Zgam9Mu8voq5JAutkV
         lW+h4hsKqpOgRXaFEtiJGvVbnvikNqIqQ+yBzg6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 025/391] tracing, synthetic events: Replace buggy strcat() with seq_buf operations
Date:   Tue,  3 Nov 2020 21:31:16 +0100
Message-Id: <20201103203349.539681890@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 761a8c58db6bc884994b28cd6d9707b467d680c1 ]

There was a memory corruption bug happening while running the synthetic
event selftests:

 kmemleak: Cannot insert 0xffff8c196fa2afe5 into the object search tree (overlaps existing)
 CPU: 5 PID: 6866 Comm: ftracetest Tainted: G        W         5.9.0-rc5-test+ #577
 Hardware name: Hewlett-Packard HP Compaq Pro 6300 SFF/339A, BIOS K01 v03.03 07/14/2016
 Call Trace:
  dump_stack+0x8d/0xc0
  create_object.cold+0x3b/0x60
  slab_post_alloc_hook+0x57/0x510
  ? tracing_map_init+0x178/0x340
  __kmalloc+0x1b1/0x390
  tracing_map_init+0x178/0x340
  event_hist_trigger_func+0x523/0xa40
  trigger_process_regex+0xc5/0x110
  event_trigger_write+0x71/0xd0
  vfs_write+0xca/0x210
  ksys_write+0x70/0xf0
  do_syscall_64+0x33/0x40
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 RIP: 0033:0x7fef0a63a487
 Code: 64 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
 RSP: 002b:00007fff76f18398 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
 RAX: ffffffffffffffda RBX: 0000000000000039 RCX: 00007fef0a63a487
 RDX: 0000000000000039 RSI: 000055eb3b26d690 RDI: 0000000000000001
 RBP: 000055eb3b26d690 R08: 000000000000000a R09: 0000000000000038
 R10: 000055eb3b2cdb80 R11: 0000000000000246 R12: 0000000000000039
 R13: 00007fef0a70b500 R14: 0000000000000039 R15: 00007fef0a70b700
 kmemleak: Kernel memory leak detector disabled
 kmemleak: Object 0xffff8c196fa2afe0 (size 8):
 kmemleak:   comm "ftracetest", pid 6866, jiffies 4295082531
 kmemleak:   min_count = 1
 kmemleak:   count = 0
 kmemleak:   flags = 0x1
 kmemleak:   checksum = 0
 kmemleak:   backtrace:
      __kmalloc+0x1b1/0x390
      tracing_map_init+0x1be/0x340
      event_hist_trigger_func+0x523/0xa40
      trigger_process_regex+0xc5/0x110
      event_trigger_write+0x71/0xd0
      vfs_write+0xca/0x210
      ksys_write+0x70/0xf0
      do_syscall_64+0x33/0x40
      entry_SYSCALL_64_after_hwframe+0x44/0xa9

The cause came down to a use of strcat() that was adding an string that was
shorten, but the strcat() did not take that into account.

strcat() is extremely dangerous as it does not care how big the buffer is.
Replace it with seq_buf operations that prevent the buffer from being
overwritten if what is being written is bigger than the buffer.

Fixes: 10819e25799a ("tracing: Handle synthetic event array field type checking correctly")
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Tested-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_synth.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index c8892156db341..65e8c27141c02 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -465,6 +465,7 @@ static struct synth_field *parse_synth_field(int argc, const char **argv,
 	struct synth_field *field;
 	const char *prefix = NULL, *field_type = argv[0], *field_name, *array;
 	int len, ret = 0;
+	struct seq_buf s;
 	ssize_t size;
 
 	if (field_type[0] == ';')
@@ -503,13 +504,9 @@ static struct synth_field *parse_synth_field(int argc, const char **argv,
 		field_type++;
 	len = strlen(field_type) + 1;
 
-        if (array) {
-                int l = strlen(array);
+	if (array)
+		len += strlen(array);
 
-                if (l && array[l - 1] == ';')
-                        l--;
-                len += l;
-        }
 	if (prefix)
 		len += strlen(prefix);
 
@@ -518,14 +515,18 @@ static struct synth_field *parse_synth_field(int argc, const char **argv,
 		ret = -ENOMEM;
 		goto free;
 	}
+	seq_buf_init(&s, field->type, len);
 	if (prefix)
-		strcat(field->type, prefix);
-	strcat(field->type, field_type);
+		seq_buf_puts(&s, prefix);
+	seq_buf_puts(&s, field_type);
 	if (array) {
-		strcat(field->type, array);
-		if (field->type[len - 1] == ';')
-			field->type[len - 1] = '\0';
+		seq_buf_puts(&s, array);
+		if (s.buffer[s.len - 1] == ';')
+			s.len--;
 	}
+	if (WARN_ON_ONCE(!seq_buf_buffer_left(&s)))
+		goto free;
+	s.buffer[s.len] = '\0';
 
 	size = synth_field_size(field->type);
 	if (size <= 0) {
-- 
2.27.0



