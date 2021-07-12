Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3221B3C546B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344713AbhGLH6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348932AbhGLH4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:56:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7692F613C8;
        Mon, 12 Jul 2021 07:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076332;
        bh=Q24hn74DSG3DcYlvrFfEOEIsZ208c90wgAIS+AXHEcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ad/fUgSZ9fQvKnIFGAucU0wEY6KT2vFG0rZn9PoNV71V37LTouPbSWlR+sOWow2hW
         IOvP2bld1/h83rVanJg/a5T7Ictcgw7n4ozYaEIo0pGK+bS4EC3+X38g90ree361je
         NosiC2ViZkxtOfRaUQjbq/PEfIby5tSQ612gpSUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+1071ad60cd7df39fdadb@syzkaller.appspotmail.com
Subject: [PATCH 5.13 597/800] net: sched: fix warning in tcindex_alloc_perfect_hash
Date:   Mon, 12 Jul 2021 08:10:20 +0200
Message-Id: <20210712061030.840507349@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 3f2db250099f46988088800052cdf2332c7aba61 ]

Syzbot reported warning in tcindex_alloc_perfect_hash. The problem
was in too big cp->hash, which triggers warning in kmalloc. Since
cp->hash comes from userspace, there is no need to warn if value
is not correct

Fixes: b9a24bb76bf6 ("net_sched: properly handle failure case of tcf_exts_init()")
Reported-and-tested-by: syzbot+1071ad60cd7df39fdadb@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Acked-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_tcindex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index c4007b9cd16d..5b274534264c 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -304,7 +304,7 @@ static int tcindex_alloc_perfect_hash(struct net *net, struct tcindex_data *cp)
 	int i, err = 0;
 
 	cp->perfect = kcalloc(cp->hash, sizeof(struct tcindex_filter_result),
-			      GFP_KERNEL);
+			      GFP_KERNEL | __GFP_NOWARN);
 	if (!cp->perfect)
 		return -ENOMEM;
 
-- 
2.30.2



