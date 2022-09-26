Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8A85EA104
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235977AbiIZKpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233950AbiIZKnc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:43:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76B76147;
        Mon, 26 Sep 2022 03:24:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84F5560AD6;
        Mon, 26 Sep 2022 10:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A49AC433C1;
        Mon, 26 Sep 2022 10:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187879;
        bh=nttKwMzohucLBQGLis9sz97vkQJSg2wWKzcekjrxcRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V2i7una7QQjTqb++OACNgln1LuEPTr1gaMb8gPBYviDBrKWec2cixyr+GBNk7hKBc
         7LKZi/6q6od2vzHA4PvRtkilGWpvCfhSDnQqcLKVZIbRJqkSJJguxlyFSGNPp8shjl
         PY9TLet/VxAaLkKd53ah6BEh1CZbEyM2yCMDJmdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/120] net: sched: fix possible refcount leak in tc_new_tfilter()
Date:   Mon, 26 Sep 2022 12:12:02 +0200
Message-Id: <20220926100754.288285594@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
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
index 919c7fa5f02d..48a8c7daa635 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2098,6 +2098,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	}
 
 	if (chain->tmplt_ops && chain->tmplt_ops != tp->ops) {
+		tfilter_put(tp, fh);
 		NL_SET_ERR_MSG(extack, "Chain template is set to a different filter kind");
 		err = -EINVAL;
 		goto errout;
-- 
2.35.1



