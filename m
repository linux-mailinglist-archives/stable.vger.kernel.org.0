Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFD7979949
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfG2T1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:27:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40227 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729929AbfG2T1h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:27:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C38DA217D4;
        Mon, 29 Jul 2019 19:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428456;
        bh=dZpLJQa/iNeL7/6UDAIQwxGQuAixpVJtkTlR0A7g43s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5v4VLbUzNRfJ9xXM/DBIYAGxEc91hO0s7oKZLpAPxk2DbzKmtTDnKCDuEd85pbGY
         yOr4Q9fB+FNO6K9Uh1tg0JEZQc1sEzPaOL6ZOWohPhylH10Ewp5oi9bAg6ai+3BGYu
         0aKKjOZ9rbAL8sRrOaA30o3LoQ5zMjkriB6Wf3NI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ferdinand Blomqvist <ferdinand.blomqvist@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 082/293] rslib: Fix decoding of shortened codes
Date:   Mon, 29 Jul 2019 21:19:33 +0200
Message-Id: <20190729190830.909403836@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2034a42d1747fc1e1eeef2c6f1789c4d0762cb9c ]

The decoding of shortenend codes is broken. It only works as expected if
there are no erasures.

When decoding with erasures, Lambda (the error and erasure locator
polynomial) is initialized from the given erasure positions. The pad
parameter is not accounted for by the initialisation code, and hence
Lambda is initialized from incorrect erasure positions.

The fix is to adjust the erasure positions by the supplied pad.

Signed-off-by: Ferdinand Blomqvist <ferdinand.blomqvist@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190620141039.9874-3-ferdinand.blomqvist@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/reed_solomon/decode_rs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/reed_solomon/decode_rs.c b/lib/reed_solomon/decode_rs.c
index 0ec3f257ffdf..8eed0f9ac495 100644
--- a/lib/reed_solomon/decode_rs.c
+++ b/lib/reed_solomon/decode_rs.c
@@ -99,9 +99,9 @@
 	if (no_eras > 0) {
 		/* Init lambda to be the erasure locator polynomial */
 		lambda[1] = alpha_to[rs_modnn(rs,
-					      prim * (nn - 1 - eras_pos[0]))];
+					prim * (nn - 1 - (eras_pos[0] + pad)))];
 		for (i = 1; i < no_eras; i++) {
-			u = rs_modnn(rs, prim * (nn - 1 - eras_pos[i]));
+			u = rs_modnn(rs, prim * (nn - 1 - (eras_pos[i] + pad)));
 			for (j = i + 1; j > 0; j--) {
 				tmp = index_of[lambda[j - 1]];
 				if (tmp != nn) {
-- 
2.20.1



