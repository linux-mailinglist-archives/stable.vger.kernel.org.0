Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54C97508AE
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730857AbfFXKVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:21:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730847AbfFXKVx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:21:53 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4ACE120645;
        Mon, 24 Jun 2019 10:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371712;
        bh=zy3TIc91CTwi1EVVwKfDJ9F8ob/YSF3+Uyo8RP+Bj8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FDfYj72jTeEbapjY9nq8ZsYxql75mrKTbZJqP2aOD36Xsl6KLYwdT7xv1PbrdwiBR
         VHk8jZY2U86oge4LvOA0GPCsGaTCfc/gE0N7NKijKlhUgMwVT5ZrEQ4pj/nw3vahdR
         bpzGESe1yoEi3JOPlKP6X0/vG+74IMx/wkRZbz6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Strohman <andy@uplevelsystems.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.1 119/121] nl80211: fix station_info pertid memory leak
Date:   Mon, 24 Jun 2019 17:57:31 +0800
Message-Id: <20190624092326.692565391@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
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
@@ -4804,8 +4804,10 @@ static int nl80211_send_station(struct s
 	struct nlattr *sinfoattr, *bss_param;
 
 	hdr = nl80211hdr_put(msg, portid, seq, flags, cmd);
-	if (!hdr)
+	if (!hdr) {
+		cfg80211_sinfo_release_content(sinfo);
 		return -1;
+	}
 
 	if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
 	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr) ||


