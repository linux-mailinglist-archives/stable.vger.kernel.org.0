Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8CD1657EDE
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbiL1P6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbiL1P6b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:58:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4BC183B8
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:58:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8E05B8172B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5D1C433D2;
        Wed, 28 Dec 2022 15:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243108;
        bh=QDdP89T/Or1/pLj/acPfQsyvLejjtNwFxCss6gEQBG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkMmeU22jMLVJReDdQLdpQC1K9kZ0e95KWakoqnHeQ0hQA6dZ13WF2CmqkmzwFZ5P
         aIJvQyiBMpXscZcziDTPU2/Ds/Okv/ZC56s+wILfbTVH7zxF061TI1bRJiwQFeV03k
         XSIATp/6RWSKABROsnWBLHD9M0ovbrxIFmW8VyoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0452/1146] wifi: mac80211: fix maybe-unused warning
Date:   Wed, 28 Dec 2022 15:33:11 +0100
Message-Id: <20221228144342.459540068@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Íñigo Huguet <ihuguet@redhat.com>

[ Upstream commit 09d838a457a89883a926b8b0104d575158fd4b92 ]

In ieee80211_lookup_key, the variable named `local` is unused if
compiled without lockdep, getting this warning:

net/mac80211/cfg.c: In function ‘ieee80211_lookup_key’:
net/mac80211/cfg.c:542:26: error: unused variable ‘local’ [-Werror=unused-variable]
  struct ieee80211_local *local = sdata->local;
                          ^~~~~

Fix it with __maybe_unused.

Fixes: 8cbf0c2ab6df ("wifi: mac80211: refactor some key code")
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
Link: https://lore.kernel.org/r/20221111153622.29016-1-ihuguet@redhat.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 687b4c878d4a..8c8ef87997a8 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -576,7 +576,7 @@ static struct ieee80211_key *
 ieee80211_lookup_key(struct ieee80211_sub_if_data *sdata, int link_id,
 		     u8 key_idx, bool pairwise, const u8 *mac_addr)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_local *local __maybe_unused = sdata->local;
 	struct ieee80211_link_data *link = &sdata->deflink;
 	struct ieee80211_key *key;
 
-- 
2.35.1



