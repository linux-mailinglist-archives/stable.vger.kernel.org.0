Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2F4604147
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiJSKly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232043AbiJSKlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:41:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9A06346;
        Wed, 19 Oct 2022 03:19:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 150BEB8239C;
        Wed, 19 Oct 2022 08:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DDE3C433D7;
        Wed, 19 Oct 2022 08:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169524;
        bh=0rl2z4tAdKp81nWROTRI1+4Lj05dL4bQD7NiLYtYuRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDJz5hR1jIq5fKQh8W6f3zWYkstLZXX/BU6ots9kDonAIXkRAv7RHiGZP2Qioh98F
         k0lFczFm3Sv4fxZrKi+b/wsfKIo/quU8w0nJ/S+kpDSMrE1Cz42CmhuKJxLW3QKqX+
         QAXQdHRloYrwjD6DYqbtCVA5T+Qy1AFuqlHQ1zsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 266/862] wifi: mac80211: mlme: assign link address correctly
Date:   Wed, 19 Oct 2022 10:25:53 +0200
Message-Id: <20221019083301.786453547@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit acdc3e47881d86dc1cb89d4603e3fed90ab150db ]

Right now, we assign the link address only after we add
the link to the driver, which is quite obviously wrong.
It happens to work in many cases because it gets updated
immediately, and then link_conf updates may update it,
but it's clearly not really right.

Set the link address during ieee80211_mgd_setup_link()
so it's set before telling the driver about the link.

Fixes: 81151ce462e5 ("wifi: mac80211: support MLO authentication/association with one link")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 76ae6f03d77e..654414caeb71 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6291,6 +6291,8 @@ void ieee80211_mgd_setup_link(struct ieee80211_link_data *link)
 	if (sdata->u.mgd.assoc_data)
 		ether_addr_copy(link->conf->addr,
 				sdata->u.mgd.assoc_data->link[link_id].addr);
+	else if (!is_valid_ether_addr(link->conf->addr))
+		eth_random_addr(link->conf->addr);
 }
 
 /* scan finished notification */
@@ -6378,9 +6380,6 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 		goto out_err;
 	}
 
-	if (mlo && !is_valid_ether_addr(link->conf->addr))
-		eth_random_addr(link->conf->addr);
-
 	if (WARN_ON(!ifmgd->auth_data && !ifmgd->assoc_data)) {
 		err = -EINVAL;
 		goto out_err;
-- 
2.35.1



