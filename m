Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2A735BD82
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238351AbhDLIwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:52:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238494AbhDLIt6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:49:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF1CE6124A;
        Mon, 12 Apr 2021 08:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217360;
        bh=Q+5fEvDj5iAxPrP/ZoaMUXAHNrRsab/qAj7JAHiSKZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dbtGGDKp5WtxHM5U74+grLrO/Sv9VRPxSNXrY3hNT7OfymIRpX6vnuIn+iG8GxJYs
         TgppxtIB3VGOsZvboslJr5mA30/G2bD17xJ/y8Ak27BbpLkE1Slt4CgHZBSE7QWq+6
         7fb1FaUUgWfFqzQlntQfr6uC1zKtPc81ZF3xMrd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+5f9392825de654244975@syzkaller.appspotmail.com,
        Du Cheng <ducheng2@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 098/111] cfg80211: remove WARN_ON() in cfg80211_sme_connect
Date:   Mon, 12 Apr 2021 10:41:16 +0200
Message-Id: <20210412084007.513443061@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
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


