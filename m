Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B5B582B45
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236617AbiG0QbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbiG0Qag (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:30:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4FA2BB07;
        Wed, 27 Jul 2022 09:25:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E94AD619FE;
        Wed, 27 Jul 2022 16:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0141FC433D7;
        Wed, 27 Jul 2022 16:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939105;
        bh=cMmgLo8sVs5a68Lp4rfu0ycU74LR5qPbIhOo1hm/mhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T9r7ne1SQtQNwv66jVcM6Hf7+ywaAB9lLTaqEZcQIukkvWGcyIMdCgslzJS3j5Xkr
         YEPYcMollR99JtKvqowuErPvlcLpZ29+LiiX6NzG7+RYSdbNxRxHCDFUDvNv8DkcWY
         9yeub8/vP78BA1sLIzP4XC37XrifxGVBPtA5FrUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/62] xfrm: xfrm_policy: fix a possible double xfrm_pols_put() in xfrm_bundle_lookup()
Date:   Wed, 27 Jul 2022 18:10:12 +0200
Message-Id: <20220727161004.296631438@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161004.175638564@linuxfoundation.org>
References: <20220727161004.175638564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit f85daf0e725358be78dfd208dea5fd665d8cb901 ]

xfrm_policy_lookup() will call xfrm_pol_hold_rcu() to get a refcount of
pols[0]. This refcount can be dropped in xfrm_expand_policies() when
xfrm_expand_policies() return error. pols[0]'s refcount is balanced in
here. But xfrm_bundle_lookup() will also call xfrm_pols_put() with
num_pols == 1 to drop this refcount when xfrm_expand_policies() return
error.

This patch also fix an illegal address access. pols[0] will save a error
point when xfrm_policy_lookup fails. This lead to xfrm_pols_put to resolve
an illegal address in xfrm_bundle_lookup's error path.

Fix these by setting num_pols = 0 in xfrm_expand_policies()'s error path.

Fixes: 80c802f3073e ("xfrm: cache bundles instead of policies for outgoing flows")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index bb1c94e20e82..3582f77bab6a 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1697,8 +1697,10 @@ static int xfrm_expand_policies(const struct flowi *fl, u16 family,
 		*num_xfrms = 0;
 		return 0;
 	}
-	if (IS_ERR(pols[0]))
+	if (IS_ERR(pols[0])) {
+		*num_pols = 0;
 		return PTR_ERR(pols[0]);
+	}
 
 	*num_xfrms = pols[0]->xfrm_nr;
 
@@ -1713,6 +1715,7 @@ static int xfrm_expand_policies(const struct flowi *fl, u16 family,
 		if (pols[1]) {
 			if (IS_ERR(pols[1])) {
 				xfrm_pols_put(pols, *num_pols);
+				*num_pols = 0;
 				return PTR_ERR(pols[1]);
 			}
 			(*num_pols)++;
-- 
2.35.1



