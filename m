Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126D7528FC3
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347196AbiEPUGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349023AbiEPT7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:59:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4C33FDB1;
        Mon, 16 May 2022 12:53:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD015B81613;
        Mon, 16 May 2022 19:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C25FC385AA;
        Mon, 16 May 2022 19:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730797;
        bh=zw7+nG7mRK6zS8SGRZtV5iHlnpITV6OHXD5smvY6bZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bqWCIAOiHwDueEeftBX/ypajONYVo/cmPwD8d1hQSTDAQIexuVsJF3NGaFgyYrNTl
         GGes+UnGPau3gLmaBU4a9BXcJSY8QU2HXKmhPig/UgzlUuIvooG5K75rJTa3cpokFR
         p/f7Cnc6vYtiqcT14cfA49p5srE4VymfgVmP2BgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kaechele <felix@kaechele.ca>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 001/114] batman-adv: Dont skb_split skbuffs with frag_list
Date:   Mon, 16 May 2022 21:35:35 +0200
Message-Id: <20220516193625.533471759@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit a063f2fba3fa633a599253b62561051ac185fa99 ]

The receiving interface might have used GRO to receive more fragments than
MAX_SKB_FRAGS fragments. In this case, these will not be stored in
skb_shinfo(skb)->frags but merged into the frag list.

batman-adv relies on the function skb_split to split packets up into
multiple smaller packets which are not larger than the MTU on the outgoing
interface. But this function cannot handle frag_list entries and is only
operating on skb_shinfo(skb)->frags. If it is still trying to split such an
skb and xmit'ing it on an interface without support for NETIF_F_FRAGLIST,
then validate_xmit_skb() will try to linearize it. But this fails due to
inconsistent information. And __pskb_pull_tail will trigger a BUG_ON after
skb_copy_bits() returns an error.

In case of entries in frag_list, just linearize the skb before operating on
it with skb_split().

Reported-by: Felix Kaechele <felix@kaechele.ca>
Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Tested-by: Felix Kaechele <felix@kaechele.ca>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/fragmentation.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index 0899a729a23f..c120c7c6d25f 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -475,6 +475,17 @@ int batadv_frag_send_packet(struct sk_buff *skb,
 		goto free_skb;
 	}
 
+	/* GRO might have added fragments to the fragment list instead of
+	 * frags[]. But this is not handled by skb_split and must be
+	 * linearized to avoid incorrect length information after all
+	 * batman-adv fragments were created and submitted to the
+	 * hard-interface
+	 */
+	if (skb_has_frag_list(skb) && __skb_linearize(skb)) {
+		ret = -ENOMEM;
+		goto free_skb;
+	}
+
 	/* Create one header to be copied to all fragments */
 	frag_header.packet_type = BATADV_UNICAST_FRAG;
 	frag_header.version = BATADV_COMPAT_VERSION;
-- 
2.35.1



