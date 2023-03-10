Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63976B41FE
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbjCJN6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbjCJN6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:58:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB1C5DC87
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:58:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29EB9B822B1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F907C433EF;
        Fri, 10 Mar 2023 13:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456712;
        bh=ZnNLstyvJRgpkBsGvsWqZFTK44193dpsBoMSVfjj4aA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rfv1S7O3sMjeRmVJctwBfZBOfu0YyP8p6tcGrq/gVpqTqRHgM3we7iyPxyO6c8KBW
         zqVLjzsdTT8YBF4gEByDtYMZvUf8A0oq4vCrh8A+xA0ibfq1H14EsBRRlWOzAB43no
         /STnIwZIAke6fIB2u6OuQ4dtbunXnC0/J0k8vmP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jamal Hadi Salim <jhs@mojatatu.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 097/211] net/sched: act_sample: fix action bind logic
Date:   Fri, 10 Mar 2023 14:37:57 +0100
Message-Id: <20230310133721.725108466@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit 4a20056a49a1854966562241922f68197f950539 ]

The TC architecture allows filters and actions to be created independently.
In filters the user can reference action objects using:
tc action add action sample ... index 1
tc filter add ... action pedit index 1

In the current code for act_sample this is broken as it checks netlink
attributes for create/update before actually checking if we are binding to an
existing action.

tdc results:
1..29
ok 1 9784 - Add valid sample action with mandatory arguments
ok 2 5c91 - Add valid sample action with mandatory arguments and continue control action
ok 3 334b - Add valid sample action with mandatory arguments and drop control action
ok 4 da69 - Add valid sample action with mandatory arguments and reclassify control action
ok 5 13ce - Add valid sample action with mandatory arguments and pipe control action
ok 6 1886 - Add valid sample action with mandatory arguments and jump control action
ok 7 7571 - Add sample action with invalid rate
ok 8 b6d4 - Add sample action with mandatory arguments and invalid control action
ok 9 a874 - Add invalid sample action without mandatory arguments
ok 10 ac01 - Add invalid sample action without mandatory argument rate
ok 11 4203 - Add invalid sample action without mandatory argument group
ok 12 14a7 - Add invalid sample action without mandatory argument group
ok 13 8f2e - Add valid sample action with trunc argument
ok 14 45f8 - Add sample action with maximum rate argument
ok 15 ad0c - Add sample action with maximum trunc argument
ok 16 83a9 - Add sample action with maximum group argument
ok 17 ed27 - Add sample action with invalid rate argument
ok 18 2eae - Add sample action with invalid group argument
ok 19 6ff3 - Add sample action with invalid trunc size
ok 20 2b2a - Add sample action with invalid index
ok 21 dee2 - Add sample action with maximum allowed index
ok 22 560e - Add sample action with cookie
ok 23 704a - Replace existing sample action with new rate argument
ok 24 60eb - Replace existing sample action with new group argument
ok 25 2cce - Replace existing sample action with new trunc argument
ok 26 59d1 - Replace existing sample action with new control argument
ok 27 0a6e - Replace sample action with invalid goto chain control
ok 28 3872 - Delete sample action with valid index
ok 29 a394 - Delete sample action with invalid index

Fixes: 5c5670fae430 ("net/sched: Introduce sample tc action")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_sample.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index f7416b5598e04..4c670e7568dc6 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -55,8 +55,8 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 					  sample_policy, NULL);
 	if (ret < 0)
 		return ret;
-	if (!tb[TCA_SAMPLE_PARMS] || !tb[TCA_SAMPLE_RATE] ||
-	    !tb[TCA_SAMPLE_PSAMPLE_GROUP])
+
+	if (!tb[TCA_SAMPLE_PARMS])
 		return -EINVAL;
 
 	parm = nla_data(tb[TCA_SAMPLE_PARMS]);
@@ -80,6 +80,13 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 		tcf_idr_release(*a, bind);
 		return -EEXIST;
 	}
+
+	if (!tb[TCA_SAMPLE_RATE] || !tb[TCA_SAMPLE_PSAMPLE_GROUP]) {
+		NL_SET_ERR_MSG(extack, "sample rate and group are required");
+		err = -EINVAL;
+		goto release_idr;
+	}
+
 	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
 	if (err < 0)
 		goto release_idr;
-- 
2.39.2



