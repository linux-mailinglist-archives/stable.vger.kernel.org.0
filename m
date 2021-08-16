Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88D23ED555
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239088AbhHPNKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:10:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237429AbhHPNJM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:09:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54464610E8;
        Mon, 16 Aug 2021 13:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119286;
        bh=ZvYpSPnb/sjZPhLX8TXBfRVqa37SIfIGq7PHbMXwfHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oGiCwvQCsMaoJ9dUhvQ0Et/0yT46s13OE4jFpS4E5xbUXBx9v7c31Mdvg8WYmm1xT
         8pj+Y5owzVPSNk5OehaodvZYa3OY3opn055924bFojPbt7XD+0kUcExvOWEyRgWtX6
         k0GGh6t08YlkHlBao36Jis826WIV+6kpXpZsnOes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 63/96] net: igmp: increase size of mr_ifc_count
Date:   Mon, 16 Aug 2021 15:02:13 +0200
Message-Id: <20210816125437.048044635@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
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
index a51360087b19..00576bae183d 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -803,7 +803,7 @@ static void igmp_gq_timer_expire(struct timer_list *t)
 static void igmp_ifc_timer_expire(struct timer_list *t)
 {
 	struct in_device *in_dev = from_timer(in_dev, t, mr_ifc_timer);
-	u8 mr_ifc_count;
+	u32 mr_ifc_count;
 
 	igmpv3_send_cr(in_dev);
 restart:
-- 
2.30.2



