Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D6E47AE03
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235429AbhLTO5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:57:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33376 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239411AbhLTOzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:55:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5117B80EE3;
        Mon, 20 Dec 2021 14:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEA3C36AE8;
        Mon, 20 Dec 2021 14:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012128;
        bh=bc2McG7xOdeZED+/riqAmyY0sWbZhfv2LnK0AsZGMD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RTI23ZoUbA5QwQom8WboRa0GgE5qnrenzDEPMPBF4no/4g8DhCRyvAgGrTkEak2bT
         2K+GGc4CI2U63RWSJRiM20qwoUrw9Rp/3pOHhkNTnS1pUtz/lGQJSmwdwskT4AdTgD
         R8uTCW4zJsGoPAMDS8/Nobnnh2gvLX/oYuWGd2tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+1fd9b69cde42967d1add@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/177] mptcp: remove tcp ulp setsockopt support
Date:   Mon, 20 Dec 2021 15:34:00 +0100
Message-Id: <20211220143043.145213292@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 404cd9a22150f24acf23a8df2ad0c094ba379f57 ]

TCP_ULP setsockopt cannot be used for mptcp because its already
used internally to plumb subflow (tcp) sockets to the mptcp layer.

syzbot managed to trigger a crash for mptcp connections that are
in fallback mode:

KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 1 PID: 1083 Comm: syz-executor.3 Not tainted 5.16.0-rc2-syzkaller #0
RIP: 0010:tls_build_proto net/tls/tls_main.c:776 [inline]
[..]
 __tcp_set_ulp net/ipv4/tcp_ulp.c:139 [inline]
 tcp_set_ulp+0x428/0x4c0 net/ipv4/tcp_ulp.c:160
 do_tcp_setsockopt+0x455/0x37c0 net/ipv4/tcp.c:3391
 mptcp_setsockopt+0x1b47/0x2400 net/mptcp/sockopt.c:638

Remove support for TCP_ULP setsockopt.

Fixes: d9e4c1291810 ("mptcp: only admit explicitly supported sockopt")
Reported-by: syzbot+1fd9b69cde42967d1add@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/sockopt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 8c03afac5ca03..4bb305342fcc7 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -523,7 +523,6 @@ static bool mptcp_supported_sockopt(int level, int optname)
 		case TCP_NODELAY:
 		case TCP_THIN_LINEAR_TIMEOUTS:
 		case TCP_CONGESTION:
-		case TCP_ULP:
 		case TCP_CORK:
 		case TCP_KEEPIDLE:
 		case TCP_KEEPINTVL:
-- 
2.33.0



