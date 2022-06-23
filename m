Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD5D5582EB
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbiFWRWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233484AbiFWRVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:21:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F125E5DF0B;
        Thu, 23 Jun 2022 10:00:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12A4160AE7;
        Thu, 23 Jun 2022 17:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFCBC3411B;
        Thu, 23 Jun 2022 17:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003654;
        bh=kPlZZ9a9Wz57sT9wKbJqOmP7eI5gmkiDEIk0/eNfpTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xarK8kkIHHWfDhQU+PaHIdJzwREPM430mhDrP0Shl3Dm5A+NjGglxNkhb+DpJ6A3t
         xDqCN3KRgS4SmlzELlVAxjyocKd1VkYkkAD7Zj0Yr95SqYw4JFZdzmu4O8nyzgalst
         5B1jKXdVzA8Ndckt7VS6zsbudjINKRKv7lVPuzXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        "Tobin C. Harding" <me@tobin.cc>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 007/237] random: Return nbytes filled from hw RNG
Date:   Thu, 23 Jun 2022 18:40:41 +0200
Message-Id: <20220623164343.358191767@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Tobin C. Harding" <me@tobin.cc>

commit 753d433b586d1d43c487e3d660f5778c7c8d58ea upstream.

Currently the function get_random_bytes_arch() has return value 'void'.
If the hw RNG fails we currently fall back to using get_random_bytes().
This defeats the purpose of requesting random material from the hw RNG
in the first place.

There are currently no intree users of get_random_bytes_arch().

Only get random bytes from the hw RNG, make function return the number
of bytes retrieved from the hw RNG.

Acked-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Tobin C. Harding <me@tobin.cc>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c  |   16 +++++++++-------
 include/linux/random.h |    2 +-
 2 files changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1730,26 +1730,28 @@ EXPORT_SYMBOL(del_random_ready_callback)
  * key known by the NSA).  So it's useful if we need the speed, but
  * only if we're willing to trust the hardware manufacturer not to
  * have put in a back door.
+ *
+ * Return number of bytes filled in.
  */
-void get_random_bytes_arch(void *buf, int nbytes)
+int __must_check get_random_bytes_arch(void *buf, int nbytes)
 {
+	int left = nbytes;
 	char *p = buf;
 
-	trace_get_random_bytes_arch(nbytes, _RET_IP_);
-	while (nbytes) {
+	trace_get_random_bytes_arch(left, _RET_IP_);
+	while (left) {
 		unsigned long v;
-		int chunk = min(nbytes, (int)sizeof(unsigned long));
+		int chunk = min_t(int, left, sizeof(unsigned long));
 
 		if (!arch_get_random_long(&v))
 			break;
 
 		memcpy(p, &v, chunk);
 		p += chunk;
-		nbytes -= chunk;
+		left -= chunk;
 	}
 
-	if (nbytes)
-		get_random_bytes(p, nbytes);
+	return nbytes - left;
 }
 EXPORT_SYMBOL(get_random_bytes_arch);
 
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -38,7 +38,7 @@ extern void get_random_bytes(void *buf,
 extern int wait_for_random_bytes(void);
 extern int add_random_ready_callback(struct random_ready_callback *rdy);
 extern void del_random_ready_callback(struct random_ready_callback *rdy);
-extern void get_random_bytes_arch(void *buf, int nbytes);
+extern int __must_check get_random_bytes_arch(void *buf, int nbytes);
 
 #ifndef MODULE
 extern const struct file_operations random_fops, urandom_fops;


