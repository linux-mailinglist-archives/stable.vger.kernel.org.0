Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41C8408D7B
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241609AbhIMN03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:26:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241638AbhIMNY2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:24:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 745DC61106;
        Mon, 13 Sep 2021 13:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539319;
        bh=n17HKYFjzrn4XSKPbrgytBJO2vlX44ZPTurK0So+cu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOzsFEVv6LNIfUvOkMDwTgLMAPLQYJqDai9kgpQylkdbcSz6U0G1Qgu+6kYh2rAAk
         alTxbDQEDSiTK15Koc3QMvLKrld0kECrOVHvFxFevzh45waffsq5ymFpaXQdT4R+iO
         LHl7KGieapRrA3JPd991/1Q0isH86sNTIvaQjjKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 123/144] net: sched: Fix qdisc_rate_table refcount leak when get tcf_block failed
Date:   Mon, 13 Sep 2021 15:15:04 +0200
Message-Id: <20210913131052.044146394@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
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
index 39b427dc7512..e5972889cd81 100644
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



