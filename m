Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7367E499504
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392041AbiAXUuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389562AbiAXUmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:42:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7A4C049643;
        Mon, 24 Jan 2022 11:52:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 784E3B81215;
        Mon, 24 Jan 2022 19:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7A7C340E8;
        Mon, 24 Jan 2022 19:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053942;
        bh=/3IpXYpDHqc7BIxJtkGrqj2x3uRCAnMnROnnR4zFBgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OY+j4eEPI+J48eKsaaid91stx+CxgB5nGKjeW2dZXDQAUkXkJ/4CWIc/+uAYpJwZv
         q9Kvh2H6k4rOkkVP0Xaumro7ea+c9DoyY4QNvuwm3lOXrh0VJCupGiEvcbLI5tnFCH
         E2NbqFbA3Hv0ae00FQHiKTgKk635lrUe/kdnad5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 228/563] netrom: fix api breakage in nr_setsockopt()
Date:   Mon, 24 Jan 2022 19:39:53 +0100
Message-Id: <20220124184032.330706563@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit dc35616e6c2907b0c0c391a205802d8880f7fd85 ]

This needs to copy an unsigned int from user space instead of a long to
avoid breaking user space with an API change.

I have updated all the integer overflow checks from ULONG to UINT as
well.  This is a slight API change but I do not expect it to affect
anything in real life.

Fixes: 3087a6f36ee0 ("netrom: fix copying in user data in nr_setsockopt")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/af_netrom.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index eef0e3f2f25b0..e5c8a295e6406 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -298,7 +298,7 @@ static int nr_setsockopt(struct socket *sock, int level, int optname,
 {
 	struct sock *sk = sock->sk;
 	struct nr_sock *nr = nr_sk(sk);
-	unsigned long opt;
+	unsigned int opt;
 
 	if (level != SOL_NETROM)
 		return -ENOPROTOOPT;
@@ -306,18 +306,18 @@ static int nr_setsockopt(struct socket *sock, int level, int optname,
 	if (optlen < sizeof(unsigned int))
 		return -EINVAL;
 
-	if (copy_from_sockptr(&opt, optval, sizeof(unsigned long)))
+	if (copy_from_sockptr(&opt, optval, sizeof(opt)))
 		return -EFAULT;
 
 	switch (optname) {
 	case NETROM_T1:
-		if (opt < 1 || opt > ULONG_MAX / HZ)
+		if (opt < 1 || opt > UINT_MAX / HZ)
 			return -EINVAL;
 		nr->t1 = opt * HZ;
 		return 0;
 
 	case NETROM_T2:
-		if (opt < 1 || opt > ULONG_MAX / HZ)
+		if (opt < 1 || opt > UINT_MAX / HZ)
 			return -EINVAL;
 		nr->t2 = opt * HZ;
 		return 0;
@@ -329,13 +329,13 @@ static int nr_setsockopt(struct socket *sock, int level, int optname,
 		return 0;
 
 	case NETROM_T4:
-		if (opt < 1 || opt > ULONG_MAX / HZ)
+		if (opt < 1 || opt > UINT_MAX / HZ)
 			return -EINVAL;
 		nr->t4 = opt * HZ;
 		return 0;
 
 	case NETROM_IDLE:
-		if (opt > ULONG_MAX / (60 * HZ))
+		if (opt > UINT_MAX / (60 * HZ))
 			return -EINVAL;
 		nr->idle = opt * 60 * HZ;
 		return 0;
-- 
2.34.1



