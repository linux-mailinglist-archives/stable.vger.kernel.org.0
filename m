Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724CE6582DB
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234895AbiL1Qmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234871AbiL1QmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:42:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DA922C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:36:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9021B8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF3AC433D2;
        Wed, 28 Dec 2022 16:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245382;
        bh=ymDt+OQ1d1l7JhA36+wNvf/5kqDthP0wuJ+WVC+JCpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dbMo8cVjH1mXF6EM05aIiw3rRjuDuoOgQXVT9SB46W9pCSkZnhBAY7fjYiuBXOxp5
         rYSq/AMMg26lscZ8f+lXC6wkMAy9UPzQEXAqd6/ysAqd6jdFhsOdLVCN/srThANkFV
         FxkuEui6mO0KIJB9WKtTVnEjDe8X/wjSJKfpfcXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matt Johnston <matt@codeconstruct.com.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0883/1073] mctp: Remove device type check at unregister
Date:   Wed, 28 Dec 2022 15:41:11 +0100
Message-Id: <20221228144352.011134374@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit b389a902dd5be4ece505a2e0463b9b034de04bf5 ]

The unregister check could be incorrectly triggered if a netdev
changes its type after register. That is possible for a tun device
using TUNSETLINK ioctl, resulting in mctp unregister failing
and the netdev unregister waiting forever.

This was encountered by https://github.com/openthread/openthread/issues/8523

Neither check at register or unregister is required. They were added in
an attempt to track down mctp_ptr being set unexpectedly, which should
not happen in normal operation.

Fixes: 7b1871af75f3 ("mctp: Warn if pointer is set for a wrong dev type")
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Link: https://lore.kernel.org/r/20221215054933.2403401-1-matt@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/device.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index 99a3bda8852f..acb97b257428 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -429,12 +429,6 @@ static void mctp_unregister(struct net_device *dev)
 	struct mctp_dev *mdev;
 
 	mdev = mctp_dev_get_rtnl(dev);
-	if (mdev && !mctp_known(dev)) {
-		// Sanity check, should match what was set in mctp_register
-		netdev_warn(dev, "%s: BUG mctp_ptr set for unknown type %d",
-			    __func__, dev->type);
-		return;
-	}
 	if (!mdev)
 		return;
 
@@ -451,14 +445,8 @@ static int mctp_register(struct net_device *dev)
 	struct mctp_dev *mdev;
 
 	/* Already registered? */
-	mdev = rtnl_dereference(dev->mctp_ptr);
-
-	if (mdev) {
-		if (!mctp_known(dev))
-			netdev_warn(dev, "%s: BUG mctp_ptr set for unknown type %d",
-				    __func__, dev->type);
+	if (rtnl_dereference(dev->mctp_ptr))
 		return 0;
-	}
 
 	/* only register specific types */
 	if (!mctp_known(dev))
-- 
2.35.1



