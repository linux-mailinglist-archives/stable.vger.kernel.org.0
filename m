Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1CE5A47F6
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiH2LDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiH2LCQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:02:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB314D80B;
        Mon, 29 Aug 2022 04:02:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AD74B80EF4;
        Mon, 29 Aug 2022 11:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEC2C433D7;
        Mon, 29 Aug 2022 11:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661770931;
        bh=JYpfQQ30zXo/7zlfcEFyBdEtk3ZB2sFqVIVSXvRZhp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ixK7QJ2iNBgQ3ztpJTX1YSAuu8sZ6hcbsYEd91wVhewhsxGnZvEIi4+7mC1CoMXgB
         J7tCvD8a/7qbtL16zk2naYoIUNlwUUqbr5BM+2K6gLd7Iv7i5g8OghFkafKTi37btG
         dYs4SFVuA2vt8t91oTi3XkwyGLfiqG6qnywXjH4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Xiong <xiongx18@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/136] xfrm: fix refcount leak in __xfrm_policy_check()
Date:   Mon, 29 Aug 2022 12:58:13 +0200
Message-Id: <20220829105805.645385206@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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
index fb198f9490a0f..036d7de164914 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3600,6 +3600,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		if (pols[1]) {
 			if (IS_ERR(pols[1])) {
 				XFRM_INC_STATS(net, LINUX_MIB_XFRMINPOLERROR);
+				xfrm_pol_put(pols[0]);
 				return 0;
 			}
 			pols[1]->curlft.use_time = ktime_get_real_seconds();
-- 
2.35.1



