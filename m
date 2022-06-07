Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B705413AD
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358081AbiFGUDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358060AbiFGUCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:02:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62398E8BA2;
        Tue,  7 Jun 2022 11:25:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20908B82389;
        Tue,  7 Jun 2022 18:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E9BC385A2;
        Tue,  7 Jun 2022 18:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626303;
        bh=bECevGEJQRm9zlwoTsq4nSUU2ACxTtNGL7gJ4lWePVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZPVqThyBtxgBOvI6VdSJgmawB3eBna5Q2ALXsaMoqnTx6SKjEveSOjLBpUmgveoG/
         KmEbDBNWJEf+nvcwAAGo4ZKLgub+EnQT6mI2bJu7oMCwpoG5WGDC8Vy6+mxH3kjMRh
         vj6PNJRea5lJt3o8uciENGoPdUHF/qUFt/Nk4Plo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 329/772] nl80211: dont hold RTNL in color change request
Date:   Tue,  7 Jun 2022 18:58:41 +0200
Message-Id: <20220607164958.718055320@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1b550a0bebfc0b69d6ec08fe6eb58953a8aec48a ]

It's not necessary to hold the RTNL across color change
requests, since all the inner locking needs only the
wiphy mutex which we already hold as well.

Fixes: 0d2ab3aea50b ("nl80211: add support for BSS coloring")
Link: https://lore.kernel.org/r/20220414140402.32e03e8c261b.I5e7dc6bc563a129b938c43298da6bb4e812400a5@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ba53bc820d81..0aad974f17a7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -16194,8 +16194,7 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_color_change,
 		.flags = GENL_UNS_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-				  NL80211_FLAG_NEED_RTNL,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP,
 	},
 	{
 		.cmd = NL80211_CMD_SET_FILS_AAD,
-- 
2.35.1



