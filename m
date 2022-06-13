Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A122548AC0
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378210AbiFMNmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379224AbiFMNkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:40:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C05AD107;
        Mon, 13 Jun 2022 04:30:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F00BD61037;
        Mon, 13 Jun 2022 11:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBBDC3411C;
        Mon, 13 Jun 2022 11:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119840;
        bh=00bZqqdycmxtNMuH0TuownGQ3AlDOIRxyWYspyldb/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6PtDyihF5j72tJfh8vR7aK6pTJm60PLbgCGIYtbr/YBBOx6Z0NJiy2TpfcjuDlBz
         n0Ju4J/25qWLmQLEvnoFInAV6svUNWO0gqAWPpdAWll7CCLkK3SAwKzjKHQY3bPlLD
         XjV3iAfez8tMeuc7WoiCfEx3KX8TP4sp0Spy/iqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 138/339] net/sched: act_api: fix error code in tcf_ct_flow_table_fill_tuple_ipv6()
Date:   Mon, 13 Jun 2022 12:09:23 +0200
Message-Id: <20220613094930.867886389@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 86360030cc5117596626bef1d937277cd2bebe05 ]

The tcf_ct_flow_table_fill_tuple_ipv6() function is supposed to return
false on failure.  It should not return negatives because that means
succes/true.

Fixes: fcb6aa86532c ("act_ct: Support GRE offload")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
Link: https://lore.kernel.org/r/YpYFnbDxFl6tQ3Bn@kili
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index b1f502fce595..b3ca837fd4e8 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -548,7 +548,7 @@ tcf_ct_flow_table_fill_tuple_ipv6(struct sk_buff *skb,
 		break;
 #endif
 	default:
-		return -1;
+		return false;
 	}
 
 	if (ip6h->hop_limit <= 1)
-- 
2.35.1



