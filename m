Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD5232170D
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhBVMmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:42:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:52818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230427AbhBVMju (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:39:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D641364E84;
        Mon, 22 Feb 2021 12:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997514;
        bh=oTazyRYUKW3Q7nzXVqpvF/ftXZMzzxdYLM9V96omFjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSq6WtiVDlN9rOz3PAvrBGaej6j4BNOJvmKGpg2mjyFCrtS0jSlpVK23wyCBZdQ6M
         ZTiWYxWX+l6489vo+8ajIIR7ruVdHjoiK63m2za7ogk5Qury4XGeSdt4KqgYUpMiDN
         9W1Iik1j0nEc5dd1ikl7CAHCRCc8K0/MXRp09pXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Reindl Harald <h.reindl@thelounge.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 30/57] netfilter: xt_recent: Fix attempt to update deleted entry
Date:   Mon, 22 Feb 2021 13:35:56 +0100
Message-Id: <20210222121029.716816473@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121027.174911182@linuxfoundation.org>
References: <20210222121027.174911182@linuxfoundation.org>
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
index cf96d230e5a3c..cafbddf844d62 100644
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



