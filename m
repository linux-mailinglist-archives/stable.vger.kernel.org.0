Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAAA1F2E82
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbgFIAmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729123AbgFHXMa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EEDD20B80;
        Mon,  8 Jun 2020 23:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657950;
        bh=J0Cr1ClTzawFS2xo1kfwDnsGciGqVo6rmgk9gsoD7eU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cRNY/rGbOGBaK6xiMpny1S5Y4j8Vx08/IA+B5GRMB6wXBED/b0nAvHbnYSeJmmvzB
         XJdv9tv+UXng2CVZJJvcmtrveaQfmFIHGZVrcwIbHJycaIWdQU9UlMt97ymdUcBrue
         ylWCy4VNB80nyslWoDRDITEaCwvR5zcpe1rc8fo0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 015/606] gcc-10 warnings: fix low-hanging fruit
Date:   Mon,  8 Jun 2020 19:02:20 -0400
Message-Id: <20200608231211.3363633-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 9d82973e032e246ff5663c9805fbb5407ae932e3 upstream.

Due to a bug-report that was compiler-dependent, I updated one of my
machines to gcc-10.  That shows a lot of new warnings.  Happily they
seem to be mostly the valid kind, but it's going to cause a round of
churn for getting rid of them..

This is the really low-hanging fruit of removing a couple of zero-sized
arrays in some core code.  We have had a round of these patches before,
and we'll have many more coming, and there is nothing special about
these except that they were particularly trivial, and triggered more
warnings than most.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/fs.h  | 2 +-
 include/linux/tty.h | 2 +-
 scripts/kallsyms.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index abedbffe2c9e..872ee2131589 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -978,7 +978,7 @@ struct file_handle {
 	__u32 handle_bytes;
 	int handle_type;
 	/* file identifier */
-	unsigned char f_handle[0];
+	unsigned char f_handle[];
 };
 
 static inline struct file *get_file(struct file *f)
diff --git a/include/linux/tty.h b/include/linux/tty.h
index bd5fe0e907e8..a99e9b8e4e31 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -66,7 +66,7 @@ struct tty_buffer {
 	int read;
 	int flags;
 	/* Data points here */
-	unsigned long data[0];
+	unsigned long data[];
 };
 
 /* Values for .flags field of tty_buffer */
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 3e8dea6e0a95..6dc3078649fa 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -34,7 +34,7 @@ struct sym_entry {
 	unsigned int len;
 	unsigned int start_pos;
 	unsigned int percpu_absolute;
-	unsigned char sym[0];
+	unsigned char sym[];
 };
 
 struct addr_range {
-- 
2.25.1

