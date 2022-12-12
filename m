Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA2964A1B0
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbiLLNoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbiLLNno (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:43:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA6110A0
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:43:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46C516106F
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E549BC433EF;
        Mon, 12 Dec 2022 13:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852591;
        bh=AzJSGGLEjQ20cC65AI47DBuf7qOlNwQK1SBMY8LXiS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQZwbzH1a55ZYrOzddFqlWu6TqQjgKRUkBDqaUc1zsSKUsToZ0uIavIlTLIRAukyg
         7TLcJFyc5C4x43uBfkGaqQz0NGNO5HNAOslE7m6JMVQ/T6nqe2fJPefhdaQ3CrW8p0
         7OJpaqB6zqJTdkacJp26J84hofyvSPB44luUqMoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Artem Chernyshev <artem.chernyshev@red-soft.ru>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 111/157] net: dsa: ksz: Check return value
Date:   Mon, 12 Dec 2022 14:17:39 +0100
Message-Id: <20221212130939.307149855@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

[ Upstream commit 3d8fdcbf1f42e2bb9ae8b8c0b6f202278c788a22 ]

Return NULL if we got unexpected value from skb_trim_rcsum()
in ksz_common_rcv()

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: bafe9ba7d908 ("net: dsa: ksz: Factor out common tag code")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20221201140032.26746-1-artem.chernyshev@red-soft.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_ksz.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 38fa19c1e2d5..429250298ac4 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -21,7 +21,8 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 	if (!skb->dev)
 		return NULL;
 
-	pskb_trim_rcsum(skb, skb->len - len);
+	if (pskb_trim_rcsum(skb, skb->len - len))
+		return NULL;
 
 	dsa_default_offload_fwd_mark(skb);
 
-- 
2.35.1



