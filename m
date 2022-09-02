Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE495AAF5B
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236996AbiIBMgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236307AbiIBMgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:36:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED082DF08E;
        Fri,  2 Sep 2022 05:28:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D11E62175;
        Fri,  2 Sep 2022 12:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4F0C433C1;
        Fri,  2 Sep 2022 12:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121622;
        bh=nFoK8rVsPQz6rYmkyOvn9UVwRfW92AskwAEHqocBEC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGwYrI9gPU5HDSiBVXUORtVUwkOcGlf6+rhsEstc1aZn/7gK2BxH9BeXYsP9eADKk
         xlDK+us3c3jlw3TsVAUrYCMjoamP+oKvW8CSYPyHKuzPgaUjeyAqZOm8Ba6wuPWjQo
         UgoP7TZqUzUs76S9pZ4OVXmCB2p4/9CN5IHce5Dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Xiong <xiongx18@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/77] xfrm: fix refcount leak in __xfrm_policy_check()
Date:   Fri,  2 Sep 2022 14:18:21 +0200
Message-Id: <20220902121404.047115996@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
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

From: Xin Xiong <xiongx18@fudan.edu.cn>

[ Upstream commit 9c9cb23e00ddf45679b21b4dacc11d1ae7961ebe ]

The issue happens on an error path in __xfrm_policy_check(). When the
fetching process of the object `pols[1]` fails, the function simply
returns 0, forgetting to decrement the reference count of `pols[0]`,
which is incremented earlier by either xfrm_sk_policy_lookup() or
xfrm_policy_lookup(). This may result in memory leaks.

Fix it by decreasing the reference count of `pols[0]` in that path.

Fixes: 134b0fc544ba ("IPsec: propagate security module errors up from flow_cache_lookup")
Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 28a8cdef8e51f..6f58be5a17711 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3619,6 +3619,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		if (pols[1]) {
 			if (IS_ERR(pols[1])) {
 				XFRM_INC_STATS(net, LINUX_MIB_XFRMINPOLERROR);
+				xfrm_pol_put(pols[0]);
 				return 0;
 			}
 			pols[1]->curlft.use_time = ktime_get_real_seconds();
-- 
2.35.1



