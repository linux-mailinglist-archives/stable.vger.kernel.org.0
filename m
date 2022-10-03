Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850A55F2A82
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbiJCHhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbiJCHfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:35:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764D752E5B;
        Mon,  3 Oct 2022 00:22:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A49B6B80E97;
        Mon,  3 Oct 2022 07:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226BEC433C1;
        Mon,  3 Oct 2022 07:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781727;
        bh=plVRTJ6RQB2Y+VJW/WUnX3V2f6K3wgn9NwlsUDQ9SzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CkSwmDdA3UUzIunDS0rbKHJ5U8TGEQH0NUQOjHf8plZOpPzKr2hr1WxhP95evXCIh
         4MsI6cw7vPlzE4ymnxXFU1lLBfLQZJDND3cEDndV0RPn2KtE5Vu0IiXQ3elaQtj29K
         wxkwsaAvtt3EcjY2ikEMTtKYWAz3y3bptV15NDao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 42/52] net: sched: act_ct: fix possible refcount leak in tcf_ct_init()
Date:   Mon,  3 Oct 2022 09:11:49 +0200
Message-Id: <20221003070719.987992168@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070718.687440096@linuxfoundation.org>
References: <20221003070718.687440096@linuxfoundation.org>
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
index 825b3e9b55f7..f7e88d7466c3 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1293,7 +1293,7 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 
 	err = tcf_ct_flow_table_get(params);
 	if (err)
-		goto cleanup;
+		goto cleanup_params;
 
 	spin_lock_bh(&c->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
@@ -1308,6 +1308,9 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 
 	return res;
 
+cleanup_params:
+	if (params->tmpl)
+		nf_ct_put(params->tmpl);
 cleanup:
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
-- 
2.35.1



