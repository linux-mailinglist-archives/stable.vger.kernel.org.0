Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE61CAD23
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388447AbfJCRfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:35:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731848AbfJCQGN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:06:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7572A21A4C;
        Thu,  3 Oct 2019 16:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118772;
        bh=ySS2nkVRZ3AUrygpTactXdqeqMMVlSOWgYwCDjj95hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1XCj/U1gDZzvOO/Ya3zCOiuxLsmkPX+myWAjNrbR1JCVj58HaHrC3lrgAeQgtD1o
         N6OEApN+HeCIwYjeemGo/ofbW6c/NmvbC0s/ESZFTGnj81c8wAVtE6+OTQpeQQW3CU
         wk6guNptbfwR3ssi/KvWB6e1BZBqMwSKisTK9Pls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Kenzior <denkenz@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.9 119/129] cfg80211: Purge frame registrations on iftype change
Date:   Thu,  3 Oct 2019 17:54:02 +0200
Message-Id: <20191003154414.815124153@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
References: <20191003154318.081116689@linuxfoundation.org>
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
@@ -1051,6 +1051,7 @@ int cfg80211_change_iface(struct cfg8021
 		}
 
 		cfg80211_process_rdev_events(rdev);
+		cfg80211_mlme_purge_registrations(dev->ieee80211_ptr);
 	}
 
 	err = rdev_change_virtual_intf(rdev, dev, ntype, flags, params);


