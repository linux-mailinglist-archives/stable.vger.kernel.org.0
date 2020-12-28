Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42932E3D83
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441191AbgL1OQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:16:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:50990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440947AbgL1OQL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:16:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE98421D94;
        Mon, 28 Dec 2020 14:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164955;
        bh=vXFuc3y5LpT/Iu3UtzcWuVkx4CeKM/PYpmLG4J9OEew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sca4eyC8PF2LC9OAuBMJm9z5vWclz+TCmcWVdjBXdgTdi6tolnunsCbgeA2mPcPAl
         xWjXEFndmBwsWJcuk1Q9eVu+PM6lrWhbh1ICXCbjmLc1s2Rhbv0iq2Ra5ZBB14H/vR
         GVEiQfcQlHtSeiigq6y/KS07I2HICmqqFJw7jlVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 359/717] seq_buf: Avoid type mismatch for seq_buf_init
Date:   Mon, 28 Dec 2020 13:45:57 +0100
Message-Id: <20201228125038.212011795@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index fb0205d87d3c1..9d6c28cc4d8f2 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -30,7 +30,7 @@ static inline void seq_buf_clear(struct seq_buf *s)
 }
 
 static inline void
-seq_buf_init(struct seq_buf *s, unsigned char *buf, unsigned int size)
+seq_buf_init(struct seq_buf *s, char *buf, unsigned int size)
 {
 	s->buffer = buf;
 	s->size = size;
diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index 6c30508fca198..5a2c650d9e1c1 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -12,7 +12,7 @@
  */
 
 struct trace_seq {
-	unsigned char		buffer[PAGE_SIZE];
+	char			buffer[PAGE_SIZE];
 	struct seq_buf		seq;
 	int			full;
 };
@@ -51,7 +51,7 @@ static inline int trace_seq_used(struct trace_seq *s)
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



