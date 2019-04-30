Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F68CF78B
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbfD3LqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:46:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730073AbfD3Lp7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:45:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0312E21670;
        Tue, 30 Apr 2019 11:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624758;
        bh=sSz3YWg6ZqSDJ7IxTSRpTLrK3Rw0qZCXM/y7vDBgX5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x0rvRv2nZXmrFKwtn4lGlPrnTcRFYd01ZC5jMjP4fnFx1LHCftTjKQcIeFG/LahKK
         Jfyu/MbM9zW2Gx0NCo4yTySiRkLUVf9Ih18moxwtUcWfMp46Whydvljad5OF41VSeI
         LqLRXDuTGQ9NbdIYCqT3TyaSQeEmacsk48nKhHCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+de00a87b8644a582ae79@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 062/100] tipc: check link name with right length in tipc_nl_compat_link_set
Date:   Tue, 30 Apr 2019 13:38:31 +0200
Message-Id: <20190430113611.775567884@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 8c63bf9ab4be8b83bd8c34aacfd2f1d2c8901c8a upstream.

A similar issue as fixed by Patch "tipc: check bearer name with right
length in tipc_nl_compat_bearer_enable" was also found by syzbot in
tipc_nl_compat_link_set().

The length to check with should be 'TLV_GET_DATA_LEN(msg->req) -
offsetof(struct tipc_link_config, name)'.

Reported-by: syzbot+de00a87b8644a582ae79@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/tipc/netlink_compat.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -777,7 +777,12 @@ static int tipc_nl_compat_link_set(struc
 
 	lc = (struct tipc_link_config *)TLV_DATA(msg->req);
 
-	len = min_t(int, TLV_GET_DATA_LEN(msg->req), TIPC_MAX_LINK_NAME);
+	len = TLV_GET_DATA_LEN(msg->req);
+	len -= offsetof(struct tipc_link_config, name);
+	if (len <= 0)
+		return -EINVAL;
+
+	len = min_t(int, len, TIPC_MAX_LINK_NAME);
 	if (!string_is_valid(lc->name, len))
 		return -EINVAL;
 


