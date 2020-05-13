Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38761D0D51
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387722AbgEMJwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:52:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387727AbgEMJv7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:51:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DBEF206D6;
        Wed, 13 May 2020 09:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363518;
        bh=sNOdC6l34grf0tjzOwQiEk/LXwF/cadj8L/pHwWz5eY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hw2jQLeqY5Ds1/VEdUAzO2wxiqmhUeBvCFenrzG9+IPMMhgJm4bSgMGie9W1dyWlC
         7bbcOKY9d5LvGCNmkKeuG9a+G5D8zZSyBhtZxcmg8WKXz9VYLxA6E/gWNchx2H5XPc
         SY1zhu7ooY9wtpk1MUgelzU/Bfv7AejY982+N6SU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 017/118] fq_codel: fix TCA_FQ_CODEL_DROP_BATCH_SIZE sanity checks
Date:   Wed, 13 May 2020 11:43:56 +0200
Message-Id: <20200513094419.243485566@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 14695212d4cd8b0c997f6121b6df8520038ce076 ]

My intent was to not let users set a zero drop_batch_size,
it seems I once again messed with min()/max().

Fixes: 9d18562a2278 ("fq_codel: add batch ability to fq_codel_drop()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_fq_codel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -416,7 +416,7 @@ static int fq_codel_change(struct Qdisc
 		q->quantum = max(256U, nla_get_u32(tb[TCA_FQ_CODEL_QUANTUM]));
 
 	if (tb[TCA_FQ_CODEL_DROP_BATCH_SIZE])
-		q->drop_batch_size = min(1U, nla_get_u32(tb[TCA_FQ_CODEL_DROP_BATCH_SIZE]));
+		q->drop_batch_size = max(1U, nla_get_u32(tb[TCA_FQ_CODEL_DROP_BATCH_SIZE]));
 
 	if (tb[TCA_FQ_CODEL_MEMORY_LIMIT])
 		q->memory_limit = min(1U << 31, nla_get_u32(tb[TCA_FQ_CODEL_MEMORY_LIMIT]));


