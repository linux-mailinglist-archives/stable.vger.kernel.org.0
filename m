Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82D9A145080
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730716AbgAVJqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:46:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:35788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387855AbgAVJnU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:43:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AF6E24680;
        Wed, 22 Jan 2020 09:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686199;
        bh=yUzz3pdxXKQpwQTWqhRKVlEnaLWaycXtq8Of/BB7q7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ont4lVIJqDUJBcHHT/WxhO9rYdxazBL3m+v/TbD8S8gV0k/zTYradtcFfiT1mbLnv
         fUauznOMtdsXnBRuw2iOnVZGDhkbJ2QLi+csWlcUvz9o2AbfIlPnaCmYP7prUa30YD
         SQaOn0iRxiPVq4iiK4/RL2g23JQnjZWVLRnCYOe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e8a797964a4180eb57d5@syzkaller.appspotmail.com,
        syzbot+34b582cf32c1db008f8e@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 084/103] cfg80211: check for set_wiphy_params
Date:   Wed, 22 Jan 2020 10:29:40 +0100
Message-Id: <20200122092815.181496714@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 24953de0a5e31dcca7e82c8a3c79abc2dfe8fb6e upstream.

Check if set_wiphy_params is assigned and return an error if not,
some drivers (e.g. virt_wifi where syzbot reported it) don't have
it.

Reported-by: syzbot+e8a797964a4180eb57d5@syzkaller.appspotmail.com
Reported-by: syzbot+34b582cf32c1db008f8e@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20200113125358.ac07f276efff.Ibd85ee1b12e47b9efb00a2adc5cd3fac50da791a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/rdev-ops.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -537,6 +537,10 @@ static inline int
 rdev_set_wiphy_params(struct cfg80211_registered_device *rdev, u32 changed)
 {
 	int ret;
+
+	if (!rdev->ops->set_wiphy_params)
+		return -EOPNOTSUPP;
+
 	trace_rdev_set_wiphy_params(&rdev->wiphy, changed);
 	ret = rdev->ops->set_wiphy_params(&rdev->wiphy, changed);
 	trace_rdev_return_int(&rdev->wiphy, ret);


