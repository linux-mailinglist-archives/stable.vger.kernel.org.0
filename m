Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9483C5393
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348127AbhGLHzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350501AbhGLHvE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93C5E61A19;
        Mon, 12 Jul 2021 07:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075948;
        bh=7vn4Se3SpSdD9mpNsNqL5Rkr4YOpW0bi9PEe7FU4AZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fk1o+ZgcgPH4qSIGgo7er1AVl2YGCy6iq9FyYy24pee3DjHxnW4Fk+b7n97Iigvai
         vB3/Ki9931c0vaP/YS/tG8lOVh4L18SjpTqIv1dnLjasvBc/Tdbwno+98SOJ5HZEoQ
         iwXHg/+wpiI4ZI+IQovFKmvPLw9Rnq1brStjZ4Rg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geliang Tang <geliangtang@gmail.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jianguo Wu <wujianguo@chinatelecom.cn>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 426/800] mptcp: make sure flag signal is set when add addr with port
Date:   Mon, 12 Jul 2021 08:07:29 +0200
Message-Id: <20210712061012.448212057@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

[ Upstream commit eb5fb629f56da3f40f496c807da44a7ce7644779 ]

When add address with port, it is mean to create a listening socket,
and send an ADD_ADDR to remote, so it must have flag signal set,
add this check in mptcp_pm_parse_addr().

Fixes: a77e9179c7651 ("mptcp: deal with MPTCP_PM_ADDR_ATTR_PORT in PM netlink")
Acked-by: Geliang Tang <geliangtang@gmail.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 2469e06a3a9d..3f5d90a20235 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -971,8 +971,14 @@ skip_family:
 	if (tb[MPTCP_PM_ADDR_ATTR_FLAGS])
 		entry->flags = nla_get_u32(tb[MPTCP_PM_ADDR_ATTR_FLAGS]);
 
-	if (tb[MPTCP_PM_ADDR_ATTR_PORT])
+	if (tb[MPTCP_PM_ADDR_ATTR_PORT]) {
+		if (!(entry->flags & MPTCP_PM_ADDR_FLAG_SIGNAL)) {
+			NL_SET_ERR_MSG_ATTR(info->extack, attr,
+					    "flags must have signal when using port");
+			return -EINVAL;
+		}
 		entry->addr.port = htons(nla_get_u16(tb[MPTCP_PM_ADDR_ATTR_PORT]));
+	}
 
 	return 0;
 }
-- 
2.30.2



