Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54073CDBF2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239320AbhGSOui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:50:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344560AbhGSOs5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:48:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F14D601FD;
        Mon, 19 Jul 2021 15:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708576;
        bh=eT2464UUIoc1XvHDDNWibBFvNbdYxXJzmGqDQIhQeCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqAN61YspYl7tzrRJZ5OfgsrT7XRIy/QCjWgZN4TU84QEbQG906fl4hchGFqdDOP4
         YbwZbaaOT3CXhVEEs2rT7T6mK69gjNmN4Yc6jVLWFa/sq5xCUU5lFvjO9wA7PkNCvC
         eoT9LwTolRe7Cm20E3uWa03uEnWfua6fevnIzBpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yun Zhou <yun.zhou@windriver.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 046/421] seq_buf: Make trace_seq_putmem_hex() support data longer than 8
Date:   Mon, 19 Jul 2021 16:47:37 +0200
Message-Id: <20210719144947.816945376@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yun Zhou <yun.zhou@windriver.com>

commit 6a2cbc58d6c9d90cd74288cc497c2b45815bc064 upstream.

Since the raw memory 'data' does not go forward, it will dump repeated
data if the data length is more than 8. If we want to dump longer data
blocks, we need to repeatedly call macro SEQ_PUT_HEX_FIELD. I think it
is a bit redundant, and multiple function calls also affect the performance.

Link: https://lore.kernel.org/lkml/20210625122453.5e2fe304@oasis.local.home/
Link: https://lkml.kernel.org/r/20210626032156.47889-2-yun.zhou@windriver.com

Cc: stable@vger.kernel.org
Fixes: 6d2289f3faa7 ("tracing: Make trace_seq_putmem_hex() more robust")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/seq_buf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -242,12 +242,14 @@ int seq_buf_putmem_hex(struct seq_buf *s
 			break;
 
 		/* j increments twice per loop */
-		len -= j / 2;
 		hex[j++] = ' ';
 
 		seq_buf_putmem(s, hex, j);
 		if (seq_buf_has_overflowed(s))
 			return -1;
+
+		len -= start_len;
+		data += start_len;
 	}
 	return 0;
 }


