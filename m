Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0F559488C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355504AbiHOX40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356231AbiHOXx6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:53:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CB2C6B7B;
        Mon, 15 Aug 2022 13:18:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 724B960DEB;
        Mon, 15 Aug 2022 20:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EA4C433D7;
        Mon, 15 Aug 2022 20:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594720;
        bh=DFT14kIqMWORbQnzYNlTNSiDiYPcQccGBaO8LcqfgVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xi8AWGOWBU30UfuQK91yjwof8IvJ5FZuFdhIOOShoT4UB+sn/cQ4MaC0MnWhduY3j
         fROjUX1wQqPC/JIPZFiBIYVLr8+FdO1L2yg6rfyaelKjXyQtvu3NLUdxndEF0I5aCw
         xTcmINAO9jxySScVLRwPsGnGuzcZbuv4qzsjN9Q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Chaignon <paul@isovalent.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0537/1157] bpf: Set flow flag to allow any source IP in bpf_tunnel_key
Date:   Mon, 15 Aug 2022 19:58:13 +0200
Message-Id: <20220815180501.149595269@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Chaignon <paul@isovalent.com>

[ Upstream commit b8fff748521c7178b9a7d32b5a34a81cec8396f3 ]

Commit 26101f5ab6bd ("bpf: Add source ip in "struct bpf_tunnel_key"")
added support for getting and setting the outer source IP of encapsulated
packets via the bpf_skb_{get,set}_tunnel_key BPF helper. This change
allows BPF programs to set any IP address as the source, including for
example the IP address of a container running on the same host.

In that last case, however, the encapsulated packets are dropped when
looking up the route because the source IP address isn't assigned to any
interface on the host. To avoid this, we need to set the
FLOWI_FLAG_ANYSRC flag.

Fixes: 26101f5ab6bd ("bpf: Add source ip in "struct bpf_tunnel_key"")
Signed-off-by: Paul Chaignon <paul@isovalent.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/76873d384e21288abe5767551a0799ac93ec07fb.1658759380.git.paul@isovalent.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 7950f7520765..5978984b752f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4653,6 +4653,7 @@ BPF_CALL_4(bpf_skb_set_tunnel_key, struct sk_buff *, skb,
 	} else {
 		info->key.u.ipv4.dst = cpu_to_be32(from->remote_ipv4);
 		info->key.u.ipv4.src = cpu_to_be32(from->local_ipv4);
+		info->key.flow_flags = FLOWI_FLAG_ANYSRC;
 	}
 
 	return 0;
-- 
2.35.1



