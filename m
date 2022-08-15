Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA9F594DAB
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347295AbiHPBEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 21:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349012AbiHPBC1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 21:02:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72DEBA9DA;
        Mon, 15 Aug 2022 13:51:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 629BA61239;
        Mon, 15 Aug 2022 20:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69092C433D6;
        Mon, 15 Aug 2022 20:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596659;
        bh=tWf8Wi3b7/Prk4onpT6cSotfSRDeTf1Vrw/VKciE+D0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OcFmjTcbTjRtDYUIJyxcLX7rSVCEyBdlRZzI9FUkqqretIM8sXvEmuexAmv7++bWi
         LTDHIsV5ldCCQzrYcFA0/v555Uu/HtoEsz3xdX1oDxEKgN+F6qc72VoShgsvtm7UFR
         KG95lEB+aM4p38nhc5Agp1NQHUvtogrkOXdb0i78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.19 1149/1157] wifi: nl80211: relax wdev mutex check in wdev_chandef()
Date:   Mon, 15 Aug 2022 20:08:25 +0200
Message-Id: <20220815180526.483944476@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 31177127e067eb73d5ca46ce32a410e41333d42f upstream.

In many cases we might get here from driver code that's
not really set up to care about the locking, and for the
non-MLO cases we really don't care so much about it. So
relax the checking here for now, perhaps we should even
remove it completely since we might not really care if
we point to an invalid link's chandef and can require
the caller to check the link validity first.

Fixes: 7b0a0e3c3a88 ("wifi: cfg80211: do some rework towards MLO link APIs")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/chan.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -1433,7 +1433,17 @@ EXPORT_SYMBOL(cfg80211_any_usable_channe
 struct cfg80211_chan_def *wdev_chandef(struct wireless_dev *wdev,
 				       unsigned int link_id)
 {
-	ASSERT_WDEV_LOCK(wdev);
+	/*
+	 * We need to sort out the locking here - in some cases
+	 * where we get here we really just don't care (yet)
+	 * about the valid links, but in others we do. But we
+	 * get here with various driver cases, so we cannot
+	 * easily require the wdev mutex.
+	 */
+	if (link_id || wdev->valid_links & BIT(0)) {
+		ASSERT_WDEV_LOCK(wdev);
+		WARN_ON(!(wdev->valid_links & BIT(link_id)));
+	}
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_MESH_POINT:


