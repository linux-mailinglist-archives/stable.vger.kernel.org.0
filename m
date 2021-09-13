Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E09E4095F1
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346273AbhIMOq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347761AbhIMOm3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:42:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 686F5619A6;
        Mon, 13 Sep 2021 13:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541411;
        bh=bF/ve4sBxRDM5n+vpRj1UJwgWtF09dYEUpq9sD7a2W8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rzbCcYk14vFjVLGEfbT3lygGrqyaCZYRvYRSUlQCg080BQpC5ALxkBY6yaWWEz10I
         /KY5Yf6qa460kst/7iYEA9eOiJ0NLgrzXaSvxMALZgnrewP/aTqQPZ8re/BM6DaI0O
         +7ol+1wUTId0cTobyDSvuUJuCC2xjVNUPJ+wNXIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 288/334] net: sched: Fix qdisc_rate_table refcount leak when get tcf_block failed
Date:   Mon, 13 Sep 2021 15:15:42 +0200
Message-Id: <20210913131123.171163811@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit c66070125837900163b81a03063ddd657a7e9bfb ]

The reference counting issue happens in one exception handling path of
cbq_change_class(). When failing to get tcf_block, the function forgets
to decrease the refcount of "rtab" increased by qdisc_put_rtab(),
causing a refcount leak.

Fix this issue by jumping to "failure" label when get tcf_block failed.

Fixes: 6529eaba33f0 ("net: sched: introduce tcf block infractructure")
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Link: https://lore.kernel.org/r/1630252681-71588-1-git-send-email-xiyuyang19@fudan.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cbq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index b79a7e27bb31..38a3a8394bbd 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1614,7 +1614,7 @@ cbq_change_class(struct Qdisc *sch, u32 classid, u32 parentid, struct nlattr **t
 	err = tcf_block_get(&cl->block, &cl->filter_list, sch, extack);
 	if (err) {
 		kfree(cl);
-		return err;
+		goto failure;
 	}
 
 	if (tca[TCA_RATE]) {
-- 
2.30.2



