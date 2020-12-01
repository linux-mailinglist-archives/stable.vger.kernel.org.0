Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753FD2C9CE5
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387768AbgLAJFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:05:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:41456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389051AbgLAJFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:05:03 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9F2520671;
        Tue,  1 Dec 2020 09:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813488;
        bh=SlirlzYcBTk8viTHCH1ZEvq3y4PRpTurTNZjdSESbhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MlT32oOP6sX9t09V7em1qGsBBfGK7hlXgGivQVq0nG4MixKO6rz1d2iBDdjHx/PLu
         ROVdZcE/XWRCNYt4gDekkGVaCcqtSuOeYUoMvtovZi8TeqRnKTKkhT9gqzvBF/nDaG
         FWXA2bXUYGOHlp19PapqxmQ+Ff0zmWpaZnlg8RQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 55/98] s390/qeth: make af_iucv TX notification call more robust
Date:   Tue,  1 Dec 2020 09:53:32 +0100
Message-Id: <20201201084657.792157024@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
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
index 5043f0fcf399a..6a2ac575e0a39 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -31,6 +31,7 @@
 
 #include <net/iucv/af_iucv.h>
 #include <net/dsfield.h>
+#include <net/sock.h>
 
 #include <asm/ebcdic.h>
 #include <asm/chpid.h>
@@ -1083,7 +1084,7 @@ static void qeth_notify_skbs(struct qeth_qdio_out_q *q,
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



