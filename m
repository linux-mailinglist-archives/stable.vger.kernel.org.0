Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258D7360D35
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbhDOO64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234461AbhDOO4y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:56:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24DB7613F4;
        Thu, 15 Apr 2021 14:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498457;
        bh=Q+5fEvDj5iAxPrP/ZoaMUXAHNrRsab/qAj7JAHiSKZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xLE8joFYk5CJj4Eul/PhLexlb6AYyQFxqsrFLi7BhgTYYkKqKwZ+xAPuATwf2A4R3
         RfbuW6MGsfyB5+A4Te6eP+ygccTp1zraj1hvDuGX3n9mzs/Xv9XktsF0GN194HSA50
         mcezVI0neyD0zB16O2bDBXvyOsUOcWAra7bBjpe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+5f9392825de654244975@syzkaller.appspotmail.com,
        Du Cheng <ducheng2@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.14 46/68] cfg80211: remove WARN_ON() in cfg80211_sme_connect
Date:   Thu, 15 Apr 2021 16:47:27 +0200
Message-Id: <20210415144415.977652494@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144414.464797272@linuxfoundation.org>
References: <20210415144414.464797272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Du Cheng <ducheng2@gmail.com>

commit 1b5ab825d9acc0f27d2f25c6252f3526832a9626 upstream.

A WARN_ON(wdev->conn) would trigger in cfg80211_sme_connect(), if multiple
send_msg(NL80211_CMD_CONNECT) system calls are made from the userland, which
should be anticipated and handled by the wireless driver. Remove this WARN_ON()
to prevent kernel panic if kernel is configured to "panic_on_warn".

Bug reported by syzbot.

Reported-by: syzbot+5f9392825de654244975@syzkaller.appspotmail.com
Signed-off-by: Du Cheng <ducheng2@gmail.com>
Link: https://lore.kernel.org/r/20210407162756.6101-1-ducheng2@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/sme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -530,7 +530,7 @@ static int cfg80211_sme_connect(struct w
 		cfg80211_sme_free(wdev);
 	}
 
-	if (WARN_ON(wdev->conn))
+	if (wdev->conn)
 		return -EINPROGRESS;
 
 	wdev->conn = kzalloc(sizeof(*wdev->conn), GFP_KERNEL);


