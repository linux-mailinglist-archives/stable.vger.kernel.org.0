Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FA8411FD7
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345812AbhITRqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353192AbhITRoH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:44:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBC9561B96;
        Mon, 20 Sep 2021 17:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157772;
        bh=nEeG0PuNY9HGJQDDbcpqwuUiiLVyOFTeNieVCtb0RKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d4v08htxxBFzDG4ZoRmV5Mp9kTVsTDsuHWkYNHPyY4ZT3qeWfMFRNvbN/y7QWgwzh
         hC9OvtbHMDXJ16wj7ndkWmslFyzLIMPaXGGVK0MzRVQtua3tZkU/PitYXEpux3JTsK
         O6WIbE+BaSoa6SMUeCCRp/y8HayBatdtAP+JxT10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 102/293] net: sched: Fix qdisc_rate_table refcount leak when get tcf_block failed
Date:   Mon, 20 Sep 2021 18:41:04 +0200
Message-Id: <20210920163936.752445327@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
index ebc3c8c7e666..bc62e1b24653 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1616,7 +1616,7 @@ cbq_change_class(struct Qdisc *sch, u32 classid, u32 parentid, struct nlattr **t
 	err = tcf_block_get(&cl->block, &cl->filter_list, sch, extack);
 	if (err) {
 		kfree(cl);
-		return err;
+		goto failure;
 	}
 
 	if (tca[TCA_RATE]) {
-- 
2.30.2



