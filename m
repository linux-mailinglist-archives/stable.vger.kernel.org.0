Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2303419B04B
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387617AbgDAQZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732376AbgDAQZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:25:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F7F021582;
        Wed,  1 Apr 2020 16:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758337;
        bh=py3PbJO+718EbgHi2IRhSbWGNdFxCBeIfNnFi27bS/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VxO+6SKPS/cyE6bg5of1EQs4K2MYIJJ8JTUaE0MfEMW7wzxFosqj8M8DCFmn1I24u
         fZ1AFIU7cSX//tO+7vSkFHUmayE1m8v8nkuGtk/5+rZF6v4tSQP3as2+0fX03QkKzO
         x7Zca2GEwoimR6YhjdBnmcw3xfOxINJV2mVDOfqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 059/116] mac80211: mark station unauthorized before key removal
Date:   Wed,  1 Apr 2020 18:17:15 +0200
Message-Id: <20200401161550.178503185@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161542.669484650@linuxfoundation.org>
References: <20200401161542.669484650@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit b16798f5b907733966fd1a558fca823b3c67e4a1 upstream.

If a station is still marked as authorized, mark it as no longer
so before removing its keys. This allows frames transmitted to it
to be rejected, providing additional protection against leaking
plain text data during the disconnection flow.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200326155133.ccb4fb0bb356.If48f0f0504efdcf16b8921f48c6d3bb2cb763c99@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/sta_info.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -3,7 +3,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright (C) 2015 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018-2020 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -979,6 +979,11 @@ static void __sta_info_destroy_part2(str
 	might_sleep();
 	lockdep_assert_held(&local->sta_mtx);
 
+	while (sta->sta_state == IEEE80211_STA_AUTHORIZED) {
+		ret = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
+		WARN_ON_ONCE(ret);
+	}
+
 	/* now keys can no longer be reached */
 	ieee80211_free_sta_keys(local, sta);
 


