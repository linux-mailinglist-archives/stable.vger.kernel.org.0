Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0DCE5F2996
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiJCHWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiJCHVK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:21:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DFD45F46;
        Mon,  3 Oct 2022 00:16:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AB89B80E6C;
        Mon,  3 Oct 2022 07:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E568EC433D6;
        Mon,  3 Oct 2022 07:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781311;
        bh=bKy5Cde+7OWsqG4lZVIiuQf01w1vkn4w1XQSMbK7Hrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xSS9iSUg2jCOkB2MH8rZhJ5lux15XKPzgnZKO+pzyLu/lm4Un7g9DtIj+HLx69gpk
         +a9JEZf0UmwEC5xpN/pEEop8fkHDpN+VvQtVHhP8jzGp6c+gJr4ff+/WhPS9dDUAaD
         Yh0ACm0LCcjIU3jhPAA2dJPe2f/pNvQQV0/i99Fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 074/101] net: sched: act_ct: fix possible refcount leak in tcf_ct_init()
Date:   Mon,  3 Oct 2022 09:11:10 +0200
Message-Id: <20221003070726.305230889@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 6e23ec0ba92d426c77a73a9ccab16346e5e0ef49 ]

nf_ct_put need to be called to put the refcount got by tcf_ct_fill_params
to avoid possible refcount leak when tcf_ct_flow_table_get fails.

Fixes: c34b961a2492 ("net/sched: act_ct: Create nf flow table per zone")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20220923020046.8021-1-hbh25y@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index e013253b10d1..4d44a1bf4a04 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1393,7 +1393,7 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 
 	err = tcf_ct_flow_table_get(params);
 	if (err)
-		goto cleanup;
+		goto cleanup_params;
 
 	spin_lock_bh(&c->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
@@ -1408,6 +1408,9 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 
 	return res;
 
+cleanup_params:
+	if (params->tmpl)
+		nf_ct_put(params->tmpl);
 cleanup:
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
-- 
2.35.1



