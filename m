Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31147681084
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236963AbjA3OEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:04:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236990AbjA3OEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:04:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFC110414
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:03:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83EDDB81132
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42DFC433EF;
        Mon, 30 Jan 2023 14:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087436;
        bh=kPGzsg3iak9bUhKpj7DoiBI4rzmGDwMtLp3JfFiEzvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ycwKo0Mbd83eqiRvdnURM04gruB1pfrpJZ6gg5OpDDt5uGo7185An2b7Mc8GNwt77
         rwM5HM3fTRPCw4wiAsN0VvS8IBdphW+716GqPWsACvhOEgixikgb1Jyssrqjh8aPb+
         0peIs5mVxnJzz3hXTdHnRQjl5epxSEpUzJjPtkB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sven Schnelle <svens@linux.ibm.com>,
        Willy Tarreau <w@1wt.eu>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/313] nolibc: fix fd_set type
Date:   Mon, 30 Jan 2023 14:50:01 +0100
Message-Id: <20230130134344.396762979@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit feaf75658783a919410f8c2039dbc24b6a29603d ]

The kernel uses unsigned long for the fd_set bitmap,
but nolibc use u32. This works fine on little endian
machines, but fails on big endian. Convert to unsigned
long to fix this.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/types.h | 53 ++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/tools/include/nolibc/types.h b/tools/include/nolibc/types.h
index 959997034e55..300e0ff1cd58 100644
--- a/tools/include/nolibc/types.h
+++ b/tools/include/nolibc/types.h
@@ -89,39 +89,46 @@
 #define EXIT_SUCCESS 0
 #define EXIT_FAILURE 1
 
+#define FD_SETIDXMASK (8 * sizeof(unsigned long))
+#define FD_SETBITMASK (8 * sizeof(unsigned long)-1)
+
 /* for select() */
 typedef struct {
-	uint32_t fd32[(FD_SETSIZE + 31) / 32];
+	unsigned long fds[(FD_SETSIZE + FD_SETBITMASK) / FD_SETIDXMASK];
 } fd_set;
 
-#define FD_CLR(fd, set) do {                                            \
-		fd_set *__set = (set);                                  \
-		int __fd = (fd);                                        \
-		if (__fd >= 0)                                          \
-			__set->fd32[__fd / 32] &= ~(1U << (__fd & 31)); \
+#define FD_CLR(fd, set) do {						\
+		fd_set *__set = (set);					\
+		int __fd = (fd);					\
+		if (__fd >= 0)						\
+			__set->fds[__fd / FD_SETIDXMASK] &=		\
+				~(1U << (__fd & FX_SETBITMASK));	\
 	} while (0)
 
-#define FD_SET(fd, set) do {                                            \
-		fd_set *__set = (set);                                  \
-		int __fd = (fd);                                        \
-		if (__fd >= 0)                                          \
-			__set->fd32[__fd / 32] |= 1U << (__fd & 31);    \
+#define FD_SET(fd, set) do {						\
+		fd_set *__set = (set);					\
+		int __fd = (fd);					\
+		if (__fd >= 0)						\
+			__set->fds[__fd / FD_SETIDXMASK] |=		\
+				1 << (__fd & FD_SETBITMASK);		\
 	} while (0)
 
-#define FD_ISSET(fd, set) ({                                                  \
-		fd_set *__set = (set);                                        \
-		int __fd = (fd);                                              \
-		int __r = 0;                                                  \
-		if (__fd >= 0)                                                \
-			__r = !!(__set->fd32[__fd / 32] & 1U << (__fd & 31)); \
-		__r;                                                          \
+#define FD_ISSET(fd, set) ({						\
+			fd_set *__set = (set);				\
+			int __fd = (fd);				\
+		int __r = 0;						\
+		if (__fd >= 0)						\
+			__r = !!(__set->fds[__fd / FD_SETIDXMASK] &	\
+1U << (__fd & FD_SET_BITMASK));						\
+		__r;							\
 	})
 
-#define FD_ZERO(set) do {                                               \
-		fd_set *__set = (set);                                  \
-		int __idx;                                              \
-		for (__idx = 0; __idx < (FD_SETSIZE+31) / 32; __idx ++) \
-			__set->fd32[__idx] = 0;                         \
+#define FD_ZERO(set) do {						\
+		fd_set *__set = (set);					\
+		int __idx;						\
+		int __size = (FD_SETSIZE+FD_SETBITMASK) / FD_SETIDXMASK;\
+		for (__idx = 0; __idx < __size; __idx++)		\
+			__set->fds[__idx] = 0;				\
 	} while (0)
 
 /* for poll() */
-- 
2.39.0



