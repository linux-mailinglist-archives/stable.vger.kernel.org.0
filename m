Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D5D2ABA31
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387500AbgKINQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:16:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:43692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387496AbgKINQi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:16:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 648B72076E;
        Mon,  9 Nov 2020 13:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927798;
        bh=2zJ8pFAXs/tRWwDIP8K9Qx5nwYx89H39UzjoXXI7HkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mqe7fQ1ll6A+4gmig0hRflLK+mXyB5+Xs3nOoRvUtVeLKWIe2/JgoQriWMUHlY+Dt
         OORGG8kk6vDC88MQ4/l11f1NR51WJCXJW/KjjXamqm+CndS69HoPBE4IQl5ShXmalM
         xS7R2rxq14HrAXMeO7EHu9l/WKXqa3dczfhCDfzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 024/133] chelsio/chtls: fix memory leaks caused by a race
Date:   Mon,  9 Nov 2020 13:54:46 +0100
Message-Id: <20201109125031.883324002@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

[ Upstream commit 8080b462b6aa856ae05ea010441a702599e579f2 ]

race between user context and softirq causing memleak,
consider the call sequence scenario

chtls_setkey()         //user context
chtls_peer_close()
chtls_abort_req_rss()
chtls_setkey()         //user context

work request skb queued in chtls_setkey() won't be freed
because resources are already cleaned for this connection,
fix it by not queuing work request while socket is closing.

v1->v2:
- fix W=1 warning.

v2->v3:
- separate it out from another memleak fix.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Link: https://lore.kernel.org/r/20201102173650.24754-1-vinay.yadav@chelsio.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/chelsio/chtls/chtls_hw.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/crypto/chelsio/chtls/chtls_hw.c
+++ b/drivers/crypto/chelsio/chtls/chtls_hw.c
@@ -383,6 +383,9 @@ int chtls_setkey(struct chtls_sock *csk,
 	if (ret)
 		goto out_notcb;
 
+	if (unlikely(csk_flag(sk, CSK_ABORT_SHUTDOWN)))
+		goto out_notcb;
+
 	set_wr_txq(skb, CPL_PRIORITY_DATA, csk->tlshws.txqid);
 	csk->wr_credits -= DIV_ROUND_UP(len, 16);
 	csk->wr_unacked += DIV_ROUND_UP(len, 16);


