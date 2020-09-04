Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7685125DB56
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 16:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730330AbgIDOVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 10:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730416AbgIDNeY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 09:34:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8242021527;
        Fri,  4 Sep 2020 13:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599226277;
        bh=eqFhAXZbmT26mUEhpjJJVcnWgVNwi5MXc9wL2qtl/7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=atuO0HeADBwnfIbz6dpC3LvviHrTT9mRPB7Udi8uuaj1VGRkGkamYUuTgSoZal605
         5IQikB9ow2U8EAb/l1k7BeCKA2rDwuj+KzrHfSvKwFbf/u+eI9LW95GSn7QMXorcMC
         c8KBU1dNmjc5r98EgZa7+ugTsknYL50LVAIriGKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.8 16/17] nl80211: fix NL80211_ATTR_HE_6GHZ_CAPABILITY usage
Date:   Fri,  4 Sep 2020 15:30:15 +0200
Message-Id: <20200904120258.791596514@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904120257.983551609@linuxfoundation.org>
References: <20200904120257.983551609@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit fce2ff728f95b8894db14f51c9274dc56c37616f upstream.

In nl80211_set_station(), we check NL80211_ATTR_HE_6GHZ_CAPABILITY
and then use NL80211_ATTR_HE_CAPABILITY, which is clearly wrong.
Fix this to use NL80211_ATTR_HE_6GHZ_CAPABILITY as well.

Cc: stable@vger.kernel.org
Fixes: 43e64bf301fd ("cfg80211: handle 6 GHz capability of new station")
Link: https://lore.kernel.org/r/20200805153516.310cef625955.I0abc04dc8abb2c7c005c88ef8fa2d0e3c9fb95c4@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6010,7 +6010,7 @@ static int nl80211_set_station(struct sk
 
 	if (info->attrs[NL80211_ATTR_HE_6GHZ_CAPABILITY])
 		params.he_6ghz_capa =
-			nla_data(info->attrs[NL80211_ATTR_HE_CAPABILITY]);
+			nla_data(info->attrs[NL80211_ATTR_HE_6GHZ_CAPABILITY]);
 
 	if (info->attrs[NL80211_ATTR_AIRTIME_WEIGHT])
 		params.airtime_weight =


