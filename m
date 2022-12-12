Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CE764A0CA
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbiLLNap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbiLLNao (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:30:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FB76549
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:30:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B201DCE0F7B
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02629C433D2;
        Mon, 12 Dec 2022 13:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851840;
        bh=XVSMrtTaqFbA/yO6OdWKo6Jh6ZBJN0hHGsgDWIUgntI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CmqBKMzpgHoF6ywVD1k27kMH3AkyWERedAmKZJsK3saBv6ekH2wUq2rFKerWFcHpX
         582rHgtZBQq2XSRBOL45Dymt1ZXZA62H9FL6Dq/ghd5teUfXiGE5xY+jSlzOUu0mFj
         QKnLifx3rxcvSuAmAahwH0qPbO3EmVcxFdCyvoxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Artem Chernyshev <artem.chernyshev@red-soft.ru>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/123] net: dsa: hellcreek: Check return value
Date:   Mon, 12 Dec 2022 14:17:26 +0100
Message-Id: <20221212130930.324015978@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
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

From: Artem Chernyshev <artem.chernyshev@red-soft.ru>

[ Upstream commit d4edb50688652eb10be270bc515da63815de428f ]

Return NULL if we got unexpected value from skb_trim_rcsum()
in hellcreek_rcv()

Fixes: 01ef09caad66 ("net: dsa: Add tag handling for Hirschmann Hellcreek switches")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Link: https://lore.kernel.org/r/20221201140032.26746-2-artem.chernyshev@red-soft.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_hellcreek.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
index 846588c0070a..53a206d11685 100644
--- a/net/dsa/tag_hellcreek.c
+++ b/net/dsa/tag_hellcreek.c
@@ -49,7 +49,8 @@ static struct sk_buff *hellcreek_rcv(struct sk_buff *skb,
 		return NULL;
 	}
 
-	pskb_trim_rcsum(skb, skb->len - HELLCREEK_TAG_LEN);
+	if (pskb_trim_rcsum(skb, skb->len - HELLCREEK_TAG_LEN))
+		return NULL;
 
 	dsa_default_offload_fwd_mark(skb);
 
-- 
2.35.1



