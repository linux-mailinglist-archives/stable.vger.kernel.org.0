Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1093CDAFA
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244307AbhGSOke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343539AbhGSOja (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:39:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8073611CE;
        Mon, 19 Jul 2021 15:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707940;
        bh=Xig838R7qfc3NVGddFFVfGWgtkES/pd2dEx2YcMiClA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gwe0qLKdnZWN5Bq6148fHvtja/HCU0WEUTVLUfdaGfTrxMfLBLHo6pPfD3fVX2NO4
         +inbx4Xi2GiAr3U0LpzWxni37CmSk0gIc/XPFHbG2NUeTNUbV3DsVjtSCiQ15Pi7lh
         hQ7fI9sw8zqILHNVe0FkloMZQyEeADO+KwrXHmtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+1071ad60cd7df39fdadb@syzkaller.appspotmail.com
Subject: [PATCH 4.14 117/315] net: sched: fix warning in tcindex_alloc_perfect_hash
Date:   Mon, 19 Jul 2021 16:50:06 +0200
Message-Id: <20210719144946.719624654@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
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
index 5b119efb20ee..9314a739c170 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -297,7 +297,7 @@ static int tcindex_alloc_perfect_hash(struct tcindex_data *cp)
 	int i, err = 0;
 
 	cp->perfect = kcalloc(cp->hash, sizeof(struct tcindex_filter_result),
-			      GFP_KERNEL);
+			      GFP_KERNEL | __GFP_NOWARN);
 	if (!cp->perfect)
 		return -ENOMEM;
 
-- 
2.30.2



