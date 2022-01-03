Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5B6483319
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbiACOd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234248AbiACOa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:30:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88618C0698DB;
        Mon,  3 Jan 2022 06:30:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24ADA61128;
        Mon,  3 Jan 2022 14:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03863C36AEB;
        Mon,  3 Jan 2022 14:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220240;
        bh=7RvUQ41C4f6GI7c8r/CeoDN6FEEtfVhPCeyOVvcAP00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SMIxiy6FVGFapXmDm1C/4psM8X6LaBU4cts+gryZeSuonPRaNyNENtmqkmlfYrvdJ
         yGznitaoLOm9INELjUWt7XR+RmvthKZQht5xAzTTYFyJq68lCsU6deCwBgQ5m4eeWW
         3iHDD/79uHGVQRaIa8jvND/rsllywjYVQG/5lcFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 30/48] net/ncsi: check for error return from call to nla_put_u32
Date:   Mon,  3 Jan 2022 15:24:07 +0100
Message-Id: <20220103142054.495351549@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 92a34ab169f9eefe29cd420ce96b0a0a2a1da853 ]

As we can see from the comment of the nla_put() that it could return
-EMSGSIZE if the tailroom of the skb is insufficient.
Therefore, it should be better to check the return value of the
nla_put_u32 and return the error code if error accurs.
Also, there are many other functions have the same problem, and if this
patch is correct, I will commit a new version to fix all.

Fixes: 955dc68cb9b2 ("net/ncsi: Add generic netlink family")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20211229032118.1706294-1-jiasheng@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ncsi/ncsi-netlink.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ncsi/ncsi-netlink.c b/net/ncsi/ncsi-netlink.c
index bb5f1650f11cb..c189b4c8a1823 100644
--- a/net/ncsi/ncsi-netlink.c
+++ b/net/ncsi/ncsi-netlink.c
@@ -112,7 +112,11 @@ static int ncsi_write_package_info(struct sk_buff *skb,
 		pnest = nla_nest_start_noflag(skb, NCSI_PKG_ATTR);
 		if (!pnest)
 			return -ENOMEM;
-		nla_put_u32(skb, NCSI_PKG_ATTR_ID, np->id);
+		rc = nla_put_u32(skb, NCSI_PKG_ATTR_ID, np->id);
+		if (rc) {
+			nla_nest_cancel(skb, pnest);
+			return rc;
+		}
 		if ((0x1 << np->id) == ndp->package_whitelist)
 			nla_put_flag(skb, NCSI_PKG_ATTR_FORCED);
 		cnest = nla_nest_start_noflag(skb, NCSI_PKG_ATTR_CHANNEL_LIST);
-- 
2.34.1



