Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860D5539E0D
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 09:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350307AbiFAHTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 03:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350323AbiFAHTq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 03:19:46 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B5C4BBBB;
        Wed,  1 Jun 2022 00:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=gMGWTaI8TuzmxxnKJACjMmqrnSBgJQ1mqmrPulLBg5g=; t=1654067984; x=1655277584; 
        b=oAEMrxFBWGoguN8uht39YyDRvFmcuiCjaz7mwCJp2YmVdcVeeB5cYwyNSHPd319eYgT6hKE88Xa
        9iGR752+Gd7QHX4HQiSsKf4SobvU0Ooinh9crQIK/lgwq0VHsVqp05w6TXjicnTuXkNAa5PtV6qsE
        1xcV/ma1p/HtWg6e8Bi4BOISUVCotBOYSQlh9skv1Jrqc3hBJ/R9l1Wk6mEsma6Sl8Xn8Fuvf7eLU
        dA2BbTrTCIth7Zsgr6Ln41rqGXRp37zUG8UUqhzaHhRUZPUywJyFSPN5TpEIGGXtC62ddI4cr2TE2
        Imh1eaq7j1OjnljLpHGTYgmC3aj8mGR9oUxg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nwIdo-00AIjQ-Ry;
        Wed, 01 Jun 2022 09:19:40 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org
Subject: [PATCH] mac80211: fix use-after-free in chanctx code
Date:   Wed,  1 Jun 2022 09:19:36 +0200
Message-Id: <20220601091926.df419d91b165.I17a9b3894ff0b8323ce2afdb153b101124c821e5@changeid>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In ieee80211_vif_use_reserved_context(), when we have an
old context and the new context's replace_state is set to
IEEE80211_CHANCTX_REPLACE_NONE, we free the old context
in ieee80211_vif_use_reserved_reassign(). Therefore, we
cannot check the old_ctx anymore, so we should set it to
NULL after this point.

However, since the new_ctx replace state is clearly not
IEEE80211_CHANCTX_REPLACES_OTHER, we're not going to do
anything else in this function and can just return to
avoid accessing the freed old_ctx.

Cc: stable@vger.kernel.org
Fixes: 5bcae31d9cb1 ("mac80211: implement multi-vif in-place reservations")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/chan.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 7b249264af09..5d8b49f20198 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -1750,12 +1750,9 @@ int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata)
 
 	if (new_ctx->replace_state == IEEE80211_CHANCTX_REPLACE_NONE) {
 		if (old_ctx)
-			err = ieee80211_vif_use_reserved_reassign(sdata);
-		else
-			err = ieee80211_vif_use_reserved_assign(sdata);
+			return ieee80211_vif_use_reserved_reassign(sdata);
 
-		if (err)
-			return err;
+		return ieee80211_vif_use_reserved_assign(sdata);
 	}
 
 	/*
-- 
2.36.1

