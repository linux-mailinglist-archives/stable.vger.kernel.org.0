Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72D2B99A21
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730899AbfHVRKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:10:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390743AbfHVRJW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:22 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82795233FC;
        Thu, 22 Aug 2019 17:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493761;
        bh=eGhOCkG3h8+cooPbmp5urxtxkVCRzGEQPvOlqq6G53E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnw5Zmze7jfCSpwBpuxuXwB++ZHpODW/O5vG4pIsIIDEofEO9PIi3/fmWnouH2gwn
         FOQ8q7rum4ie5ccsInT45GkE3xmuINEcPPGjiFS4+x5IOKjuZsCLnsmObPIQwrJhQa
         ZfwK3QPaTj1eSJrVenxjnNk/2cle65OeznCqC4oQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Mashak <mrv@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 125/135] net sched: update skbedit action for batched events operations
Date:   Thu, 22 Aug 2019 13:08:01 -0400
Message-Id: <20190822170811.13303-126-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>

[ Upstream commit e1fea322fc6d4075254ca9c5f2afdace0281da2a ]

Add get_fill_size() routine used to calculate the action size
when building a batch of events.

Fixes: ca9b0e27e ("pkt_action: add new action skbedit")
Signed-off-by: Roman Mashak <mrv@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_skbedit.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index b100870f02a6d..37dced00b63d1 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -307,6 +307,17 @@ static int tcf_skbedit_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
+static size_t tcf_skbedit_get_fill_size(const struct tc_action *act)
+{
+	return nla_total_size(sizeof(struct tc_skbedit))
+		+ nla_total_size(sizeof(u32)) /* TCA_SKBEDIT_PRIORITY */
+		+ nla_total_size(sizeof(u16)) /* TCA_SKBEDIT_QUEUE_MAPPING */
+		+ nla_total_size(sizeof(u32)) /* TCA_SKBEDIT_MARK */
+		+ nla_total_size(sizeof(u16)) /* TCA_SKBEDIT_PTYPE */
+		+ nla_total_size(sizeof(u32)) /* TCA_SKBEDIT_MASK */
+		+ nla_total_size_64bit(sizeof(u64)); /* TCA_SKBEDIT_FLAGS */
+}
+
 static struct tc_action_ops act_skbedit_ops = {
 	.kind		=	"skbedit",
 	.id		=	TCA_ID_SKBEDIT,
@@ -316,6 +327,7 @@ static struct tc_action_ops act_skbedit_ops = {
 	.init		=	tcf_skbedit_init,
 	.cleanup	=	tcf_skbedit_cleanup,
 	.walk		=	tcf_skbedit_walker,
+	.get_fill_size	=	tcf_skbedit_get_fill_size,
 	.lookup		=	tcf_skbedit_search,
 	.size		=	sizeof(struct tcf_skbedit),
 };
-- 
2.20.1

