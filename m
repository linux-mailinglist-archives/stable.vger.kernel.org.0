Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3863ED4B5
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236884AbhHPNFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:05:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237019AbhHPNE4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:04:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C72761A7A;
        Mon, 16 Aug 2021 13:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119064;
        bh=otNewyCYQD2t7OSOuiIXaKnh6WbtviRTuMT/waHpYa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRsiCZuZGiXZSsUc+oZ1r9xc4RhYh8b5g/r0/JUDP2VKsMnLRZSvjp7W6jBG+nGBI
         1pbOSIy/XiVZkFPjsrKhEakt3ih+XqAQANFMM70aaQJ+asLCtPFh2OQHsaavUhViyN
         Vl+gSO50/Fy/+n7ASyDfNF1EP9QbIAd/juOKvM0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 37/62] net: igmp: increase size of mr_ifc_count
Date:   Mon, 16 Aug 2021 15:02:09 +0200
Message-Id: <20210816125429.459726776@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125428.198692661@linuxfoundation.org>
References: <20210816125428.198692661@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b69dd5b3780a7298bd893816a09da751bc0636f7 ]

Some arches support cmpxchg() on 4-byte and 8-byte only.
Increase mr_ifc_count width to 32bit to fix this problem.

Fixes: 4a2b285e7e10 ("net: igmp: fix data-race in igmp_ifc_timer_expire()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20210811195715.3684218-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/inetdevice.h | 2 +-
 net/ipv4/igmp.c            | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index 3515ca64e638..b68fca08be27 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -41,7 +41,7 @@ struct in_device {
 	unsigned long		mr_qri;		/* Query Response Interval */
 	unsigned char		mr_qrv;		/* Query Robustness Variable */
 	unsigned char		mr_gq_running;
-	unsigned char		mr_ifc_count;
+	u32			mr_ifc_count;
 	struct timer_list	mr_gq_timer;	/* general query timer */
 	struct timer_list	mr_ifc_timer;	/* interface change timer */
 
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index cfa31c34b5bb..d2b1ae83f258 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -805,7 +805,7 @@ static void igmp_gq_timer_expire(struct timer_list *t)
 static void igmp_ifc_timer_expire(struct timer_list *t)
 {
 	struct in_device *in_dev = from_timer(in_dev, t, mr_ifc_timer);
-	u8 mr_ifc_count;
+	u32 mr_ifc_count;
 
 	igmpv3_send_cr(in_dev);
 restart:
-- 
2.30.2



