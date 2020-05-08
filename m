Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941271CAF8A
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgEHMlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:41:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728801AbgEHMlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:41:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C61B020731;
        Fri,  8 May 2020 12:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941675;
        bh=SoH5jBDhuV4IM6MIA+ZA/Z2HW9G0P3TkRawdTS8TkI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fUIfb7slSPKSZbEvCkzL79QjPmrZgh2FbPKEHLT2JTrreizxD6X2ynX9r6ywb1BeV
         u/ZIR3CIWVjLci3WzTgzu6WTY/XYCO4AH4kjDz25qWC9IrZIKOp19uKvKHp+xuQtT8
         trfy8WJqojoMu4uKKVHhRkrJDTt2iVOCLxUR8+Qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arik Nemtsov <arikx.nemtsov@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.4 127/312] mac80211: TDLS: always downgrade invalid chandefs
Date:   Fri,  8 May 2020 14:31:58 +0200
Message-Id: <20200508123133.437228718@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arik Nemtsov <arik@wizery.com>

commit db8d99774c2682559b7648857697b9b588c6795a upstream.

Even if the current chandef width is equal to the station's max-BW, it
doesn't mean it's a valid width for TDLS. Make sure to always check
regulatory constraints in these cases.

Fixes: 0fabfaafec3a ("mac80211: upgrade BW of TDLS peers when possible")
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/tdls.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -332,7 +332,7 @@ ieee80211_tdls_chandef_vht_upgrade(struc
 		return;
 
 	/* proceed to downgrade the chandef until usable or the same */
-	while (uc.width > max_width &&
+	while (uc.width > max_width ||
 	       !cfg80211_reg_can_beacon_relax(sdata->local->hw.wiphy, &uc,
 					      sdata->wdev.iftype))
 		ieee80211_chandef_downgrade(&uc);


