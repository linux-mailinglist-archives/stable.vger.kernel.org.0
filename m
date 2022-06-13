Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6191754940B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352991AbiFMLUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353811AbiFMLT6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:19:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAD23B560;
        Mon, 13 Jun 2022 03:41:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9E2AB80EAA;
        Mon, 13 Jun 2022 10:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A08AC34114;
        Mon, 13 Jun 2022 10:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116903;
        bh=ywtWzVs7H9aRp2wlE0OHMeZsDuk5hC5P/5o+5/xR1co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=frb5zTWbZX+zgqSFERLRPaQ3AkfY6On2UYRrIEUZvHGTlYfhPoH9WxfkvEU38oG2W
         +Fep54dqDParHiYP4BsYL37+ISwgDiupQBnHxghUCFQqD2sB45iUvVUce2tO3XdXlX
         VqpWdNYjnc0khjHtbc2M/hREo4MguHyR/zM/5m+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.4 215/411] wifi: mac80211: fix use-after-free in chanctx code
Date:   Mon, 13 Jun 2022 12:08:08 +0200
Message-Id: <20220613094935.099721778@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

commit 2965c4cdf7ad9ce0796fac5e57debb9519ea721e upstream.

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
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220601091926.df419d91b165.I17a9b3894ff0b8323ce2afdb153b101124c821e5@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/chan.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -1639,12 +1639,9 @@ int ieee80211_vif_use_reserved_context(s
 
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


