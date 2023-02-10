Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82499692929
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 22:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbjBJVWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 16:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjBJVWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 16:22:20 -0500
Received: from mail-4323.proton.ch (mail-4323.proton.ch [185.70.43.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F1272DF7
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 13:22:17 -0800 (PST)
Date:   Fri, 10 Feb 2023 21:22:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemb.ch;
        s=protonmail; t=1676064135; x=1676323335;
        bh=/yDUn5YxSnSJ0YVlmOrlV6K8CJsZnDgQARF+6ZbpYMU=;
        h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=Kp05vDPa9KEOV6NL0nuTVLXSIvT6vOohhiNqj5ZUQxqWtXzru1aKY+tJQOXg6GQ09
         +LVENsTBG1go3DzUnlGTzeopYEe5+qiSKCU4Y2ZHLrrme2oi1MmF2OtCVLyBfNxolf
         5sEp/lziWppKRH4CkO8H3+246WVlRs/Ywa646MxwWdC52hLSnVZdzXz/kcCwfzQ2EX
         3KkB4yjIXzofDTJ/GUEPua8yr0b6DpZ/sdyV5VTtZCotmNqvSZs9rJGNKOh8tYHvzv
         YjK+azwPjyKj/aU6HJNK8BFJ935Tdtx2Od4bXzjpxJGh9L485FjHUzf2SongYwaHGU
         x60cqvnQVjKSg==
To:     Johannes Berg <johannes@sipsolutions.net>
From:   Marc Bornand <dev.mbornand@systemb.ch>
Cc:     Marc Bornand <dev.mbornand@systemb.ch>,
        Yohan Prod'homme <kernel@zoddo.fr>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] Set ssid when authenticating
Message-ID: <20230210212057.83161-1-dev.mbornand@systemb.ch>
Feedback-ID: 65519157:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When a connexion was established without going through
NL80211_CMD_CONNECT, the ssid was never set in the wireless_dev struct.
Now we set it during when an NL80211_CMD_AUTHENTICATE is issued.

It may be needed to test this on some additional hardware (tested with
iwlwifi and a AX201, and iwd on the userspace side), I could not test
things like roaming and p2p.

This applies to v6.2-rc7,
but I think it may also be interesting to backport it from 5.19 to 6.1

Reported-by: Yohan Prod'homme <kernel@zoddo.fr>
Fixes: 7b0a0e3c3a88260b6fcb017e49f198463aa62ed1
Cc: linux-wireless@vger.kernel.org
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D216711
Signed-off-by: Marc Bornand <dev.mbornand@systemb.ch>
---
 net/wireless/nl80211.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 33a82ecab9d5..f1627ea542b9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10552,6 +10552,10 @@ static int nl80211_authenticate(struct sk_buff *sk=
b, struct genl_info *info)
 =09=09return -ENOENT;

 =09wdev_lock(dev->ieee80211_ptr);
+
+=09memcpy(dev->ieee80211_ptr->u.client.ssid, ssid, ssid_len);
+=09dev->ieee80211_ptr->u.client.ssid_len =3D ssid_len;
+
 =09err =3D cfg80211_mlme_auth(rdev, dev, &req);
 =09wdev_unlock(dev->ieee80211_ptr);

@@ -11025,6 +11029,11 @@ static int nl80211_deauthenticate(struct sk_buff *=
skb, struct genl_info *info)
 =09local_state_change =3D !!info->attrs[NL80211_ATTR_LOCAL_STATE_CHANGE];

 =09wdev_lock(dev->ieee80211_ptr);
+
+=09if (reason_code =3D=3D WLAN_REASON_DEAUTH_LEAVING) {
+=09=09dev->ieee80211_ptr->u.client.ssid_len =3D 0;
+=09}
+
 =09err =3D cfg80211_mlme_deauth(rdev, dev, bssid, ie, ie_len, reason_code,
 =09=09=09=09   local_state_change);
 =09wdev_unlock(dev->ieee80211_ptr);
--
2.39.1


