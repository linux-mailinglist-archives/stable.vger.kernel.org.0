Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAEA45C3CB
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350788AbhKXNms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:42:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348285AbhKXNkr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:40:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4022063230;
        Wed, 24 Nov 2021 12:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758645;
        bh=o9ZgmHuMDnscFdkQdrLy1fHCKJ4iQp9UG8lRVVffQog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rqQqZI3kM+VIYUNm73VOZ0NsGKDYXaMjp5XYcA2zylFVm2q5ScJ+F4Ylsq41PqUTT
         /H7p4PAoEq6hQD79e8wGJXzE3kB2P0auRt0M33ywDy5hyFzq4Zig8vYUcb/xHAoig2
         G8gCHugMFr567PloWyRkx4HEPevU/gaLjV893zc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nguyen Dinh Phi <phind.uet@gmail.com>,
        syzbot+bbf402b783eeb6d908db@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 136/154] cfg80211: call cfg80211_stop_ap when switch from P2P_GO type
Date:   Wed, 24 Nov 2021 12:58:52 +0100
Message-Id: <20211124115706.702103024@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nguyen Dinh Phi <phind.uet@gmail.com>

commit 563fbefed46ae4c1f70cffb8eb54c02df480b2c2 upstream.

If the userspace tools switch from NL80211_IFTYPE_P2P_GO to
NL80211_IFTYPE_ADHOC via send_msg(NL80211_CMD_SET_INTERFACE), it
does not call the cleanup cfg80211_stop_ap(), this leads to the
initialization of in-use data. For example, this path re-init the
sdata->assigned_chanctx_list while it is still an element of
assigned_vifs list, and makes that linked list corrupt.

Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Reported-by: syzbot+bbf402b783eeb6d908db@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20211027173722.777287-1-phind.uet@gmail.com
Cc: stable@vger.kernel.org
Fixes: ac800140c20e ("cfg80211: .stop_ap when interface is going down")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/util.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1044,6 +1044,7 @@ int cfg80211_change_iface(struct cfg8021
 
 		switch (otype) {
 		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_P2P_GO:
 			cfg80211_stop_ap(rdev, dev, true);
 			break;
 		case NL80211_IFTYPE_ADHOC:


