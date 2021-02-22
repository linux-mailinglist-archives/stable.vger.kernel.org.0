Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A710232162E
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhBVMTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:19:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230452AbhBVMQi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:16:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74D0E64F1A;
        Mon, 22 Feb 2021 12:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996178;
        bh=rgTnQQVh5bW9qEpr42JAJVXxgIxB7JQOlLu+3WkJcso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a0JDY0tj6ymH5iXAOWIb7LPZB3pwo+8RDZSBXhaufvKq34c5LbKd31Z2fguNoZoL8
         +tqnLkKyXDCVqXDNCWkoIi88K9MIHg0L6c7Nqe86hFhhbo20p4XtpR1IMEP92x7BUm
         zskKH/Cx19izm6pyDIPZfEPywsPH1xlSXoP0/iXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Reindl Harald <h.reindl@thelounge.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/50] netfilter: xt_recent: Fix attempt to update deleted entry
Date:   Mon, 22 Feb 2021 13:13:09 +0100
Message-Id: <20210222121022.711397630@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
References: <20210222121019.925481519@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@mail.kfki.hu>

[ Upstream commit b1bdde33b72366da20d10770ab7a49fe87b5e190 ]

When both --reap and --update flag are specified, there's a code
path at which the entry to be updated is reaped beforehand,
which then leads to kernel crash. Reap only entries which won't be
updated.

Fixes kernel bugzilla #207773.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=207773
Reported-by: Reindl Harald <h.reindl@thelounge.net>
Fixes: 0079c5aee348 ("netfilter: xt_recent: add an entry reaper")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_recent.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 570144507df11..cb58bc7ae30d3 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -155,7 +155,8 @@ static void recent_entry_remove(struct recent_table *t, struct recent_entry *e)
 /*
  * Drop entries with timestamps older then 'time'.
  */
-static void recent_entry_reap(struct recent_table *t, unsigned long time)
+static void recent_entry_reap(struct recent_table *t, unsigned long time,
+			      struct recent_entry *working, bool update)
 {
 	struct recent_entry *e;
 
@@ -164,6 +165,12 @@ static void recent_entry_reap(struct recent_table *t, unsigned long time)
 	 */
 	e = list_entry(t->lru_list.next, struct recent_entry, lru_list);
 
+	/*
+	 * Do not reap the entry which are going to be updated.
+	 */
+	if (e == working && update)
+		return;
+
 	/*
 	 * The last time stamp is the most recent.
 	 */
@@ -306,7 +313,8 @@ recent_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 		/* info->seconds must be non-zero */
 		if (info->check_set & XT_RECENT_REAP)
-			recent_entry_reap(t, time);
+			recent_entry_reap(t, time, e,
+				info->check_set & XT_RECENT_UPDATE && ret);
 	}
 
 	if (info->check_set & XT_RECENT_SET ||
-- 
2.27.0



