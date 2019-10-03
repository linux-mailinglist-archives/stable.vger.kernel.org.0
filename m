Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4EACA2D3
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732371AbfJCQJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:09:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387480AbfJCQJi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:09:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DA06215EA;
        Thu,  3 Oct 2019 16:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118977;
        bh=OO6n8+8fpvuQYORdso34RDWt5h1ChvIzr+09+4h4/0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6ybbV1FC64JLJbnhPzIRzfuEReByzHwebYnOQdGT6ZJXKPyDAkhO1RZ3SzdWPvxE
         99m2jXMCxnF7X7rK9O5YXLHoXMQlVXdjP7uMfPVZBmHhOvQPmUDrUfrOzDp3w+SL9m
         pGORsK3i1Q1sglFYWF8O5NS0nmceWhanbIsdLvOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 4.14 043/185] sch_netem: fix a divide by zero in tabledist()
Date:   Thu,  3 Oct 2019 17:52:01 +0200
Message-Id: <20191003154447.588828756@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b41d936b5ecfdb3a4abc525ce6402a6c49cffddc ]

syzbot managed to crash the kernel in tabledist() loading
an empty distribution table.

	t = dist->table[rnd % dist->size];

Simply return an error when such load is attempted.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_netem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -708,7 +708,7 @@ static int get_dist_table(struct Qdisc *
 	struct disttable *d;
 	int i;
 
-	if (n > NETEM_DIST_MAX)
+	if (!n || n > NETEM_DIST_MAX)
 		return -EINVAL;
 
 	d = kvmalloc(sizeof(struct disttable) + n * sizeof(s16), GFP_KERNEL);


