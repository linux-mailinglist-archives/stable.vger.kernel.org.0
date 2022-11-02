Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 394C3615962
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiKBDKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiKBDJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:09:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8847CE0FE
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:09:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25551616DB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D87C433C1;
        Wed,  2 Nov 2022 03:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358590;
        bh=HzTcrTZuM4ipViQLLbBRUzgq3nTz5Z4KEmac670ZfQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RZHTd+Cr5qjcNmlj95bQYrkZC1hF+ntvrGnLk95B8vZZp+pZEjERD0xll9sNjObEu
         ViZ1XJ28KlguuUNk+EPLVLDoS7eT4wluQ2Anr4rdrB/B/lx6InNaW/89wHP5mqL0Qn
         WenzJsfYfa31NqMTew39bKqeTvtJfMlGbxiUQsOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/132] kcm: do not sense pfmemalloc status in kcm_sendpage()
Date:   Wed,  2 Nov 2022 03:33:50 +0100
Message-Id: <20221102022102.930968110@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ee15e1f38dc201fa7d63c13aa258b728dce27f4d ]

Similar to changes done in TCP in blamed commit.
We should not sense pfmemalloc status in sendpage() methods.

Fixes: 326140063946 ("tcp: TX zerocopy should not sense pfmemalloc status")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20221027040637.1107703-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/kcm/kcmsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index ff6dd2619f22..a1478ad393f9 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -838,7 +838,7 @@ static ssize_t kcm_sendpage(struct socket *sock, struct page *page,
 	}
 
 	get_page(page);
-	skb_fill_page_desc(skb, i, page, offset, size);
+	skb_fill_page_desc_noacc(skb, i, page, offset, size);
 	skb_shinfo(skb)->flags |= SKBFL_SHARED_FRAG;
 
 coalesced:
-- 
2.35.1



