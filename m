Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD410472544
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235425AbhLMJnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235194AbhLMJka (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:40:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145E8C07E5F6;
        Mon, 13 Dec 2021 01:38:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE9E0B80E20;
        Mon, 13 Dec 2021 09:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D4DC341CF;
        Mon, 13 Dec 2021 09:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388332;
        bh=/aTyyoiiDOu2LCA5Z3xVfDfAZoVt3F37qzD9mg5LW2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQ+qbR8hvKjUIk5xZgOWOlg4zgevYajwTti850snMEE3ZLJ0G4XqftAmtaYxVGlJG
         AEUukCKgWw3zpGGvYg+30ZEtj2GElrVjo8icnjDyYiUWi9oIMR3+SDuU66H+Bjud+9
         RrXPZ6LXQpq+sLotx2Ddn2lPhr6AT2mcTheFvubQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, lee.jones@linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+5f229e48cccc804062c0@syzkaller.appspotmail.com
Subject: [PATCH 4.19 13/74] net: sched: add helper function to take reference to Qdisc
Date:   Mon, 13 Dec 2021 10:29:44 +0100
Message-Id: <20211213092931.228998644@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

[ Upstream commit 9d7e82cec35c027756ec97e274f878251f271181 ]

Implement function to take reference to Qdisc that relies on rcu read lock
instead of rtnl mutex. Function only takes reference to Qdisc if reference
counter isn't zero. Intended to be used by unlocked cls API.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Lee: Sent to Stable]
Link: https://syzkaller.appspot.com/bug?id=d7e411c5472dd5da33d8cc921ccadc747743a568
Reported-by: syzbot+5f229e48cccc804062c0@syzkaller.appspotmail.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sch_generic.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -118,6 +118,19 @@ static inline void qdisc_refcount_inc(st
 	refcount_inc(&qdisc->refcnt);
 }
 
+/* Intended to be used by unlocked users, when concurrent qdisc release is
+ * possible.
+ */
+
+static inline struct Qdisc *qdisc_refcount_inc_nz(struct Qdisc *qdisc)
+{
+	if (qdisc->flags & TCQ_F_BUILTIN)
+		return qdisc;
+	if (refcount_inc_not_zero(&qdisc->refcnt))
+		return qdisc;
+	return NULL;
+}
+
 static inline bool qdisc_is_running(struct Qdisc *qdisc)
 {
 	if (qdisc->flags & TCQ_F_NOLOCK)


