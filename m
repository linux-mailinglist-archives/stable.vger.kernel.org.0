Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A0C499B3A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574857AbiAXVud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457278AbiAXVlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:41:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED253C07E310;
        Mon, 24 Jan 2022 12:27:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5DC8B8122C;
        Mon, 24 Jan 2022 20:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6754C340E5;
        Mon, 24 Jan 2022 20:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056049;
        bh=cmlALGkjNK42Z8u1KhLDnG6qNAUnb9R1aG9lI4gCzOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i+UElGqNByU3FTUHsggbkcja7edA/QFd2BSHjG3W4OqSwNLAYzF+orHosPBeRbEFo
         cGDdA29Wd94+kuZ8aSVkSjIFazB/gwNiESqhB33IJQr1rimHgDTxwD20sLDOtoX0XZ
         ib9Yp3XRNceKiH77XDhlbZijRKFOg07nX2/hsASc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 353/846] ax25: uninitialized variable in ax25_setsockopt()
Date:   Mon, 24 Jan 2022 19:37:50 +0100
Message-Id: <20220124184113.128174475@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index aa7785687e757..7473e0cc6d469 100644
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



