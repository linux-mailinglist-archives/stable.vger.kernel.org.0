Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41A335074F
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbfFXKGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:06:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730147AbfFXKGj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:06:39 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C586D2146F;
        Mon, 24 Jun 2019 10:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370798;
        bh=0UShVwJkVQmYqGoIXL46mVMoloO+EmCe9/+uzLfXZDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I+pFKUVUhjalcZf9uOgEnfvuel87nqipVCmoLCabxcRss6wjG3OfiDs1IGR7Z0T3Y
         61iF1r+OWwjq8GirpVw9x6pPvCWE2yMqLOtdNWnD1tgnAHCQRCtzcAabv5I/ovFEzk
         hja69o+o+PWloIZtgAK4dFOlWUvzK43Rhkr7aj0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Strohman <andy@uplevelsystems.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 88/90] nl80211: fix station_info pertid memory leak
Date:   Mon, 24 Jun 2019 17:57:18 +0800
Message-Id: <20190624092319.649008473@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Strohman <andrew@andrewstrohman.com>

commit f77bf4863dc2218362f4227d56af4a5f3f08830c upstream.

When dumping stations, memory allocated for station_info's
pertid member will leak if the nl80211 header cannot be added to
the sk_buff due to insufficient tail room.

I noticed this leak in the kmalloc-2048 cache.

Cc: stable@vger.kernel.org
Fixes: 8689c051a201 ("cfg80211: dynamically allocate per-tid stats for station info")
Signed-off-by: Andy Strohman <andy@uplevelsystems.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4611,8 +4611,10 @@ static int nl80211_send_station(struct s
 	struct nlattr *sinfoattr, *bss_param;
 
 	hdr = nl80211hdr_put(msg, portid, seq, flags, cmd);
-	if (!hdr)
+	if (!hdr) {
+		cfg80211_sinfo_release_content(sinfo);
 		return -1;
+	}
 
 	if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
 	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr) ||


