Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B913AF010
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbhFUQqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:46:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232850AbhFUQnd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:43:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 709CF6144F;
        Mon, 21 Jun 2021 16:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293103;
        bh=RzXCk9Dio8zmt6KXri5/MKKeCrYmJTpNj3bvQToYVFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mAHSqylNcWyEzJVpw+7oBNesJDcvxrKwFKr4LMEUpu51+BJd/kudQlyVJyvBCr55L
         croLYnu7of1ORiPv5fYbBTpHBwvU68BVmHnb5wAj/NE7MXud3x6QN7RIiJ120xZ4io
         +vXmFAu3Qy4u/QKHL4/eLtXDzwBimxL/+YuWXeFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+59aa77b92d06cd5a54f2@syzkaller.appspotmail.com,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 056/178] ethtool: strset: fix message length calculation
Date:   Mon, 21 Jun 2021 18:14:30 +0200
Message-Id: <20210621154924.339857319@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit e175aef902697826d344ce3a12189329848fe898 ]

Outer nest for ETHTOOL_A_STRSET_STRINGSETS is not accounted for.
This may result in ETHTOOL_MSG_STRSET_GET producing a warning like:

    calculated message payload length (684) not sufficient
    WARNING: CPU: 0 PID: 30967 at net/ethtool/netlink.c:369 ethnl_default_doit+0x87a/0xa20

and a splat.

As usually with such warnings three conditions must be met for the warning
to trigger:
 - there must be no skb size rounding up (e.g. reply_size of 684);
 - string set must be per-device (so that the header gets populated);
 - the device name must be at least 12 characters long.

all in all with current user space it looks like reading priv flags
is the only place this could potentially happen. Or with syzbot :)

Reported-by: syzbot+59aa77b92d06cd5a54f2@syzkaller.appspotmail.com
Fixes: 71921690f974 ("ethtool: provide string sets with STRSET_GET request")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/strset.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index c3a5489964cd..9908b922cce8 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -328,6 +328,8 @@ static int strset_reply_size(const struct ethnl_req_info *req_base,
 	int len = 0;
 	int ret;
 
+	len += nla_total_size(0); /* ETHTOOL_A_STRSET_STRINGSETS */
+
 	for (i = 0; i < ETH_SS_COUNT; i++) {
 		const struct strset_info *set_info = &data->sets[i];
 
-- 
2.30.2



