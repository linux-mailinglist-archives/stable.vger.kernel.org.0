Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C361CAECD
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbgEHMsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:48:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729012AbgEHMsE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:48:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C0D1221F7;
        Fri,  8 May 2020 12:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942083;
        bh=qzYNDhtpLuwueXHwvbGyvraMwYzkwZnlwdpOq893pAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ACcwdd9aPbyEU0tZMo+ShQiOFEaUlBP1Qu1HkwelWJoCGV7WDAupTvvyooU9rvedV
         bkoTJuR4fCdlFloKqao7/mkAL6EDd5E1MVXXq3eNR3exBE80qfSlPWMSjIDu8/OtU5
         f9hVwOoDffg0W+db/KhpZDveUFaI6TQyyW5USb6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 273/312] qdisc: fix a module refcount leak in qdisc_create_dflt()
Date:   Fri,  8 May 2020 14:34:24 +0200
Message-Id: <20200508123143.633410338@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 166ee5b87866de07a3e56c1b757f2b5cabba72a5 upstream.

Should qdisc_alloc() fail, we must release the module refcount
we got right before.

Fixes: 6da7c8fcbcbd ("qdisc: allow setting default queuing discipline")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: John Fastabend <john.r.fastabend@intel.com>
Acked-by: John Fastabend <john.r.fastabend@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sched/sch_generic.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -626,18 +626,19 @@ struct Qdisc *qdisc_create_dflt(struct n
 	struct Qdisc *sch;
 
 	if (!try_module_get(ops->owner))
-		goto errout;
+		return NULL;
 
 	sch = qdisc_alloc(dev_queue, ops);
-	if (IS_ERR(sch))
-		goto errout;
+	if (IS_ERR(sch)) {
+		module_put(ops->owner);
+		return NULL;
+	}
 	sch->parent = parentid;
 
 	if (!ops->init || ops->init(sch, NULL) == 0)
 		return sch;
 
 	qdisc_destroy(sch);
-errout:
 	return NULL;
 }
 EXPORT_SYMBOL(qdisc_create_dflt);


