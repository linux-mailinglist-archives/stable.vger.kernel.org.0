Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFAD2D0498
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbgLFLra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:47:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:42336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729083AbgLFLnG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:43:06 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 28/39] chelsio/chtls: fix a double free in chtls_setkey()
Date:   Sun,  6 Dec 2020 12:17:32 +0100
Message-Id: <20201206111556.034502192@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111554.677764505@linuxfoundation.org>
References: <20201206111554.677764505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 391119fb5c5c4bdb4d57c7ffeb5e8d18560783d1 ]

The "skb" is freed by the transmit code in cxgb4_ofld_send() and we
shouldn't use it again.  But in the current code, if we hit an error
later on in the function then the clean up code will call kfree_skb(skb)
and so it causes a double free.

Set the "skb" to NULL and that makes the kfree_skb() a no-op.

Fixes: d25f2f71f653 ("crypto: chtls - Program the TLS session Key")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/X8ilb6PtBRLWiSHp@mwanda
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/chelsio/chtls/chtls_hw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/crypto/chelsio/chtls/chtls_hw.c
+++ b/drivers/crypto/chelsio/chtls/chtls_hw.c
@@ -365,6 +365,7 @@ int chtls_setkey(struct chtls_sock *csk,
 	csk->wr_unacked += DIV_ROUND_UP(len, 16);
 	enqueue_wr(csk, skb);
 	cxgb4_ofld_send(csk->egress_dev, skb);
+	skb = NULL;
 
 	chtls_set_scmd(csk);
 	/* Clear quiesce for Rx key */


