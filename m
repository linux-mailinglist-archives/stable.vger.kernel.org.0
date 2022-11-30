Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEEF63DF70
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbiK3SrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiK3SrD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:47:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E6A2B279
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:47:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5A8CB81CAA
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3619AC433D6;
        Wed, 30 Nov 2022 18:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834020;
        bh=1a3DfW1F7VcAyUP9sKkQWH85dljefbiNu41OLDs++1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oAsUApls3Xd5luPlGzTopSPqPZt4nOAznaOjTRUwwcyU71qqCR5+sXEjYhn6RAX/K
         MZzZRBF+JZXzmRKkflXwgZtalsClJio+uDQaX5MVx9WnSpN9yvRkfL9yYPy/m7t0zB
         Lg0BsF0Dpg1h9ihcLe27iefD7Ek+kkuWBG0kE51o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, YueHaibing <yuehaibing@huawei.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 099/289] macsec: Fix invalid error code set
Date:   Wed, 30 Nov 2022 19:21:24 +0100
Message-Id: <20221130180546.384871277@linuxfoundation.org>
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

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 7cef6b73fba96abef731a53501924fc3c4a0f947 ]

'ret' is defined twice in macsec_changelink(), when it is set in macsec_is_offloaded
case, it will be invalid before return.

Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Saeed Mahameed <saeed@kernel.org>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Link: https://lore.kernel.org/r/20221118011249.48112-1-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index d145ad189778..104fc564a766 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3855,7 +3855,6 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (macsec_is_offloaded(macsec)) {
 		const struct macsec_ops *ops;
 		struct macsec_context ctx;
-		int ret;
 
 		ops = macsec_get_ops(netdev_priv(dev), &ctx);
 		if (!ops) {
-- 
2.35.1



