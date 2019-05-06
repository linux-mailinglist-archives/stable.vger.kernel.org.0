Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 114E714E1B
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbfEFOnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:43:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726744AbfEFOni (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:43:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48B8A2053B;
        Mon,  6 May 2019 14:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153817;
        bh=AY/rr051/mQLydbuvcB38cfBT+IR5wgcnc7nCqodeyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eupdRO8wh7mPR6kEa2VnGSuuiYN4x7MoIDD1i78porYcbEeMyYuooletgXds8WFda
         /e71YS8c86qFbNSKa5tAMIZQzWKgkqTlQ0xWrnGWJCc+pok7EpqNwb5lUqQZQm+6mx
         dskOzcFNVoKYIWzw3p6NCAW/xqgKgaKN5OJVCojs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 91/99] mac80211: Honor SW_CRYPTO_CONTROL for unicast keys in AP VLAN mode
Date:   Mon,  6 May 2019 16:33:04 +0200
Message-Id: <20190506143102.134860319@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Wetzel <alexander@wetzel-home.de>

commit 78ad2341521d5ea96cb936244ed4c4c4ef9ec13b upstream.

Restore SW_CRYPTO_CONTROL operation on AP_VLAN interfaces for unicast
keys, the original override was intended to be done for group keys as
those are treated specially by mac80211 and would always have been
rejected.

Now the situation is that AP_VLAN support must be enabled by the driver
if it can support it (meaning it can support software crypto GTK TX).

Thus, also simplify the code - if we get here with AP_VLAN and non-
pairwise key, software crypto must be used (driver doesn't know about
the interface) and can be used (driver must've advertised AP_VLAN if
it also uses SW_CRYPTO_CONTROL).

Fixes: db3bdcb9c3ff ("mac80211: allow AP_VLAN operation on crypto controlled devices")
Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
[rewrite commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/key.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -167,8 +167,10 @@ static int ieee80211_key_enable_hw_accel
 		 * The driver doesn't know anything about VLAN interfaces.
 		 * Hence, don't send GTKs for VLAN interfaces to the driver.
 		 */
-		if (!(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE))
+		if (!(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
+			ret = 1;
 			goto out_unsupported;
+		}
 	}
 
 	ret = drv_set_key(key->local, SET_KEY, sdata,
@@ -213,11 +215,8 @@ static int ieee80211_key_enable_hw_accel
 		/* all of these we can do in software - if driver can */
 		if (ret == 1)
 			return 0;
-		if (ieee80211_hw_check(&key->local->hw, SW_CRYPTO_CONTROL)) {
-			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-				return 0;
+		if (ieee80211_hw_check(&key->local->hw, SW_CRYPTO_CONTROL))
 			return -EINVAL;
-		}
 		return 0;
 	default:
 		return -EINVAL;


