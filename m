Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B131F4999B4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455173AbiAXVey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:34:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33918 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359768AbiAXVOW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:14:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F321B81243;
        Mon, 24 Jan 2022 21:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C2EC340E5;
        Mon, 24 Jan 2022 21:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058859;
        bh=tLYKVPrk6SwB3glulpE2TPmStGQfWvn/PQr44b2j16Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgYw4whTmsFkoXqPi68o5le/aGQDK8lgnUovxt8I0eFjad64kU411GHnRDMJAeIcs
         USMoNVVHIFGVyvgPZiLtlj05pUVgbBSV6/nv9ILYgiPbYKO0vyHJucX0qGvEGDadjm
         B6uxRc0iVH6x/2Pt9HLunhsCTRsdTqKGi/sxzWAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0425/1039] ax25: uninitialized variable in ax25_setsockopt()
Date:   Mon, 24 Jan 2022 19:36:54 +0100
Message-Id: <20220124184139.589701660@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 9371937092d5fd502032c1bb4475b36b39b1f1b3 ]

The "opt" variable is unsigned long but we only copy 4 bytes from
the user so the lower 4 bytes are uninitialized.

I have changed the integer overflow checks from ULONG to UINT as well.
This is a slight API change but I don't expect it to break anything.

Fixes: a7b75c5a8c41 ("net: pass a sockptr_t into ->setsockopt")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/af_ax25.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index cfca99e295b80..02f43f3e2c564 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -536,7 +536,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 	ax25_cb *ax25;
 	struct net_device *dev;
 	char devname[IFNAMSIZ];
-	unsigned long opt;
+	unsigned int opt;
 	int res = 0;
 
 	if (level != SOL_AX25)
@@ -568,7 +568,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case AX25_T1:
-		if (opt < 1 || opt > ULONG_MAX / HZ) {
+		if (opt < 1 || opt > UINT_MAX / HZ) {
 			res = -EINVAL;
 			break;
 		}
@@ -577,7 +577,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case AX25_T2:
-		if (opt < 1 || opt > ULONG_MAX / HZ) {
+		if (opt < 1 || opt > UINT_MAX / HZ) {
 			res = -EINVAL;
 			break;
 		}
@@ -593,7 +593,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case AX25_T3:
-		if (opt < 1 || opt > ULONG_MAX / HZ) {
+		if (opt < 1 || opt > UINT_MAX / HZ) {
 			res = -EINVAL;
 			break;
 		}
@@ -601,7 +601,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case AX25_IDLE:
-		if (opt > ULONG_MAX / (60 * HZ)) {
+		if (opt > UINT_MAX / (60 * HZ)) {
 			res = -EINVAL;
 			break;
 		}
-- 
2.34.1



