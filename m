Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1523B19915E
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731951AbgCaJQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:16:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731948AbgCaJQS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:16:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B3692072E;
        Tue, 31 Mar 2020 09:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646177;
        bh=CamO4UEFcXfw9TeICbbmIbQ1M6RNs/sXyPRb67bcy08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C0V8XZTLRsvP2cPAEOuXLdbE9xTc1Ls++c9NOgs/KcFdfG8ipaD2JgFg87oDkJHvk
         gGbCj7wo4EWEgVad8P22EBX004M/xnA0bfbmY1fJ6Qy9B0AQFJi/QTcJtk3PH3vzXt
         XFPg5WdGXEd5DAEDguAWTFX1DoaeiuDpFA1TmGfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/155] mac80211: Do not send mesh HWMP PREQ if HWMP is disabled
Date:   Tue, 31 Mar 2020 10:58:29 +0200
Message-Id: <20200331085426.135403360@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>

[ Upstream commit ba32679cac50c38fdf488296f96b1f3175532b8e ]

When trying to transmit to an unknown destination, the mesh code would
unconditionally transmit a HWMP PREQ even if HWMP is not the current
path selection algorithm.

Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Link: https://lore.kernel.org/r/20200305140409.12204-1-cavallar@lri.fr
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_hwmp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index d699833703819..38a0383dfbcfa 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1152,7 +1152,8 @@ int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (!(mpath->flags & MESH_PATH_RESOLVING))
+	if (!(mpath->flags & MESH_PATH_RESOLVING) &&
+	    mesh_path_sel_is_hwmp(sdata))
 		mesh_queue_preq(mpath, PREQ_Q_F_START);
 
 	if (skb_queue_len(&mpath->frame_queue) >= MESH_FRAME_QUEUE_LEN)
-- 
2.20.1



