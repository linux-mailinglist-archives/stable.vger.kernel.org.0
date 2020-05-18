Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99EF31D850A
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731829AbgERR5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:57:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731825AbgERR5k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:57:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6707920674;
        Mon, 18 May 2020 17:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824659;
        bh=CncCaItO4mAN4EliTW7rMnGycSoeTL1vbEZZOWBSb6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUE1WFZG/1Eugn5je1coqWIXsbSHqp45YziK3/o8ucPlmIcnNm7xh1CDnsd/s/jaN
         5p6UaZo19gwWBQcpxasjbWTVqC8AN/hcmAK7p3NwTU5n3VgmtRwG531pvwLE1qOle5
         PDREenDaCFp5JgmRNmcIEgGrrSACyyoO2hTySvcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 100/147] gcc-10 warnings: fix low-hanging fruit
Date:   Mon, 18 May 2020 19:37:03 +0200
Message-Id: <20200518173525.881693591@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 include/linux/fs.h  |    2 +-
 include/linux/tty.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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


