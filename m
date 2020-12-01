Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1202C9C56
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389912AbgLAJRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:17:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389929AbgLAJMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:12:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A988122210;
        Tue,  1 Dec 2020 09:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813889;
        bh=biJyByNtqt9R7tDM/ysdUIZVpLb/qN50NEwQCDriDsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ReQXtFLvZyK/2Qx0vtpnpTeTgNyk0kxhXr4Q767PiLUEV2+hVkyuv57RZJiAfQdqX
         Z9JWLTYCZ61ay2/VrEcFgxYHn0qMPfLCCFXHIqmUMthW1KLisvHm5wBtfibSsxe6ji
         mCaeNWWTqsE597nkuAgTwisDP4YSv9U4soG9xM/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 095/152] s390/qeth: make af_iucv TX notification call more robust
Date:   Tue,  1 Dec 2020 09:53:30 +0100
Message-Id: <20201201084724.313826228@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 34c7f50f7d0d36fa663c74aee39e25e912505320 ]

Calling into socket code is ugly already, at least check whether we are
dealing with the expected sk_family. Only looking at skb->protocol is
bound to cause troubles (consider eg. af_packet).

Fixes: b333293058aa ("qeth: add support for af_iucv HiperSockets transport")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 6a73982514237..f22e3653da52d 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -32,6 +32,7 @@
 
 #include <net/iucv/af_iucv.h>
 #include <net/dsfield.h>
+#include <net/sock.h>
 
 #include <asm/ebcdic.h>
 #include <asm/chpid.h>
@@ -1408,7 +1409,7 @@ static void qeth_notify_skbs(struct qeth_qdio_out_q *q,
 	skb_queue_walk(&buf->skb_list, skb) {
 		QETH_CARD_TEXT_(q->card, 5, "skbn%d", notification);
 		QETH_CARD_TEXT_(q->card, 5, "%lx", (long) skb);
-		if (skb->protocol == htons(ETH_P_AF_IUCV) && skb->sk)
+		if (skb->sk && skb->sk->sk_family == PF_IUCV)
 			iucv_sk(skb->sk)->sk_txnotify(skb, notification);
 	}
 }
-- 
2.27.0



