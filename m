Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBCCCA356
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388668AbfJCQOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:14:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727451AbfJCQOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:14:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E03C0215EA;
        Thu,  3 Oct 2019 16:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119279;
        bh=4E/RbBcjTjItH7hUyD/o4g7uGpVk3R/qr6uWCh8bDxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8TT2oH5xaj743x6kaF1HCSiyqFT0f5X0WGYPOf8pGdeoLtOyrdGd9Z+HhELyWYtB
         0bhBGH1PI2g55j6LjXCm2ITodVMUGL7mG7af2jq6+hOwPlU19zYud2Y3U8/zqx6Zdd
         SpUtRgm+mLSyAl5Z2N4cGiO5dPwM+IjOrEBnMG4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Kenzior <denkenz@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.14 173/185] cfg80211: Purge frame registrations on iftype change
Date:   Thu,  3 Oct 2019 17:54:11 +0200
Message-Id: <20191003154519.830899272@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Kenzior <denkenz@gmail.com>

commit c1d3ad84eae35414b6b334790048406bd6301b12 upstream.

Currently frame registrations are not purged, even when changing the
interface type.  This can lead to potentially weird situations where
frames possibly not allowed on a given interface type remain registered
due to the type switching happening after registration.

The kernel currently relies on userspace apps to actually purge the
registrations themselves, this is not something that the kernel should
rely on.

Add a call to cfg80211_mlme_purge_registrations() to forcefully remove
any registrations left over prior to switching the iftype.

Cc: stable@vger.kernel.org
Signed-off-by: Denis Kenzior <denkenz@gmail.com>
Link: https://lore.kernel.org/r/20190828211110.15005-1-denkenz@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/util.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1042,6 +1042,7 @@ int cfg80211_change_iface(struct cfg8021
 		}
 
 		cfg80211_process_rdev_events(rdev);
+		cfg80211_mlme_purge_registrations(dev->ieee80211_ptr);
 	}
 
 	err = rdev_change_virtual_intf(rdev, dev, ntype, params);


