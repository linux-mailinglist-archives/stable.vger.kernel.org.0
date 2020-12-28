Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7152E4265
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391601AbgL1OCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:02:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391593AbgL1OCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:02:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB81020799;
        Mon, 28 Dec 2020 14:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164099;
        bh=Jgkb4yCMuMlCUzTk9lCQrpRyEkQGvnjCghzrRVr3QlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8LJ94vo0u3XBgk3k6QJeyJeeaRmZrMdNN28JdeZtFYQvpjkEJtgA+YHapGJkUP7O
         eIi6AAvKk2E0l5h2vwMenOQktximIOhMBRe0N4OgIUMflSq1LJRmFIjO6+BGa/YTwN
         TKj6T3CyZPiijtgIFELNBoqo/8zsgyGUNmI6EO8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/717] nl80211/cfg80211: fix potential infinite loop
Date:   Mon, 28 Dec 2020 13:40:58 +0100
Message-Id: <20201228125023.872264837@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit ba5c25236bc3d399df82ebe923490ea8d2d35cf2 ]

The for-loop iterates with a u8 loop counter and compares this
with the loop upper limit of request->n_ssids which is an int type.
There is a potential infinite loop if n_ssids is larger than the
u8 loop counter, so fix this by making the loop counter an int.

Addresses-Coverity: ("Infinite loop")
Fixes: c8cb5b854b40 ("nl80211/cfg80211: support 6 GHz scanning")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20201029222407.390218-1-colin.king@canonical.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 8d0e49c46db37..3409f37d838b3 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -694,7 +694,7 @@ static  void cfg80211_scan_req_add_chan(struct cfg80211_scan_request *request,
 static bool cfg80211_find_ssid_match(struct cfg80211_colocated_ap *ap,
 				     struct cfg80211_scan_request *request)
 {
-	u8 i;
+	int i;
 	u32 s_ssid;
 
 	for (i = 0; i < request->n_ssids; i++) {
-- 
2.27.0



