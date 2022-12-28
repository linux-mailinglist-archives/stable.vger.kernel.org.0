Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50FD265837E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbiL1QsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbiL1Qrp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:47:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2841CFFF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:43:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC7B56157A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D449DC433EF;
        Wed, 28 Dec 2022 16:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245786;
        bh=KwN2bMdPre7EeSZ84sX1w8C+zSF1PheaV2lQkhgNTPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NsRGFb0Y7IJmnWr0HoX9uFVLS2cs9tyPDMmD9ydi9iEgqQGwpjDbVnzOtHsDrqc1Y
         32K8rch4lnNYIj1AsWd0EDBgr/uEDhxwq3vcspXJoBp5bwQJDfVBDL+setSyf/qQgD
         qPSY/IgNtyP1vnAp/SkRTeUBaV0jR8cDI0I63sFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0954/1073] ethtool: avoiding integer overflow in ethtool_phys_id()
Date:   Wed, 28 Dec 2022 15:42:22 +0100
Message-Id: <20221228144353.946021439@linuxfoundation.org>
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
index 6a7308de192d..6b59e7a1c906 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2007,7 +2007,8 @@ static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
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



