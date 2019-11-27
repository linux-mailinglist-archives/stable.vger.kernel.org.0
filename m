Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5BCA10B908
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730208AbfK0UtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:49:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:34630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729599AbfK0UtI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:49:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE6C0217C3;
        Wed, 27 Nov 2019 20:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887748;
        bh=dP+PCoNwoOWfPuFe01TtS/TXqgxB3zZdYBB2ROF1FZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TkPkq7U1De0b7+0iaUZbya1FoHCkWlAKP21fUX3o0r1I2T4Yu8/Jk0JGIwTIJ+gG7
         SQaGXIMxT19p5mdQRHaRhFlYEsfHaQMhKHaYvx3Ow/twrzW1fh8I8tSgLWg2FuiWPZ
         aENB2yrLUP2tN+clv1tFFmbR0yYlTML/2l9li3XA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 078/211] mISDN: Fix type of switch control variable in ctrl_teimanager
Date:   Wed, 27 Nov 2019 21:30:11 +0100
Message-Id: <20191127203101.188989333@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit aeb5e02aca91522733eb1db595ac607d30c87767 ]

Clang warns (trimmed for brevity):

drivers/isdn/mISDN/tei.c:1193:7: warning: overflow converting case value
to switch condition type (2147764552 to 18446744071562348872) [-Wswitch]
        case IMHOLD_L1:
             ^
drivers/isdn/mISDN/tei.c:1187:7: warning: overflow converting case value
to switch condition type (2147764550 to 18446744071562348870) [-Wswitch]
        case IMCLEAR_L2:
             ^
2 warnings generated.

The root cause is that the _IOC macro can generate really large numbers,
which don't find into type int. My research into how GCC and Clang are
handling this at a low level didn't prove fruitful and surveying the
kernel tree shows that aside from here and a few places in the scsi
subsystem, everything that uses _IOC is at least of type 'unsigned int'.
Make that change here because as nothing in this function cares about
the signedness of the variable and it removes ambiguity, which is never
good when dealing with compilers.

While we're here, remove the unnecessary local variable ret (just return
-EINVAL and 0 directly).

Link: https://github.com/ClangBuiltLinux/linux/issues/67
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/mISDN/tei.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/mISDN/tei.c b/drivers/isdn/mISDN/tei.c
index 12d9e5f4beb1f..58635b5f296f0 100644
--- a/drivers/isdn/mISDN/tei.c
+++ b/drivers/isdn/mISDN/tei.c
@@ -1180,8 +1180,7 @@ static int
 ctrl_teimanager(struct manager *mgr, void *arg)
 {
 	/* currently we only have one option */
-	int	*val = (int *)arg;
-	int	ret = 0;
+	unsigned int *val = (unsigned int *)arg;
 
 	switch (val[0]) {
 	case IMCLEAR_L2:
@@ -1197,9 +1196,9 @@ ctrl_teimanager(struct manager *mgr, void *arg)
 			test_and_clear_bit(OPTION_L1_HOLD, &mgr->options);
 		break;
 	default:
-		ret = -EINVAL;
+		return -EINVAL;
 	}
-	return ret;
+	return 0;
 }
 
 /* This function does create a L2 for fixed TEI in NT Mode */
-- 
2.20.1



