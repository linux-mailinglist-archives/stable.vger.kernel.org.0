Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B453019B119
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387841AbgDAQcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:32:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388373AbgDAQb6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:31:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81AF92063A;
        Wed,  1 Apr 2020 16:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758718;
        bh=VZtQ570IgtuXtdl8BoiCwvfb4bxuN8ufWPzTwgYnKX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZlmTrNks9KiYTR0Sj96StOQNCbu+DkUEf0sHwZbgPO18QqztKa1ARLBNGRrUcg5zM
         /3hLV5yfQhOANyAZG341/lkV0esAWSWx6NSUgMg2C7OCR0ZMtRClXlE/ARyCD+P44q
         5XaP5Mw7ke9yDiYTQPsGxhEGgBFM8kNsbF14c17Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 53/91] mac80211: Do not send mesh HWMP PREQ if HWMP is disabled
Date:   Wed,  1 Apr 2020 18:17:49 +0200
Message-Id: <20200401161531.867952477@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161512.917494101@linuxfoundation.org>
References: <20200401161512.917494101@linuxfoundation.org>
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
index 466922f09d048..43edcba6d67b7 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1112,7 +1112,8 @@ int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (!(mpath->flags & MESH_PATH_RESOLVING))
+	if (!(mpath->flags & MESH_PATH_RESOLVING) &&
+	    mesh_path_sel_is_hwmp(sdata))
 		mesh_queue_preq(mpath, PREQ_Q_F_START);
 
 	if (skb_queue_len(&mpath->frame_queue) >= MESH_FRAME_QUEUE_LEN)
-- 
2.20.1



