Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85937420FA9
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237104AbhJDNhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237184AbhJDNfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:35:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F10061A4F;
        Mon,  4 Oct 2021 13:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353346;
        bh=9TCFDX076KFMFP+Ixj5jt/z7WDpdxK/tcIF1mWSIeR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l4EIbf7txX5CaCsPgbIOdbgz23NyZKX8+IzjSDKfIlzU9mHn18t5lOwueFzGj+xhL
         x5EJZbRKUZb4YZPZVwwfCu5MrpMwsn4/5YFeT62mWKDnQpd5xwCe30y8tfInp5I5eP
         0kkb0POthwvq6ghf6c5vw2wftNEKUpGYAduNk9i0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 091/172] mac80211: mesh: fix potentially unaligned access
Date:   Mon,  4 Oct 2021 14:52:21 +0200
Message-Id: <20211004125047.933592327@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit b9731062ce8afd35cf723bf3a8ad55d208f915a5 ]

The pointer here points directly into the frame, so the
access is potentially unaligned. Use get_unaligned_le16
to avoid that.

Fixes: 3f52b7e328c5 ("mac80211: mesh power save basics")
Link: https://lore.kernel.org/r/20210920154009.3110ff75be0c.Ib6a2ff9e9cc9bc6fca50fce631ec1ce725cc926b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_ps.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 204830a55240..3fbd0b9ff913 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -2,6 +2,7 @@
 /*
  * Copyright 2012-2013, Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>
  * Copyright 2012-2013, cozybit Inc.
+ * Copyright (C) 2021 Intel Corporation
  */
 
 #include "mesh.h"
@@ -588,7 +589,7 @@ void ieee80211_mps_frame_release(struct sta_info *sta,
 
 	/* only transmit to PS STA with announced, non-zero awake window */
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) &&
-	    (!elems->awake_window || !le16_to_cpu(*elems->awake_window)))
+	    (!elems->awake_window || !get_unaligned_le16(elems->awake_window)))
 		return;
 
 	if (!test_sta_flag(sta, WLAN_STA_MPSP_OWNER))
-- 
2.33.0



