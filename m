Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F326D495B
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbjDCOha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233683AbjDCOha (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:37:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0072F49F9
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:37:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDB6EB81CBC
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407EFC433D2;
        Mon,  3 Apr 2023 14:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532612;
        bh=UtvyU1VPULJfHGE7tj71Th9NyoTr9/mvl41hW6uaj+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EbVk+tFP2cxSNUlPYoHEVpLLmje0UA9Us7Zce97tp7kBHFzdQgynAIs6XtSpPQ4M5
         Wb4dwazb1g+nc6/1vgxDJl3e8cMFFTZYb5BLTQ4z66uwKvL5re8DgViorzdFH7WJB4
         XeUjn8ixW6G+CiwD0Av0+C1P46m0s7mMS3rBtScg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kristian Overskeid <koverskeid@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/181] net: hsr: Dont log netdev_err message on unknown prp dst node
Date:   Mon,  3 Apr 2023 16:08:03 +0200
Message-Id: <20230403140416.714164746@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kristian Overskeid <koverskeid@gmail.com>

[ Upstream commit 28e8cabe80f3e6e3c98121576eda898eeb20f1b1 ]

If no frames has been exchanged with a node for HSR_NODE_FORGET_TIME, the
node will be deleted from the node_db list. If a frame is sent to the node
after it is deleted, a netdev_err message for each slave interface is
produced. This should not happen with dan nodes because of supervision
frames, but can happen often with san nodes, which clutters the kernel
log. Since the hsr protocol does not support sans, this is only relevant
for the prp protocol.

Signed-off-by: Kristian Overskeid <koverskeid@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_framereg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 39a6088080e93..bd0afb8991174 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -422,7 +422,7 @@ void hsr_addr_subst_dest(struct hsr_node *node_src, struct sk_buff *skb,
 	node_dst = find_node_by_addr_A(&port->hsr->node_db,
 				       eth_hdr(skb)->h_dest);
 	if (!node_dst) {
-		if (net_ratelimit())
+		if (net_ratelimit() && port->hsr->prot_version != PRP_V1)
 			netdev_err(skb->dev, "%s: Unknown node\n", __func__);
 		return;
 	}
-- 
2.39.2



