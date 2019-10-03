Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9673DCA8D7
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404011AbfJCQd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391065AbfJCQdx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:33:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40F9320830;
        Thu,  3 Oct 2019 16:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120432;
        bh=BZapDg6ZGXM9Rg5kPcRilfrz2LUQyzrkxIwwMOM1Xy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbzpc49mwYYk/iN8FrZRD97MSg2E6WVAnofWx20LK3i7Tfp9geNLQnnmBxAmHvfjx
         djorp6whvxKOrSG2+4yiQmdx1ZmngAsEZ77YziKTMpVybRqf4bZmtnoq1IcVJVKw+0
         8esmDatWwl+mBJZ3d74DSgql+K1nY04JkS0j7XS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, rostedt@goodmis.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH 5.2 220/313] printk: Do not lose last line in kmsg buffer dump
Date:   Thu,  3 Oct 2019 17:53:18 +0200
Message-Id: <20191003154554.709877128@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

commit c9dccacfccc72c32692eedff4a27a4b0833a2afd upstream.

kmsg_dump_get_buffer() is supposed to select all the youngest log
messages which fit into the provided buffer.  It determines the correct
start index by using msg_print_text() with a NULL buffer to calculate
the size of each entry.  However, when performing the actual writes,
msg_print_text() only writes the entry to the buffer if the written len
is lesser than the size of the buffer.  So if the lengths of the
selected youngest log messages happen to precisely fill up the provided
buffer, the last log message is not included.

We don't want to modify msg_print_text() to fill up the buffer and start
returning a length which is equal to the size of the buffer, since
callers of its other users, such as kmsg_dump_get_line(), depend upon
the current behaviour.

Instead, fix kmsg_dump_get_buffer() to compensate for this.

For example, with the following two final prints:

[    6.427502] AAAAAAAAAAAAA
[    6.427769] BBBBBBBB12345

A dump of a 64-byte buffer filled by kmsg_dump_get_buffer(), before this
patch:

 00000000: 3c 30 3e 5b 20 20 20 20 36 2e 35 32 32 31 39 37  <0>[    6.522197
 00000010: 5d 20 41 41 41 41 41 41 41 41 41 41 41 41 41 0a  ] AAAAAAAAAAAAA.
 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

After this patch:

 00000000: 3c 30 3e 5b 20 20 20 20 36 2e 34 35 36 36 37 38  <0>[    6.456678
 00000010: 5d 20 42 42 42 42 42 42 42 42 31 32 33 34 35 0a  ] BBBBBBBB12345.
 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

Link: http://lkml.kernel.org/r/20190711142937.4083-1-vincent.whitchurch@axis.com
Fixes: e2ae715d66bf4bec ("kmsg - kmsg_dump() use iterator to receive log buffer content")
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Cc: <stable@vger.kernel.org> # v3.5+
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/printk/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3274,7 +3274,7 @@ bool kmsg_dump_get_buffer(struct kmsg_du
 	/* move first record forward until length fits into the buffer */
 	seq = dumper->cur_seq;
 	idx = dumper->cur_idx;
-	while (l > size && seq < dumper->next_seq) {
+	while (l >= size && seq < dumper->next_seq) {
 		struct printk_log *msg = log_from_idx(idx);
 
 		l -= msg_print_text(msg, true, time, NULL, 0);


