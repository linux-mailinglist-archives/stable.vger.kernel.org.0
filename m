Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2553941749C
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345824AbhIXNIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:08:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346220AbhIXNGV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:06:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 930B461527;
        Fri, 24 Sep 2021 12:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488174;
        bh=QizMIpa0QtvyZoXQlmPueuCp52/H2FRPL3dRQanF784=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=igXFLNnQvolM5fTv1y8CUtUMIZlSnE/QKlfGFecJeREpE5T60M52s6TeDKh76m9JJ
         OfpRbCybO4ypsNNjsUOzAOd2nfqCMbGOZ5vooMS/4C5c6tuJYyURGhnZIYh2ov9GIp
         /uBrQeYPUmE8zMffZ1DSBLAbeArWJI36Dv8ouf8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.10 13/63] staging: rtl8192u: Fix bitwise vs logical operator in TranslateRxSignalStuff819xUsb()
Date:   Fri, 24 Sep 2021 14:44:13 +0200
Message-Id: <20210924124334.697478717@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 099ec97ac92911abfb102bb5c68ed270fc12e0dd upstream.

clang warns:

drivers/staging/rtl8192u/r8192U_core.c:4268:20: warning: bitwise and of
boolean expressions; did you mean logical and? [-Wbool-operation-and]
        bpacket_toself =  bpacket_match_bssid &
                          ^~~~~~~~~~~~~~~~~~~~~
                                              &&
1 warning generated.

Replace the bitwise AND with a logical one to clear up the warning, as
that is clearly what was intended.

Fixes: 8fc8598e61f6 ("Staging: Added Realtek rtl8192u driver to staging")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20210814235625.1780033-1-nathan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8192u/r8192U_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -4271,7 +4271,7 @@ static void TranslateRxSignalStuff819xUs
 	bpacket_match_bssid = (type != IEEE80211_FTYPE_CTL) &&
 			       (ether_addr_equal(priv->ieee80211->current_network.bssid,  (fc & IEEE80211_FCTL_TODS) ? hdr->addr1 : (fc & IEEE80211_FCTL_FROMDS) ? hdr->addr2 : hdr->addr3))
 			       && (!pstats->bHwError) && (!pstats->bCRC) && (!pstats->bICV);
-	bpacket_toself =  bpacket_match_bssid &
+	bpacket_toself =  bpacket_match_bssid &&
 			  (ether_addr_equal(praddr, priv->ieee80211->dev->dev_addr));
 
 	if (WLAN_FC_GET_FRAMETYPE(fc) == IEEE80211_STYPE_BEACON)


