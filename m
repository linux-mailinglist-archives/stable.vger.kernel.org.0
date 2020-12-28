Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411D52E37FF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730298AbgL1NDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:03:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:60030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730293AbgL1NDv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:03:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A89432245C;
        Mon, 28 Dec 2020 13:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160590;
        bh=ZDLuezUecvvZpYdnsZTEvnhf/rHrjafxsKalCchwpfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3AW9CL4ImGoQsDRTY7NHUdKi5wtJ3I/0myaTDuiplrL3emMtfUyQ8gcgH224liE5
         L0Lfb/ujeh82ShYmqOnk3L5bldsj/tP06iJjovCfNAldlBNjISYoqU9bZcDubfMuFT
         VDdHi1DZUuKU5b9Zgc4ZC8Qm1+SDURylDeHBBG6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 103/175] seq_buf: Avoid type mismatch for seq_buf_init
Date:   Mon, 28 Dec 2020 13:49:16 +0100
Message-Id: <20201228124858.240683231@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d9a9280a0d0ae51dc1d4142138b99242b7ec8ac6 ]

Building with W=2 prints a number of warnings for one function that
has a pointer type mismatch:

linux/seq_buf.h: In function 'seq_buf_init':
linux/seq_buf.h:35:12: warning: pointer targets in assignment from 'unsigned char *' to 'char *' differ in signedness [-Wpointer-sign]

Change the type in the function prototype according to the type in
the structure.

Link: https://lkml.kernel.org/r/20201026161108.3707783-1-arnd@kernel.org

Fixes: 9a7777935c34 ("tracing: Convert seq_buf fields to be like seq_file fields")
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/seq_buf.h   | 2 +-
 include/linux/trace_seq.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index fb7eb9ccb1cd4..d4c3c9bab5826 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -29,7 +29,7 @@ static inline void seq_buf_clear(struct seq_buf *s)
 }
 
 static inline void
-seq_buf_init(struct seq_buf *s, unsigned char *buf, unsigned int size)
+seq_buf_init(struct seq_buf *s, char *buf, unsigned int size)
 {
 	s->buffer = buf;
 	s->size = size;
diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index cfaf5a1d4bad7..f5be2716b01c6 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -11,7 +11,7 @@
  */
 
 struct trace_seq {
-	unsigned char		buffer[PAGE_SIZE];
+	char			buffer[PAGE_SIZE];
 	struct seq_buf		seq;
 	int			full;
 };
@@ -50,7 +50,7 @@ static inline int trace_seq_used(struct trace_seq *s)
  * that is about to be written to and then return the result
  * of that write.
  */
-static inline unsigned char *
+static inline char *
 trace_seq_buffer_ptr(struct trace_seq *s)
 {
 	return s->buffer + seq_buf_used(&s->seq);
-- 
2.27.0



