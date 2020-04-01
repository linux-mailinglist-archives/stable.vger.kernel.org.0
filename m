Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08D7519B378
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388933AbgDAQhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388936AbgDAQhN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:37:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB5AC20658;
        Wed,  1 Apr 2020 16:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759032;
        bh=ZkfJrT9V50vG+aQGnn9VvvlNy5AIoNeX22Kv/9I1x5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w35pQVETvY/uqPh1VI9JeB/IFooz/C4up0Z3D7QI519UZi3fX4CwLqS4o33Z16+/o
         1e7FciLKMVXRXuvnG0/kYlLpjZgpjddQ1NKCqYd2UBix1mZGv5z6fl/CbXRCXGqhI5
         z/v6A0ayLWPt1KuDeeGbvYXVrdemxoJl0suob10I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 055/102] mac80211: Do not send mesh HWMP PREQ if HWMP is disabled
Date:   Wed,  1 Apr 2020 18:17:58 +0200
Message-Id: <20200401161542.908129922@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
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
index 5f4c228b82e56..f7eaa1051b5b2 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1131,7 +1131,8 @@ int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (!(mpath->flags & MESH_PATH_RESOLVING))
+	if (!(mpath->flags & MESH_PATH_RESOLVING) &&
+	    mesh_path_sel_is_hwmp(sdata))
 		mesh_queue_preq(mpath, PREQ_Q_F_START);
 
 	if (skb_queue_len(&mpath->frame_queue) >= MESH_FRAME_QUEUE_LEN)
-- 
2.20.1



