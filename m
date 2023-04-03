Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9197F6D4918
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbjDCOfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbjDCOfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:35:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628AFE5C
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:34:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC5C6B8074A
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB7DC433D2;
        Mon,  3 Apr 2023 14:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532476;
        bh=jgbxPkBy0l+qezlVBJw6st/RMic61XUFAO8ECw2wxMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mH+BU7kBosjPeniw++SHbzYNSSk1X/9+CKtmwofIogL29XVFo2WUcKGGrkkIlSFYf
         9EZY/gY3B43Sr5ugvn+7297iAl8jdeWw8Xj3d7I4uMMrndq1L+HoBzJAqRuJv7/0DB
         7pvV5ne7/t69GevavyOqrIdNGJd0YtG3gcKMGaSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 98/99] hsr: ratelimit only when errors are printed
Date:   Mon,  3 Apr 2023 16:10:01 +0200
Message-Id: <20230403140406.994234800@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

commit 1b0120e4db0bf2838d1ce741195ce4b7cc100b91 upstream.

Recently, when automatically merging -net and net-next in MPTCP devel
tree, our CI reported [1] a conflict in hsr, the same as the one
reported by Stephen in netdev [2].

When looking at the conflict, I noticed it is in fact the v1 [3] that
has been applied in -net and the v2 [4] in net-next. Maybe the v1 was
applied by accident.

As mentioned by Jakub Kicinski [5], the new condition makes more sense
before the net_ratelimit(), not to update net_ratelimit's state which is
unnecessary if we're not going to print either way.

Here, this modification applies the v2 but in -net.

Link: https://github.com/multipath-tcp/mptcp_net-next/actions/runs/4423171069 [1]
Link: https://lore.kernel.org/netdev/20230315100914.53fc1760@canb.auug.org.au/ [2]
Link: https://lore.kernel.org/netdev/20230307133229.127442-1-koverskeid@gmail.com/ [3]
Link: https://lore.kernel.org/netdev/20230309092302.179586-1-koverskeid@gmail.com/ [4]
Link: https://lore.kernel.org/netdev/20230308232001.2fb62013@kernel.org/ [5]
Fixes: 28e8cabe80f3 ("net: hsr: Don't log netdev_err message on unknown prp dst node")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Reviewed-by: Steen Hegelund <Steen.Hegelund@microchip.com>
Link: https://lore.kernel.org/r/20230315-net-20230315-hsr_framereg-ratelimit-v1-1-61d2ef176d11@tessares.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/hsr/hsr_framereg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -385,7 +385,7 @@ void hsr_addr_subst_dest(struct hsr_node
 	node_dst = find_node_by_addr_A(&port->hsr->node_db,
 				       eth_hdr(skb)->h_dest);
 	if (!node_dst) {
-		if (net_ratelimit() && port->hsr->prot_version != PRP_V1)
+		if (port->hsr->prot_version != PRP_V1 && net_ratelimit())
 			netdev_err(skb->dev, "%s: Unknown node\n", __func__);
 		return;
 	}


