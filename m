Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B856ECD34
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbjDXNVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbjDXNV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:21:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD48B4C17
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:21:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36E5E62229
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461F3C4339B;
        Mon, 24 Apr 2023 13:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342465;
        bh=JNwwZ8erFC9UapkXT18tqn01jY1Hhw1A08NlEQTQ3sQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGrDilY6Sqoxbr1O4AnvGLSPx6iXbtbNzSraOgKgyzZ4T4J9wjOsLK4u2YFZt550y
         znyem/jtJYEE3dXAaHs1WIHwZqsSYrwWea7SBwLB2+pyDu961hWVovTC1ByaoJqx3+
         QRcShCm/98RJkxAu+98mC77BVABMu8LoN7VJ9BUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Aring <aahringo@redhat.com>,
        maxpl0it <maxpl0it@protonmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 20/73] net: rpl: fix rpl header size calculation
Date:   Mon, 24 Apr 2023 15:16:34 +0200
Message-Id: <20230424131129.753653305@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 4e006c7a6dac0ead4c1bf606000aa90a372fc253 ]

This patch fixes a missing 8 byte for the header size calculation. The
ipv6_rpl_srh_size() is used to check a skb_pull() on skb->data which
points to skb_transport_header(). Currently we only check on the
calculated addresses fields using CmprI and CmprE fields, see:

https://www.rfc-editor.org/rfc/rfc6554#section-3

there is however a missing 8 byte inside the calculation which stands
for the fields before the addresses field. Those 8 bytes are represented
by sizeof(struct ipv6_rpl_sr_hdr) expression.

Fixes: 8610c7c6e3bd ("net: ipv6: add support for rpl sr exthdr")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Reported-by: maxpl0it <maxpl0it@protonmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/rpl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/rpl.c b/net/ipv6/rpl.c
index 488aec9e1a74f..d1876f1922255 100644
--- a/net/ipv6/rpl.c
+++ b/net/ipv6/rpl.c
@@ -32,7 +32,8 @@ static void *ipv6_rpl_segdata_pos(const struct ipv6_rpl_sr_hdr *hdr, int i)
 size_t ipv6_rpl_srh_size(unsigned char n, unsigned char cmpri,
 			 unsigned char cmpre)
 {
-	return (n * IPV6_PFXTAIL_LEN(cmpri)) + IPV6_PFXTAIL_LEN(cmpre);
+	return sizeof(struct ipv6_rpl_sr_hdr) + (n * IPV6_PFXTAIL_LEN(cmpri)) +
+		IPV6_PFXTAIL_LEN(cmpre);
 }
 
 void ipv6_rpl_srh_decompress(struct ipv6_rpl_sr_hdr *outhdr,
-- 
2.39.2



