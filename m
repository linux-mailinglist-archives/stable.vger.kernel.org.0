Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092B4360C48
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbhDOOtu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:49:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233562AbhDOOtm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:49:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D29961029;
        Thu, 15 Apr 2021 14:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498159;
        bh=Ub6m28BE0ICh1XxVxZ+Mu45AI4DQtsYrFPeIFqel9RM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=brbiyeQszsMXoazK5qr8Jzv/qB1S+hJXXH9q9n3ZRdMFt13QyX5QphaH8S1us9hII
         yNYWEMJikqLq1Oakv1WhZnM70yAPWk5y2sdmb6MZ6UlOHCH7HLx+wHO1uOQ16+sT3m
         f9yNZjfN2OXhcDQ4iXlFb0p+nrwVc8XApGzXt7dI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+5f9392825de654244975@syzkaller.appspotmail.com,
        Du Cheng <ducheng2@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.4 22/38] cfg80211: remove WARN_ON() in cfg80211_sme_connect
Date:   Thu, 15 Apr 2021 16:47:16 +0200
Message-Id: <20210415144414.058015430@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.352638802@linuxfoundation.org>
References: <20210415144413.352638802@linuxfoundation.org>
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
@@ -507,7 +507,7 @@ static int cfg80211_sme_connect(struct w
 	if (wdev->current_bss)
 		return -EALREADY;
 
-	if (WARN_ON(wdev->conn))
+	if (wdev->conn)
 		return -EINPROGRESS;
 
 	wdev->conn = kzalloc(sizeof(*wdev->conn), GFP_KERNEL);


