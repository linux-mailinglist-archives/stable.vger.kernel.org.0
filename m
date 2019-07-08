Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBF0D6217D
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732640AbfGHPQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:16:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732622AbfGHPQn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:16:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2E56216E3;
        Mon,  8 Jul 2019 15:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599003;
        bh=jPUtAY0aRIOFzQ+zGaxTILOGg7nWtlDKM2DBfxvPVZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTVmyrlJgZqHJXvm/YeAFi88JsgahkOUrsiHt6hsDYdOPuOLBGgvKVTyI+MaKIP4y
         0GaetC191OvPr/RrMQojhezoh43PkzGrB8KWpB2qg49eDwslxkacHdxDY5lnxIQV21
         pp75g3Dn/vWdijTlvUggLsmh+XiRwRBJBTVPdbAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.4 28/73] mac80211: drop robust management frames from unknown TA
Date:   Mon,  8 Jul 2019 17:12:38 +0200
Message-Id: <20190708150522.494806945@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 588f7d39b3592a36fb7702ae3b8bdd9be4621e2f upstream.

When receiving a robust management frame, drop it if we don't have
rx->sta since then we don't have a security association and thus
couldn't possibly validate the frame.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/rx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3324,6 +3324,8 @@ static bool ieee80211_accept_frame(struc
 	case NL80211_IFTYPE_STATION:
 		if (!bssid && !sdata->u.mgd.use_4addr)
 			return false;
+		if (ieee80211_is_robust_mgmt_frame(skb) && !rx->sta)
+			return false;
 		if (multicast)
 			return true;
 		return ether_addr_equal(sdata->vif.addr, hdr->addr1);


