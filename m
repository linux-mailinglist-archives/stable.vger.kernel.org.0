Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B27C4E766A
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241729AbiCYPPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376930AbiCYPNq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:13:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A34DCA9C;
        Fri, 25 Mar 2022 08:10:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5B7AB82889;
        Fri, 25 Mar 2022 15:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14B4C340F6;
        Fri, 25 Mar 2022 15:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221039;
        bh=e30E1qyhApEMmdwQ8tSTzlTGF5Bw5t9mN/4JtSAI1ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eq0QNSAh1oQjNNkHBMzuknsjpNseVVBXl5ipk23l6k3cagy4r1D0WgRBYWU9k4xzF
         GtHMEOkKK4bdO/4kvji/5/8/Sod/Kphc/91yLepNr7Cu8USEjU8M8YLOgng2865Hvj
         BEy5AhDnU5BOOJux+i5zb4BgLYAKRh8T1F+8GyRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <ll@simonwunderlich.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 35/38] mac80211: fix potential double free on mesh join
Date:   Fri, 25 Mar 2022 16:05:19 +0100
Message-Id: <20220325150420.754198987@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150419.757836392@linuxfoundation.org>
References: <20220325150419.757836392@linuxfoundation.org>
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

From: Linus Lüssing <ll@simonwunderlich.de>

commit 4a2d4496e15ea5bb5c8e83b94ca8ca7fb045e7d3 upstream.

While commit 6a01afcf8468 ("mac80211: mesh: Free ie data when leaving
mesh") fixed a memory leak on mesh leave / teardown it introduced a
potential memory corruption caused by a double free when rejoining the
mesh:

  ieee80211_leave_mesh()
  -> kfree(sdata->u.mesh.ie);
  ...
  ieee80211_join_mesh()
  -> copy_mesh_setup()
     -> old_ie = ifmsh->ie;
     -> kfree(old_ie);

This double free / kernel panics can be reproduced by using wpa_supplicant
with an encrypted mesh (if set up without encryption via "iw" then
ifmsh->ie is always NULL, which avoids this issue). And then calling:

  $ iw dev mesh0 mesh leave
  $ iw dev mesh0 mesh join my-mesh

Note that typically these commands are not used / working when using
wpa_supplicant. And it seems that wpa_supplicant or wpa_cli are going
through a NETDEV_DOWN/NETDEV_UP cycle between a mesh leave and mesh join
where the NETDEV_UP resets the mesh.ie to NULL via a memcpy of
default_mesh_setup in cfg80211_netdev_notifier_call, which then avoids
the memory corruption, too.

The issue was first observed in an application which was not using
wpa_supplicant but "Senf" instead, which implements its own calls to
nl80211.

Fixing the issue by removing the kfree()'ing of the mesh IE in the mesh
join function and leaving it solely up to the mesh leave to free the
mesh IE.

Cc: stable@vger.kernel.org
Fixes: 6a01afcf8468 ("mac80211: mesh: Free ie data when leaving mesh")
Reported-by: Matthias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
Signed-off-by: Linus Lüssing <ll@simonwunderlich.de>
Tested-by: Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
Link: https://lore.kernel.org/r/20220310183513.28589-1-linus.luessing@c0d3.blue
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/cfg.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2076,14 +2076,12 @@ static int copy_mesh_setup(struct ieee80
 		const struct mesh_setup *setup)
 {
 	u8 *new_ie;
-	const u8 *old_ie;
 	struct ieee80211_sub_if_data *sdata = container_of(ifmsh,
 					struct ieee80211_sub_if_data, u.mesh);
 	int i;
 
 	/* allocate information elements */
 	new_ie = NULL;
-	old_ie = ifmsh->ie;
 
 	if (setup->ie_len) {
 		new_ie = kmemdup(setup->ie, setup->ie_len,
@@ -2093,7 +2091,6 @@ static int copy_mesh_setup(struct ieee80
 	}
 	ifmsh->ie_len = setup->ie_len;
 	ifmsh->ie = new_ie;
-	kfree(old_ie);
 
 	/* now copy the rest of the setup parameters */
 	ifmsh->mesh_id_len = setup->mesh_id_len;


