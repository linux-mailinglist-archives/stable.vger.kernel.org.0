Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82941D815F
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbgERRrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:47:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730230AbgERRrb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:47:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57CCD20674;
        Mon, 18 May 2020 17:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824050;
        bh=uXIgwYldt3Qt6/DL3+ObImCY0Z8vbGt4xt21X1y3Uz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0f0mGh9Phtluv05T5fpOvlud7UAYKqNddzT/iQlwkhPIFtFUkEU4FUtR+3egalN2J
         fZhlfOBritF5sDT+2k9DB931qbSsYSsUXL3U8D+UmQMCOyA1cPzUrCad3iOwX90E8W
         rPYImwNc5a2H59OvwbfvJ6Mc6iM9q+i+hsWyPJ1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 052/114] drop_monitor: work around gcc-10 stringop-overflow warning
Date:   Mon, 18 May 2020 19:36:24 +0200
Message-Id: <20200518173512.666804892@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit dc30b4059f6e2abf3712ab537c8718562b21c45d ]

The current gcc-10 snapshot produces a false-positive warning:

net/core/drop_monitor.c: In function 'trace_drop_common.constprop':
cc1: error: writing 8 bytes into a region of size 0 [-Werror=stringop-overflow=]
In file included from net/core/drop_monitor.c:23:
include/uapi/linux/net_dropmon.h:36:8: note: at offset 0 to object 'entries' with size 4 declared here
   36 |  __u32 entries;
      |        ^~~~~~~

I reported this in the gcc bugzilla, but in case it does not get
fixed in the release, work around it by using a temporary variable.

Fixes: 9a8afc8d3962 ("Network Drop Monitor: Adding drop monitor implementation & Netlink protocol")
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=94881
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/drop_monitor.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 70ccda233bd1f..ef9fe5f95093b 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -154,6 +154,7 @@ static void sched_send_work(unsigned long _data)
 static void trace_drop_common(struct sk_buff *skb, void *location)
 {
 	struct net_dm_alert_msg *msg;
+	struct net_dm_drop_point *point;
 	struct nlmsghdr *nlh;
 	struct nlattr *nla;
 	int i;
@@ -172,11 +173,13 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
 	nlh = (struct nlmsghdr *)dskb->data;
 	nla = genlmsg_data(nlmsg_data(nlh));
 	msg = nla_data(nla);
+	point = msg->points;
 	for (i = 0; i < msg->entries; i++) {
-		if (!memcmp(&location, msg->points[i].pc, sizeof(void *))) {
-			msg->points[i].count++;
+		if (!memcmp(&location, &point->pc, sizeof(void *))) {
+			point->count++;
 			goto out;
 		}
+		point++;
 	}
 	if (msg->entries == dm_hit_limit)
 		goto out;
@@ -185,8 +188,8 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
 	 */
 	__nla_reserve_nohdr(dskb, sizeof(struct net_dm_drop_point));
 	nla->nla_len += NLA_ALIGN(sizeof(struct net_dm_drop_point));
-	memcpy(msg->points[msg->entries].pc, &location, sizeof(void *));
-	msg->points[msg->entries].count = 1;
+	memcpy(point->pc, &location, sizeof(void *));
+	point->count = 1;
 	msg->entries++;
 
 	if (!timer_pending(&data->send_timer)) {
-- 
2.20.1



