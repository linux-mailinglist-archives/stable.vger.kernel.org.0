Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39579558034
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbiFWQpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbiFWQpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:45:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFCD424B3;
        Thu, 23 Jun 2022 09:45:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EAC6B8248E;
        Thu, 23 Jun 2022 16:45:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836E7C3411B;
        Thu, 23 Jun 2022 16:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002742;
        bh=O57UOFnMIVWB7g3bS+d08y1t2IiJAE8DrycDUQreQco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JVH0CsOO/aKchTGO25ti8/B1EXuX9498db6iB5Y0HJWMdMhXTbiItJSb8SCqGtH+H
         GeOLjBvYdSYfJf3Hu/4PDvBD7WSoh8IAFCpEvwHnXi6QSptuGM1zO/juzPURh5wiPv
         wJKi2cqu6+6HgDAFBqxBLQZkx3yb6zBkE7+5V50Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.9 011/264] random: add get_random_{bytes,u32,u64,int,long,once}_wait family
Date:   Thu, 23 Jun 2022 18:40:04 +0200
Message-Id: <20220623164344.382397565@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit da9ba564bd683374b8d319756f312821b8265b06 upstream.

These functions are simple convenience wrappers that call
wait_for_random_bytes before calling the respective get_random_*
function.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/net.h    |    2 ++
 include/linux/once.h   |    2 ++
 include/linux/random.h |   25 +++++++++++++++++++++++++
 3 files changed, 29 insertions(+)

--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -274,6 +274,8 @@ do {									\
 
 #define net_get_random_once(buf, nbytes)			\
 	get_random_once((buf), (nbytes))
+#define net_get_random_once_wait(buf, nbytes)			\
+	get_random_once_wait((buf), (nbytes))
 
 int kernel_sendmsg(struct socket *sock, struct msghdr *msg, struct kvec *vec,
 		   size_t num, size_t len);
--- a/include/linux/once.h
+++ b/include/linux/once.h
@@ -53,5 +53,7 @@ void __do_once_done(bool *done, struct s
 
 #define get_random_once(buf, nbytes)					     \
 	DO_ONCE(get_random_bytes, (buf), (nbytes))
+#define get_random_once_wait(buf, nbytes)                                    \
+	DO_ONCE(get_random_bytes_wait, (buf), (nbytes))                      \
 
 #endif /* _LINUX_ONCE_H */
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -58,6 +58,31 @@ static inline unsigned long get_random_l
 #endif
 }
 
+/* Calls wait_for_random_bytes() and then calls get_random_bytes(buf, nbytes).
+ * Returns the result of the call to wait_for_random_bytes. */
+static inline int get_random_bytes_wait(void *buf, int nbytes)
+{
+	int ret = wait_for_random_bytes();
+	if (unlikely(ret))
+		return ret;
+	get_random_bytes(buf, nbytes);
+	return 0;
+}
+
+#define declare_get_random_var_wait(var) \
+	static inline int get_random_ ## var ## _wait(var *out) { \
+		int ret = wait_for_random_bytes(); \
+		if (unlikely(ret)) \
+			return ret; \
+		*out = get_random_ ## var(); \
+		return 0; \
+	}
+declare_get_random_var_wait(u32)
+declare_get_random_var_wait(u64)
+declare_get_random_var_wait(int)
+declare_get_random_var_wait(long)
+#undef declare_get_random_var
+
 unsigned long randomize_page(unsigned long start, unsigned long range);
 
 /*


