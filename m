Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFD62145065
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387713AbgAVJmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:42:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:34510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387748AbgAVJmg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:42:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 136BD24684;
        Wed, 22 Jan 2020 09:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686155;
        bh=0W1V3W8CggVjNQyaN/zVeXev/bVrx1JcSlDjkkeRYbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wXQnNJU7LBnMbSw1S5bAryuXl4DLs7f+3w1oxBTjGyspIMN4B6Mtge4r1VM9Ir/6q
         /8AYGHUqBZBZIhPBVCyuq3LjJkOG08fpsYZIa7sK7A2/2vHwc+X9avnUQJRmhZSabC
         k4hBwUClK2U+pTENKtxPC8nU/vV/sbG012iJ0yXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4c3cc6dbe7259dbf9054@syzkaller.appspotmail.com,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 059/103] netfilter: fix a use-after-free in mtype_destroy()
Date:   Wed, 22 Jan 2020 10:29:15 +0100
Message-Id: <20200122092812.841396727@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

commit c120959387efa51479056fd01dc90adfba7a590c upstream.

map->members is freed by ip_set_free() right before using it in
mtype_ext_cleanup() again. So we just have to move it down.

Reported-by: syzbot+4c3cc6dbe7259dbf9054@syzkaller.appspotmail.com
Fixes: 40cd63bf33b2 ("netfilter: ipset: Support extensions which need a per data destroy function")
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/ipset/ip_set_bitmap_gen.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -64,9 +64,9 @@ mtype_destroy(struct ip_set *set)
 	if (SET_WITH_TIMEOUT(set))
 		del_timer_sync(&map->gc);
 
-	ip_set_free(map->members);
 	if (set->dsize && set->extensions & IPSET_EXT_DESTROY)
 		mtype_ext_cleanup(set);
+	ip_set_free(map->members);
 	ip_set_free(map);
 
 	set->data = NULL;


