Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987F86C15E8
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 15:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjCTO6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 10:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbjCTO6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 10:58:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91A325E11
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 07:56:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AF0661585
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 14:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59321C433EF;
        Mon, 20 Mar 2023 14:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324190;
        bh=U3LWBkzc1dn7nOtFjBaCmMwuFQR+pxU0o6GTQXXySRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLlUBupJuh1trm89+Kw0OYEhTjPnxP5WmTsKsm2e7gisX4vBX56vvu16B2xIyxjAq
         9vIgWI63IELfV8viiXogq4vPvVbgqaO3tk7yi+khDaEXExnYPC8hudOenkRkYfjy2R
         UE80a2wC8ZFaQxvmv2Ur5/RVlaccFvf1Fg+PSg9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David George <David.George@sophos.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/198] xfrm: Allow transport-mode states with AF_UNSPEC selector
Date:   Mon, 20 Mar 2023 15:52:19 +0100
Message-Id: <20230320145507.490755234@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit c276a706ea1f51cf9723ed8484feceaf961b8f89 ]

xfrm state selectors are matched against the inner-most flow
which can be of any address family.  Therefore middle states
in nested configurations need to carry a wildcard selector in
order to work at all.

However, this is currently forbidden for transport-mode states.

Fix this by removing the unnecessary check.

Fixes: 13996378e658 ("[IPSEC]: Rename mode to outer_mode and add inner_mode")
Reported-by: David George <David.George@sophos.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 0f88cb6fc3c22..2f4cf976b59a3 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2649,11 +2649,6 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload,
 			goto error;
 		}
 
-		if (!(inner_mode->flags & XFRM_MODE_FLAG_TUNNEL)) {
-			NL_SET_ERR_MSG(extack, "Only tunnel modes can accommodate an AF_UNSPEC selector");
-			goto error;
-		}
-
 		x->inner_mode = *inner_mode;
 
 		if (x->props.family == AF_INET)
-- 
2.39.2



