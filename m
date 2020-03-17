Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E08C187FF6
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgCQLGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:06:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728437AbgCQLFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:05:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 515EF20714;
        Tue, 17 Mar 2020 11:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443140;
        bh=vr34iW1Lped7GFTjkm1+omk3htk2we9zxuSzW2rNpB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eUtfZPG/ZH5yKXIawIQ/jZgo+v1swi0NB/cKFlavK0kYJWIxu8Y93c+KW2vCI1qZ9
         9c8txJYQq4vLV9cX7Sl40FNPC7zhagOQHiXdTgeEAQQQjiNHNHXhe2M6Glr2JOBvj1
         UzNLZrJDhJ3Xi729Sqq5BxmtOpD0YPMVql7PNQSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 109/123] nl80211: add missing attribute validation for beacon report scanning
Date:   Tue, 17 Mar 2020 11:55:36 +0100
Message-Id: <20200317103318.635560084@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

commit 056e9375e1f3c4bf2fd49b70258c7daf788ecd9d upstream.

Add missing attribute validation for beacon report scanning
to the netlink policy.

Fixes: 1d76250bd34a ("nl80211: support beacon report scanning")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20200303051058.4089398-3-kuba@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -469,6 +469,8 @@ const struct nla_policy nl80211_policy[N
 	[NL80211_ATTR_WOWLAN_TRIGGERS] = { .type = NLA_NESTED },
 	[NL80211_ATTR_STA_PLINK_STATE] =
 		NLA_POLICY_MAX(NLA_U8, NUM_NL80211_PLINK_STATES - 1),
+	[NL80211_ATTR_MEASUREMENT_DURATION] = { .type = NLA_U16 },
+	[NL80211_ATTR_MEASUREMENT_DURATION_MANDATORY] = { .type = NLA_FLAG },
 	[NL80211_ATTR_MESH_PEER_AID] =
 		NLA_POLICY_RANGE(NLA_U16, 1, IEEE80211_MAX_AID),
 	[NL80211_ATTR_SCHED_SCAN_INTERVAL] = { .type = NLA_U32 },


