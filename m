Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5537F63DF83
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbiK3Sry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbiK3Srv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:47:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6209C6172
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:47:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F23C161D70
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CD3C433D7;
        Wed, 30 Nov 2022 18:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834069;
        bh=I1rJnkTUb/sNAbOH8+zMk8Xhf/dUN1XPGyNvueiIeik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vOV0yw3f8xL16GzhrXt58Ax0U7DdMFF+E+3R9RPckTnTi9GJg0G/wGuWQWxRARRHZ
         apGlvDe7LSsG5Lgr1lMXujy8Bo6xU/5W0l+JfhCpIRl9PDbDG7g0ctuIfjIGyCb5WJ
         yySU7z//dakwWmRKR5F0PCExSZlPc9OMuDFMOfgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 118/289] xfrm: Fix ignored return value in xfrm6_init()
Date:   Wed, 30 Nov 2022 19:21:43 +0100
Message-Id: <20221130180546.815257342@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit 40781bfb836eda57d19c0baa37c7e72590e05fdc ]

When IPv6 module initializing in xfrm6_init(), register_pernet_subsys()
is possible to fail but its return value is ignored.

If IPv6 initialization fails later and xfrm6_fini() is called,
removing uninitialized list in xfrm6_net_ops will cause null-ptr-deref:

KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 PID: 330 Comm: insmod
RIP: 0010:unregister_pernet_operations+0xc9/0x450
Call Trace:
 <TASK>
 unregister_pernet_subsys+0x31/0x3e
 xfrm6_fini+0x16/0x30 [ipv6]
 ip6_route_init+0xcd/0x128 [ipv6]
 inet6_init+0x29c/0x602 [ipv6]
 ...

Fix it by catching the error return value of register_pernet_subsys().

Fixes: 8d068875caca ("xfrm: make gc_thresh configurable in all namespaces")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/xfrm6_policy.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
index 4a4b0e49ec92..ea435eba3053 100644
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -287,9 +287,13 @@ int __init xfrm6_init(void)
 	if (ret)
 		goto out_state;
 
-	register_pernet_subsys(&xfrm6_net_ops);
+	ret = register_pernet_subsys(&xfrm6_net_ops);
+	if (ret)
+		goto out_protocol;
 out:
 	return ret;
+out_protocol:
+	xfrm6_protocol_fini();
 out_state:
 	xfrm6_state_fini();
 out_policy:
-- 
2.35.1



