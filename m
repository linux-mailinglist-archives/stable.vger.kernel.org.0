Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A546676CC
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236343AbjALOgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238117AbjALOft (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:35:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE419597
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:26:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5D1660110
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFB8C433EF;
        Thu, 12 Jan 2023 14:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533580;
        bh=Z9/utPV3HyJ/YyA51QPQTpU/ZGH62v8J49esyzJm1UA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6NbF2pqJ05iwKToRQCs3MoDmwLUBIDcobvZiI3RLbH/tgVVkMUz7SD154B7N81AQ
         x49peM8LkZXsJbpQ9aResWSvgjgM66iOlCfnyYZIQaNDtKVmPA8ABvDFXAN4T4kh9v
         GhMdGC2XZg/cMIKigAFxQG339s3viADoSW5mjppk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 524/783] ethtool: avoiding integer overflow in ethtool_phys_id()
Date:   Thu, 12 Jan 2023 14:54:00 +0100
Message-Id: <20230112135548.501344148@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Maxim Korotkov <korotkov.maxim.s@gmail.com>

[ Upstream commit 64a8f8f7127da228d59a39e2c5e75f86590f90b4 ]

The value of an arithmetic expression "n * id.data" is subject
to possible overflow due to a failure to cast operands to a larger data
type before performing arithmetic. Used macro for multiplication instead
operator for avoiding overflow.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20221122122901.22294-1-korotkov.maxim.s@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 80d2a00d3097..47c2dd4a9b9f 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1966,7 +1966,8 @@ static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
 	} else {
 		/* Driver expects to be called at twice the frequency in rc */
 		int n = rc * 2, interval = HZ / n;
-		u64 count = n * id.data, i = 0;
+		u64 count = mul_u32_u32(n, id.data);
+		u64 i = 0;
 
 		do {
 			rtnl_lock();
-- 
2.35.1



