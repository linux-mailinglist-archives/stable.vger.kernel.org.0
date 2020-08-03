Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19BAE23A612
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbgHCM2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:28:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728721AbgHCM2R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:28:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EB6C204EC;
        Mon,  3 Aug 2020 12:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457696;
        bh=O2w5XOrGmoO7+E7a5f/p6umyxLNs3y72uVcyQgAU7tI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=urCsMy8IoM0mgKbeGFKJWoXYFn8PpMsIfz4tj2Gw9WG5g6jxV3j+uy0M8S9ICPqQg
         91zjiWkw+c4Ar1IRyeQ2PYp8b1XhEXPtKxqRr8MYpI/ZuGJb6HRgQg2RPXzRdH0+Tu
         O4vX1PWa/gEXOd0HyMs7Gq6J4XdIWgntMNn2Whqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tanner Love <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 42/90] selftests/net: so_txtime: fix clang issues for target arch PowerPC
Date:   Mon,  3 Aug 2020 14:19:04 +0200
Message-Id: <20200803121859.660789314@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

[ Upstream commit b4da96ffd30bd4a305045ba5c9b0de5d4aa20dc7 ]

On powerpcle, int64_t maps to long long. Clang 9 threw:
warning: absolute value function 'labs' given an argument of type \
'long long' but has parameter of type 'long' which may cause \
truncation of value [-Wabsolute-value]
        if (labs(tstop - texpect) > cfg_variance_us)

Tested: make -C tools/testing/selftests TARGETS="net" run_tests

Fixes: af5136f95045 ("selftests/net: SO_TXTIME with ETF and FQ")
Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/so_txtime.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/so_txtime.c b/tools/testing/selftests/net/so_txtime.c
index ceaad78e96674..3155fbbf644b0 100644
--- a/tools/testing/selftests/net/so_txtime.c
+++ b/tools/testing/selftests/net/so_txtime.c
@@ -121,7 +121,7 @@ static bool do_recv_one(int fdr, struct timed_send *ts)
 	if (rbuf[0] != ts->data)
 		error(1, 0, "payload mismatch. expected %c", ts->data);
 
-	if (labs(tstop - texpect) > cfg_variance_us)
+	if (llabs(tstop - texpect) > cfg_variance_us)
 		error(1, 0, "exceeds variance (%d us)", cfg_variance_us);
 
 	return false;
-- 
2.25.1



