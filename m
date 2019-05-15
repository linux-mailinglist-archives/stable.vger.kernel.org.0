Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 302D21F10A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731026AbfEOLTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:19:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728444AbfEOLTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:19:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB8A620862;
        Wed, 15 May 2019 11:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919193;
        bh=Ee8mM+gnRVtmIddSliWwiOhemwiP45Xe3su0PkhNLDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfIySBxT0ZNPXJJI+17ef1ZCap7oDwJvzqNFXFyYt90o8zoPk+Aa17cO13YYv6zAT
         4Yt091mkjn39kL7/ja+u3VcxE03NUpYoPq15qPJ0GqowaITZMgeNxrVMiEBth1MfvN
         TIXRwZKmQY7KU8oodeWExUjL3qdPiS3OFtgcRDlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 057/115] net: dont keep lonely packets forever in the gro hash
Date:   Wed, 15 May 2019 12:55:37 +0200
Message-Id: <20190515090703.721732360@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 605108acfe6233b72e2f803aa1cb59a2af3001ca ]

Eric noted that with UDP GRO and NAPI timeout, we could keep a single
UDP packet inside the GRO hash forever, if the related NAPI instance
calls napi_gro_complete() at an higher frequency than the NAPI timeout.
Willem noted that even TCP packets could be trapped there, till the
next retransmission.
This patch tries to address the issue, flushing the old packets -
those with a NAPI_GRO_CB age before the current jiffy - before scheduling
the NAPI timeout. The rationale is that such a timeout should be
well below a jiffy and we are not flushing packets eligible for sane GRO.

v1  -> v2:
 - clarified the commit message and comment

RFC -> v1:
 - added 'Fixes tags', cleaned-up the wording.

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Fixes: 3b47d30396ba ("net: gro: add a per device gro flush timer")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 net/core/dev.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 93a1b07990b8d..90ec30d5b8514 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5308,11 +5308,14 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 		if (work_done)
 			timeout = n->dev->gro_flush_timeout;
 
+		/* When the NAPI instance uses a timeout and keeps postponing
+		 * it, we need to bound somehow the time packets are kept in
+		 * the GRO layer
+		 */
+		napi_gro_flush(n, !!timeout);
 		if (timeout)
 			hrtimer_start(&n->timer, ns_to_ktime(timeout),
 				      HRTIMER_MODE_REL_PINNED);
-		else
-			napi_gro_flush(n, false);
 	}
 	if (unlikely(!list_empty(&n->poll_list))) {
 		/* If n->poll_list is not empty, we need to mask irqs */
-- 
2.20.1



