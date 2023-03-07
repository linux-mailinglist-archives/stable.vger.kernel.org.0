Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4940E6AF27C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbjCGSxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233413AbjCGSxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:53:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD47E9BE1C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:41:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C51AB819CA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D49C433D2;
        Tue,  7 Mar 2023 18:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214452;
        bh=7N2pMwa4SDfRJ7shCeCE8DlvnepL3d6wkMGP3F6k94k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3QpD5v5WCv8syGb4+I9J5qQ0IIFYC6i7rDTeSdzDta1CsJIARuGJGwrgG1Vs+jU8
         fSlc25X7vCS6GKTqGmROIlMgpBOb33BdMUDHv8I0EbtbXq23jlhX2GLyc2b1E15Rn6
         nectSSB5RiLLUp0EU0nxGCN183gVh7C+jerb+iOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yohan Prodhomme <kernel@zoddo.fr>,
        Marc Bornand <dev.mbornand@systemb.ch>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 800/885] wifi: cfg80211: Set SSID if it is not already set
Date:   Tue,  7 Mar 2023 18:02:14 +0100
Message-Id: <20230307170036.656887462@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Bornand <dev.mbornand@systemb.ch>

commit c38c701851011c94ce3be1ccb3593678d2933fd8 upstream.

When a connection was established without going through
NL80211_CMD_CONNECT, the ssid was never set in the wireless_dev struct.
Now we set it in __cfg80211_connect_result() when it is not already set.

When using a userspace configuration that does not call
cfg80211_connect() (can be checked with breakpoints in the kernel),
this patch should allow `networkctl status device_name` to output the
SSID instead of null.

Cc: stable@vger.kernel.org
Reported-by: Yohan Prod'homme <kernel@zoddo.fr>
Fixes: 7b0a0e3c3a88 (wifi: cfg80211: do some rework towards MLO link APIs)
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216711
Signed-off-by: Marc Bornand <dev.mbornand@systemb.ch>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/sme.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -736,6 +736,7 @@ void __cfg80211_connect_result(struct ne
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	const struct element *country_elem = NULL;
+	const struct element *ssid;
 	const u8 *country_data;
 	u8 country_datalen;
 #ifdef CONFIG_CFG80211_WEXT
@@ -881,6 +882,22 @@ void __cfg80211_connect_result(struct ne
 				   country_data, country_datalen);
 	kfree(country_data);
 
+	if (!wdev->u.client.ssid_len) {
+		rcu_read_lock();
+		for_each_valid_link(cr, link) {
+			ssid = ieee80211_bss_get_elem(cr->links[link].bss,
+						      WLAN_EID_SSID);
+
+			if (!ssid || !ssid->datalen)
+				continue;
+
+			memcpy(wdev->u.client.ssid, ssid->data, ssid->datalen);
+			wdev->u.client.ssid_len = ssid->datalen;
+			break;
+		}
+		rcu_read_unlock();
+	}
+
 	return;
 out:
 	for_each_valid_link(cr, link)


