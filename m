Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6576ECEB1
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbjDXNeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbjDXNdz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:33:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC21C7295
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:33:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43D4762392
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5089DC433D2;
        Mon, 24 Apr 2023 13:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343227;
        bh=1lDhdgo6utFl0xp7ChlF2NSqxRW2Ba51OVhjNLJdgWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QkoNHN2ypwgUhT4jmAks0LcngBPwpBkwER0PQpkndXtFEj4yQgxGyZYgR0eQBR6mm
         kZuzd+Lk81nIUNMFTdjWnMo1b7slRzNWF1DDfIlzfywtTIkC3Q1Ml2Qft+BW6qT0N0
         CS5GDISIBVSJ5CKNjnuYws6SjoLobd6pAq5UiejE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Aring <aahringo@redhat.com>,
        maxpl0it <maxpl0it@protonmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 15/68] net: rpl: fix rpl header size calculation
Date:   Mon, 24 Apr 2023 15:17:46 +0200
Message-Id: <20230424131128.254149807@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
References: <20230424131127.653885914@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 307f336b5353e..3b0386437f69d 100644
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



