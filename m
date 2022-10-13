Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10BAB5FD0F0
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbiJMAad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbiJMA3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:29:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE86C11E468;
        Wed, 12 Oct 2022 17:26:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 490D3616F3;
        Thu, 13 Oct 2022 00:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDE0C433D6;
        Thu, 13 Oct 2022 00:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620650;
        bh=F3mK1pi1yeJT9YgLo2PmI4i6ohoCD7tAVidzDjPvnt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U4t0Rz3fhZypBm5R6is27Al89INxA6uA8Th8UD2zrbH2hcGGtJmMIwUf9btBLMOuh
         abU4EAek+S5jwJHXu/qzu6Iz6bOhHgCq4bbNyi1IvEyTgxskoylgLWCfJuK70Z9/+V
         IxTo0OQV7FlfMKR39F8QhIdmQFVAaV9wIhrjkJcsnZ4PP6dRBw23uPGOmLFI3kHZsl
         ZZM+BIVFRs8bI+/Xg+TwOlSa2yMLk6fW4NFDlHjA5dnVh0ljTi921zuthfG+GVvUob
         UjLfN7ChNspmG3WT1Dvo8UiyiFrW1+2xa12QK/UE5XZzDrMNftI0amHBBi6u+wpM5p
         dzTtV8pP99waA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nam Cao <namcaov@gmail.com>,
        Philipp Hortmann <philipp.g.hortmann@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, forest@alittletooquiet.net,
        tomm.merciai@gmail.com, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 12/33] staging: vt6655: fix potential memory leak
Date:   Wed, 12 Oct 2022 20:23:11 -0400
Message-Id: <20221013002334.1894749-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002334.1894749-1-sashal@kernel.org>
References: <20221013002334.1894749-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nam Cao <namcaov@gmail.com>

[ Upstream commit c8ff91535880d41b49699b3829fb6151942de29e ]

In function device_init_td0_ring, memory is allocated for member
td_info of priv->apTD0Rings[i], with i increasing from 0. In case of
allocation failure, the memory is freed in reversed order, with i
decreasing to 0. However, the case i=0 is left out and thus memory is
leaked.

Modify the memory freeing loop to include the case i=0.

Tested-by: Philipp Hortmann <philipp.g.hortmann@gmail.com>
Signed-off-by: Nam Cao <namcaov@gmail.com>
Link: https://lore.kernel.org/r/20220909141338.19343-1-namcaov@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vt6655/device_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 09ab6d6f2429..d66dd5289a7c 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -675,7 +675,7 @@ static int device_init_td0_ring(struct vnt_private *priv)
 	return 0;
 
 err_free_desc:
-	while (--i) {
+	while (i--) {
 		desc = &priv->apTD0Rings[i];
 		kfree(desc->td_info);
 	}
-- 
2.35.1

