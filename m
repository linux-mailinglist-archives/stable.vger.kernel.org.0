Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B87245CBAC
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfGBIFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:05:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727860AbfGBIFE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:05:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2A6C2184C;
        Tue,  2 Jul 2019 08:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054703;
        bh=otaSQYiXjKh+fTkj0sHdoUcmjs71OqyqyJJbv8MaroQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQo9yHTbgEI1541U0Gz9oFA3mZlMf5Cv9hs92pV/hZ0j1HP8akS1RCnKx+XvRFj0N
         D6mfXh2c2Mp8G2+etjVOeqtfWWBFJ+NA3nWcENtkKrdhmUVmoJ38U8AAuqculza9Vc
         BN+V8JGfhwHYuv5ua/XaeCnOrCrfcj3ROAOWEyPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+30eaa8bf392f7fafffaf@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 41/55] tipc: check msg->req data len in tipc_nl_compat_bearer_disable
Date:   Tue,  2 Jul 2019 10:01:49 +0200
Message-Id: <20190702080126.249219143@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 4f07b80c973348a99b5d2a32476a2e7877e94a05 ]

This patch is to fix an uninit-value issue, reported by syzbot:

  BUG: KMSAN: uninit-value in memchr+0xce/0x110 lib/string.c:981
  Call Trace:
    __dump_stack lib/dump_stack.c:77 [inline]
    dump_stack+0x191/0x1f0 lib/dump_stack.c:113
    kmsan_report+0x130/0x2a0 mm/kmsan/kmsan.c:622
    __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:310
    memchr+0xce/0x110 lib/string.c:981
    string_is_valid net/tipc/netlink_compat.c:176 [inline]
    tipc_nl_compat_bearer_disable+0x2a1/0x480 net/tipc/netlink_compat.c:449
    __tipc_nl_compat_doit net/tipc/netlink_compat.c:327 [inline]
    tipc_nl_compat_doit+0x3ac/0xb00 net/tipc/netlink_compat.c:360
    tipc_nl_compat_handle net/tipc/netlink_compat.c:1178 [inline]
    tipc_nl_compat_recv+0x1b1b/0x27b0 net/tipc/netlink_compat.c:1281

TLV_GET_DATA_LEN() may return a negtive int value, which will be
used as size_t (becoming a big unsigned long) passed into memchr,
cause this issue.

Similar to what it does in tipc_nl_compat_bearer_enable(), this
fix is to return -EINVAL when TLV_GET_DATA_LEN() is negtive in
tipc_nl_compat_bearer_disable(), as well as in
tipc_nl_compat_link_stat_dump() and tipc_nl_compat_link_reset_stats().

v1->v2:
  - add the missing Fixes tags per Eric's request.

Fixes: 0762216c0ad2 ("tipc: fix uninit-value in tipc_nl_compat_bearer_enable")
Fixes: 8b66fee7f8ee ("tipc: fix uninit-value in tipc_nl_compat_link_reset_stats")
Reported-by: syzbot+30eaa8bf392f7fafffaf@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/netlink_compat.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -445,7 +445,11 @@ static int tipc_nl_compat_bearer_disable
 	if (!bearer)
 		return -EMSGSIZE;
 
-	len = min_t(int, TLV_GET_DATA_LEN(msg->req), TIPC_MAX_BEARER_NAME);
+	len = TLV_GET_DATA_LEN(msg->req);
+	if (len <= 0)
+		return -EINVAL;
+
+	len = min_t(int, len, TIPC_MAX_BEARER_NAME);
 	if (!string_is_valid(name, len))
 		return -EINVAL;
 
@@ -537,7 +541,11 @@ static int tipc_nl_compat_link_stat_dump
 
 	name = (char *)TLV_DATA(msg->req);
 
-	len = min_t(int, TLV_GET_DATA_LEN(msg->req), TIPC_MAX_LINK_NAME);
+	len = TLV_GET_DATA_LEN(msg->req);
+	if (len <= 0)
+		return -EINVAL;
+
+	len = min_t(int, len, TIPC_MAX_BEARER_NAME);
 	if (!string_is_valid(name, len))
 		return -EINVAL;
 
@@ -815,7 +823,11 @@ static int tipc_nl_compat_link_reset_sta
 	if (!link)
 		return -EMSGSIZE;
 
-	len = min_t(int, TLV_GET_DATA_LEN(msg->req), TIPC_MAX_LINK_NAME);
+	len = TLV_GET_DATA_LEN(msg->req);
+	if (len <= 0)
+		return -EINVAL;
+
+	len = min_t(int, len, TIPC_MAX_BEARER_NAME);
 	if (!string_is_valid(name, len))
 		return -EINVAL;
 


