Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E149018B5DF
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730172AbgCSNWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:22:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730167AbgCSNWM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:22:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAB4E214D8;
        Thu, 19 Mar 2020 13:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624132;
        bh=9uebQZjFeWi3MCS3tSW9iUkH5yUcXXi5PjERCzdWf7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kDyvQllK8mQ6ljb+dwLjKTG6hyyOtlhzR8DNSXGHLAff9P0BUYCKZ6lf2zzPm2JpX
         EvZ7Ayblwh+TpTHQP/gW7eLhF7bGbTqrZbqawSce+EmJFHGyqr/j2WDfHIkkI0T2z3
         QIcciO1UdQKf+hsE+Y71AgZJphKvY+NniaMj6OCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+d195fd3b9a364ddd6731@syzkaller.appspotmail.com
Subject: [PATCH 5.4 02/60] netfilter: xt_hashlimit: unregister proc file before releasing mutex
Date:   Thu, 19 Mar 2020 14:03:40 +0100
Message-Id: <20200319123920.060062051@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 99b79c3900d4627672c85d9f344b5b0f06bc2a4d ]

Before releasing the global mutex, we only unlink the hashtable
from the hash list, its proc file is still not unregistered at
this point. So syzbot could trigger a race condition where a
parallel htable_create() could register the same file immediately
after the mutex is released.

Move htable_remove_proc_entry() back to mutex protection to
fix this. And, fold htable_destroy() into htable_put() to make
the code slightly easier to understand.

Reported-and-tested-by: syzbot+d195fd3b9a364ddd6731@syzkaller.appspotmail.com
Fixes: c4a3922d2d20 ("netfilter: xt_hashlimit: reduce hashlimit_mutex scope for htable_put()")
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_hashlimit.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 7a2c4b8408c49..8c835ad637290 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -402,15 +402,6 @@ static void htable_remove_proc_entry(struct xt_hashlimit_htable *hinfo)
 		remove_proc_entry(hinfo->name, parent);
 }
 
-static void htable_destroy(struct xt_hashlimit_htable *hinfo)
-{
-	cancel_delayed_work_sync(&hinfo->gc_work);
-	htable_remove_proc_entry(hinfo);
-	htable_selective_cleanup(hinfo, true);
-	kfree(hinfo->name);
-	vfree(hinfo);
-}
-
 static struct xt_hashlimit_htable *htable_find_get(struct net *net,
 						   const char *name,
 						   u_int8_t family)
@@ -432,8 +423,13 @@ static void htable_put(struct xt_hashlimit_htable *hinfo)
 {
 	if (refcount_dec_and_mutex_lock(&hinfo->use, &hashlimit_mutex)) {
 		hlist_del(&hinfo->node);
+		htable_remove_proc_entry(hinfo);
 		mutex_unlock(&hashlimit_mutex);
-		htable_destroy(hinfo);
+
+		cancel_delayed_work_sync(&hinfo->gc_work);
+		htable_selective_cleanup(hinfo, true);
+		kfree(hinfo->name);
+		vfree(hinfo);
 	}
 }
 
-- 
2.20.1



