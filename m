Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE8F3C4EDE
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241640AbhGLHWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:22:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343967AbhGLHUO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:20:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F20261166;
        Mon, 12 Jul 2021 07:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074246;
        bh=Q24hn74DSG3DcYlvrFfEOEIsZ208c90wgAIS+AXHEcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dehXqkpfER3ywkRLYJlvtxPSojZmRXpp/Fr+4mWNocH5FqESBMQ8fX3E1PEcTeFnv
         O9ibsGRA5jxseT9JYEoVnY+dAdcN2mmeKKyG7sQ0jIc4PWd/R785Gx0xhMXr5sTiI+
         xlT0b5/XmCJEkN+QCFw8KHR2kyaDeYifGma3laOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+1071ad60cd7df39fdadb@syzkaller.appspotmail.com
Subject: [PATCH 5.12 514/700] net: sched: fix warning in tcindex_alloc_perfect_hash
Date:   Mon, 12 Jul 2021 08:09:57 +0200
Message-Id: <20210712061031.219924821@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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



