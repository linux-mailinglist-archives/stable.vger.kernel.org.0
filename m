Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101BE44AA07
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 10:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244648AbhKIJF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 04:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244654AbhKIJFZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 04:05:25 -0500
Received: from sipsolutions.net (unknown [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AAEEC061208;
        Tue,  9 Nov 2021 01:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=t5WgVOcn15IqoYJwyRCsxPJzQR7NdaTh+b+6zeOUfSQ=; t=1636448535; x=1637658135; 
        b=dr6lhfUzND4W99D4QVXjW2XTMvPpAQ6qVO+xIow4OKYyZCBL8v071WlWBk5jljjbHu5sdFa5BWP
        CL9sU6g8Z9ohmefTJkOOGSwKGAyMF2PdUyykrAZCtAyEBiBwG2Ir3xuFgfo5BBigQ9G5tA0lZ5O0D
        usWNbO3Aw4bJCROQrSKEjLE6dl2Bcu/Id4rokG+9/Rv15b1b3yNcOvmVCN0TKEitEI4dwdG1QnJcI
        RQVA1odf3Zd9eNO/KX9UvqpNC98QAJAuaNfybLLr14aeGwezvTN9A13XkAN7OrZ2M4S2SMHfn1QmX
        AFb5ZL2u5eWK9bYk8Bz3ZmpBztQ6jV58GDrg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mkN15-00CtyF-Ua;
        Tue, 09 Nov 2021 10:02:08 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Johannes Berg <johannes.berg@intel.com>,
        stable@vger.kernel.org, Sid Hayn <sidhayn@gmail.com>
Subject: [PATCH] mac80211: fix radiotap header generation
Date:   Tue,  9 Nov 2021 10:02:04 +0100
Message-Id: <20211109100203.c61007433ed6.I1dade57aba7de9c4f48d68249adbae62636fd98c@changeid>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In commit 8c89f7b3d3f2 ("mac80211: Use flex-array for radiotap header
bitmap") we accidentally pointed the position to the wrong place, so
we overwrite a present bitmap, and thus cause all kinds of trouble.

To see the issue, note that the previous code read:

  pos = (void *)(it_present + 1);

The requirement now is that we need to calculate pos via it_optional,
to not trigger the compiler hardening checks, as:

  pos = (void *)&rthdr->it_optional[...];

Rewriting the original expression, we get (obviously, since that just
adds "+ x - x" terms):

  pos = (void *)(it_present + 1 + rthdr->it_optional - rthdr->it_optional)

and moving the "+ rthdr->it_optional" outside to be used as an array:

  pos = (void *)&rthdr->it_optional[it_present + 1 - rthdr->it_optional];

The original is off by one, fix it.

Cc: stable@vger.kernel.org
Fixes: 8c89f7b3d3f2 ("mac80211: Use flex-array for radiotap header bitmap")
Reported-by: Sid Hayn <sidhayn@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index fc5c608d02e2..3562730ea0f8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -364,7 +364,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	 * the compiler to think we have walked past the end of the
 	 * struct member.
 	 */
-	pos = (void *)&rthdr->it_optional[it_present - rthdr->it_optional];
+	pos = (void *)&rthdr->it_optional[it_present + 1 - rthdr->it_optional];
 
 	/* the order of the following fields is important */
 
-- 
2.31.1

