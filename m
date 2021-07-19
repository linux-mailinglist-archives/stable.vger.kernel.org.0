Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC023CD9AA
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243805AbhGSObN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:31:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245062AbhGSOaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:30:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AB836024A;
        Mon, 19 Jul 2021 15:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707455;
        bh=n6nmUqmdKxTKnLhFD5LYShrjOaP+9FEZWtPmKcV9p/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2jJRQniC/NX+JfCu7M0+9DhjjT0cOpZmnLGCvvMkRqCbn8Wnb5m/UN8gDB+W5HLtm
         zDXRfa94ivUuqb90Y6JXIVRPstaKKXcsDZbN/+0LEZWzDqilSMpsqLZqMzSLKhRqS7
         4Rosw9bvtETbgkquffAIShl+epf8OvZo2fPoMzLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yun Zhou <yun.zhou@windriver.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.9 170/245] seq_buf: Fix overflow in seq_buf_putmem_hex()
Date:   Mon, 19 Jul 2021 16:51:52 +0200
Message-Id: <20210719144945.899681500@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yun Zhou <yun.zhou@windriver.com>

commit d3b16034a24a112bb83aeb669ac5b9b01f744bb7 upstream.

There's two variables being increased in that loop (i and j), and i
follows the raw data, and j follows what is being written into the buffer.
We should compare 'i' to MAX_MEMHEX_BYTES or compare 'j' to HEX_CHARS.
Otherwise, if 'j' goes bigger than HEX_CHARS, it will overflow the
destination buffer.

Link: https://lore.kernel.org/lkml/20210625122453.5e2fe304@oasis.local.home/
Link: https://lkml.kernel.org/r/20210626032156.47889-1-yun.zhou@windriver.com

Cc: stable@vger.kernel.org
Fixes: 5e3ca0ec76fce ("ftrace: introduce the "hex" output method")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/seq_buf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -227,8 +227,10 @@ int seq_buf_putmem_hex(struct seq_buf *s
 
 	WARN_ON(s->size == 0);
 
+	BUILD_BUG_ON(MAX_MEMHEX_BYTES * 2 >= HEX_CHARS);
+
 	while (len) {
-		start_len = min(len, HEX_CHARS - 1);
+		start_len = min(len, MAX_MEMHEX_BYTES);
 #ifdef __BIG_ENDIAN
 		for (i = 0, j = 0; i < start_len; i++) {
 #else


