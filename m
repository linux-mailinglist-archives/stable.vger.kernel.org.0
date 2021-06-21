Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A303AEE4F
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbhFUQ14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:27:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231883AbhFUQ0L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:26:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 673FE613C3;
        Mon, 21 Jun 2021 16:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292535;
        bh=2CHqXilASFtfJwlymiMPfsg6PKId6hne04k+JUfhCNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCyQH0hrJMNeWuBtkS7ssACIo1Vkj8QNADdQM1++weyxMwi8pqiVA9H0eCPAfC0+l
         o6C6abAr5glPzqCOGh/ig4NmdL+b7A0zZiOGlQjHONbLesik0b+CYpNEoLBFx7mqL+
         g4BCE4mBNFCZb4jNQLOXA8E/LG92GOS+M8IDUMLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Young Xiao <92siuyang@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/146] mptcp: Fix out of bounds when parsing TCP options
Date:   Mon, 21 Jun 2021 18:14:25 +0200
Message-Id: <20210621154912.487685400@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit 07718be265680dcf496347d475ce1a5442f55ad7 ]

The TCP option parser in mptcp (mptcp_get_options) could read one byte
out of bounds. When the length is 1, the execution flow gets into the
loop, reads one byte of the opcode, and if the opcode is neither
TCPOPT_EOL nor TCPOPT_NOP, it reads one more byte, which exceeds the
length of 1.

This fix is inspired by commit 9609dad263f8 ("ipv4: tcp_input: fix stack
out of bounds when parsing TCP options.").

Cc: Young Xiao <92siuyang@gmail.com>
Fixes: cec37a6e41aa ("mptcp: Handle MP_CAPABLE options for outgoing connections")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 91034a221983..ac0233c9cd34 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -314,6 +314,8 @@ void mptcp_get_options(const struct sk_buff *skb,
 			length--;
 			continue;
 		default:
+			if (length < 2)
+				return;
 			opsize = *ptr++;
 			if (opsize < 2) /* "silly options" */
 				return;
-- 
2.30.2



