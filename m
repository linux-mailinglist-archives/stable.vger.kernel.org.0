Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B87765790F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbiL1O5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbiL1O5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:57:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2EC11C18
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:57:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92DF8B8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C60C433EF;
        Wed, 28 Dec 2022 14:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239427;
        bh=qgZlEtA6VRna5pMVAm5SWl5gqaqPEc8uv3PuHhtYu70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C3+Xk8bmUqnsaMc3KZ3y9CIwRkQUJKPBEpuitDcYNCBfqt1HTLun455qXKR20OetJ
         eP7mJmnQ9FdVtP/m9ojTJijSPD51BfrQtQboyTREfB/fULejJMrWMOJEr6loufyk3v
         GxN+iTqE+rS5cP1f0byitZIEqLGcxgJtMtY43rAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 223/731] regulator: core: use kfree_const() to free space conditionally
Date:   Wed, 28 Dec 2022 15:35:30 +0100
Message-Id: <20221228144303.027659276@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit dc8d006d15b623c1d80b90b45d6dcb6e890dad09 ]

Use kfree_const() to free supply_name conditionally in create_regulator()
as supply_name may be allocated from kmalloc() or directly from .rodata
section.

Fixes: 87fe29b61f95 ("regulator: push allocations in create_regulator() outside of lock")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Link: https://lore.kernel.org/r/20221123034616.3609537-1-bobo.shaobowang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 7bf85e0cce47..65900895a0b2 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1750,7 +1750,7 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 
 	regulator = kzalloc(sizeof(*regulator), GFP_KERNEL);
 	if (regulator == NULL) {
-		kfree(supply_name);
+		kfree_const(supply_name);
 		return NULL;
 	}
 
-- 
2.35.1



