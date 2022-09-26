Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586535EA389
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbiIZL1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234762AbiIZL0Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:26:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12B84C608;
        Mon, 26 Sep 2022 03:40:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BF9CECE10F6;
        Mon, 26 Sep 2022 10:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FECC433D6;
        Mon, 26 Sep 2022 10:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188769;
        bh=IesErMf5RkJTxLi72KRDWKUmi/VwQXqWyyX77S71ryk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vt0wzUg9Emt9sfVSriALNIZvjsTFqALPnBYzcKSa5y8U+h8m5VoVY0VYAAToLRvjw
         NK8sZnKelcA1KhuZ3VeVZwr6KiMT20vHFxox1KEtJaALdZJJOKHp5vbPbKslmWHVo3
         9MksV8AxeIjkXC6d844tT6C70JBdeMBf2iYZ13X8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/148] net: sched: fix possible refcount leak in tc_new_tfilter()
Date:   Mon, 26 Sep 2022 12:12:28 +0200
Message-Id: <20220926100800.406510941@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit c2e1cfefcac35e0eea229e148c8284088ce437b5 ]

tfilter_put need to be called to put the refount got by tp->ops->get to
avoid possible refcount leak when chain->tmplt_ops != NULL and
chain->tmplt_ops != tp->ops.

Fixes: 7d5509fa0d3d ("net: sched: extend proto ops with 'put' callback")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Link: https://lore.kernel.org/r/20220921092734.31700-1-hbh25y@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 4b552c10e7b9..62ce6981942b 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2117,6 +2117,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	}
 
 	if (chain->tmplt_ops && chain->tmplt_ops != tp->ops) {
+		tfilter_put(tp, fh);
 		NL_SET_ERR_MSG(extack, "Chain template is set to a different filter kind");
 		err = -EINVAL;
 		goto errout;
-- 
2.35.1



