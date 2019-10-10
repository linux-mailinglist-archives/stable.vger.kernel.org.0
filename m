Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36BFFD256F
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388616AbfJJJAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 05:00:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387767AbfJJInT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:43:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF2C92190F;
        Thu, 10 Oct 2019 08:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696999;
        bh=Z7qMlZaZcDZIhgD5kbXQoS87jFUa8k4Q4KdfQBxnahk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FWO25hlcnd4xuBLRvFeU7HTJyFBl1AerxaOQ52ZEvKhdP8IGr12hYRuXQd2mLVDX0
         pQ8FqmwogrufWhENNVSNrdarNXgKJWXpTzHOv7DjJclutmFLfD+j7lKldrVDPEn+Bs
         /IGTpofHaH7ia7M4/zIqJ7KFyd3IyFnk/q8r1ZAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.3 086/148] cfg80211: validate SSID/MBSSID element ordering assumption
Date:   Thu, 10 Oct 2019 10:35:47 +0200
Message-Id: <20191010083616.576489163@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 242b0931c1918c56cd1dc5563fd250a3c39b996d upstream.

The code copying the data assumes that the SSID element is
before the MBSSID element, but since the data is untrusted
from the AP, this cannot be guaranteed.

Validate that this is indeed the case and ignore the MBSSID
otherwise, to avoid having to deal with both cases for the
copy of data that should be between them.

Cc: stable@vger.kernel.org
Fixes: 0b8fb8235be8 ("cfg80211: Parsing of Multiple BSSID information in scanning")
Link: https://lore.kernel.org/r/1569009255-I1673911f5eae02964e21bdc11b2bf58e5e207e59@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/scan.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1711,7 +1711,12 @@ cfg80211_update_notlisted_nontrans(struc
 		return;
 	new_ie_len -= trans_ssid[1];
 	mbssid = cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen);
-	if (!mbssid)
+	/*
+	 * It's not valid to have the MBSSID element before SSID
+	 * ignore if that happens - the code below assumes it is
+	 * after (while copying things inbetween).
+	 */
+	if (!mbssid || mbssid < trans_ssid)
 		return;
 	new_ie_len -= mbssid[1];
 	rcu_read_lock();


