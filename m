Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37A2411D6B
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346820AbhITRUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:20:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244438AbhITRSO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:18:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AB4D61A3D;
        Mon, 20 Sep 2021 16:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157174;
        bh=uuqizSbzMpp9Wd33HAgx5Zj6eQ6QxDTAavxfbPzHC7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hiI0BeCcgjlZhFNbaBhwIkAXGVgXR86WXJRsJbUEUcrl8Spq3QZNmIauzpFitxT61
         caXdrucHSxrniEg+AYJ0OADJltNubJ06gqTQk8TQTUmoMDSCs1kAXpy/m9ZgJ45z8N
         Hg2eL0lYqoKQntnrN9vL12pxYgbaXMxC3mN4ELjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 088/217] net: sched: Fix qdisc_rate_table refcount leak when get tcf_block failed
Date:   Mon, 20 Sep 2021 18:41:49 +0200
Message-Id: <20210920163927.618867709@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
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
index 40fd1ee0095c..dea125d8aac7 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1590,7 +1590,7 @@ cbq_change_class(struct Qdisc *sch, u32 classid, u32 parentid, struct nlattr **t
 	err = tcf_block_get(&cl->block, &cl->filter_list);
 	if (err) {
 		kfree(cl);
-		return err;
+		goto failure;
 	}
 
 	if (tca[TCA_RATE]) {
-- 
2.30.2



