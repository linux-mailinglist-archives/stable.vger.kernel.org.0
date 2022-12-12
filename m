Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB2B64A0CB
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbiLLNar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbiLLNaq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:30:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31987625C
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:30:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC8DB61025
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B3AC433F0;
        Mon, 12 Dec 2022 13:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851845;
        bh=RypHvQnHFMYlxIri4+HOQxg+dMRzwH7QxiDptTM4hJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GfkNMILKxszoRKhmkcmxYHvs+AiN57DjFULyclHjSZo4pbj5bdoR5XVlYoTUJUDWt
         vSt4aNJn1KFipYmJn1jFROAbhcekEIRDPygZQsKc0hYPjXEw23ecXDBGQUL1gdXLC/
         j0eWMYyOPI9oA4CIawKqjEushjARuDy25zqu1enE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Artem Chernyshev <artem.chernyshev@red-soft.ru>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/123] net: dsa: sja1105: Check return value
Date:   Mon, 12 Dec 2022 14:17:27 +0100
Message-Id: <20221212130930.365769995@linuxfoundation.org>
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

[ Upstream commit 8948876335b1752176afdff8e704099a3ea0f6e6 ]

Return NULL if we got unexpected value from skb_trim_rcsum() in
sja1110_rcv_inband_control_extension()

Fixes: 4913b8ebf8a9 ("net: dsa: add support for the SJA1110 native tagging protocol")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20221201140032.26746-3-artem.chernyshev@red-soft.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_sja1105.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 2edede9ddac9..d43feadd5fa6 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -644,7 +644,8 @@ static struct sk_buff *sja1110_rcv_inband_control_extension(struct sk_buff *skb,
 		 * padding and trailer we need to account for the fact that
 		 * skb->data points to skb_mac_header(skb) + ETH_HLEN.
 		 */
-		pskb_trim_rcsum(skb, start_of_padding - ETH_HLEN);
+		if (pskb_trim_rcsum(skb, start_of_padding - ETH_HLEN))
+			return NULL;
 	/* Trap-to-host frame, no timestamp trailer */
 	} else {
 		*source_port = SJA1110_RX_HEADER_SRC_PORT(rx_header);
-- 
2.35.1



