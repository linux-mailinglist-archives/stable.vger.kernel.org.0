Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6A03AEE52
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbhFUQ2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231241AbhFUQ0X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:26:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32D74613C2;
        Mon, 21 Jun 2021 16:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292537;
        bh=0mKJ3fkAyYjKKBmwW1OD3wt7IeExMJxJozSgLde2vJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvw/bRgVLAOsZPRXNr/7psdlke4weznDTAeIVn2GvZccXHqL60DeVVjl0QRW93EZP
         5iEHrkJc7zVj0EFWeoMWWx3BAXDAnF7qLkHx33D90CxVckVvwihYhvY2iroSixHYSn
         CXxaqxRGCJFqtaxnRHOzmsk0o18f4ezHV1l44eMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Young Xiao <92siuyang@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/146] sch_cake: Fix out of bounds when parsing TCP options and header
Date:   Mon, 21 Jun 2021 18:14:26 +0200
Message-Id: <20210621154912.519889784@linuxfoundation.org>
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

[ Upstream commit ba91c49dedbde758ba0b72f57ac90b06ddf8e548 ]

The TCP option parser in cake qdisc (cake_get_tcpopt and
cake_tcph_may_drop) could read one byte out of bounds. When the length
is 1, the execution flow gets into the loop, reads one byte of the
opcode, and if the opcode is neither TCPOPT_EOL nor TCPOPT_NOP, it reads
one more byte, which exceeds the length of 1.

This fix is inspired by commit 9609dad263f8 ("ipv4: tcp_input: fix stack
out of bounds when parsing TCP options.").

v2 changes:

Added doff validation in cake_get_tcphdr to avoid parsing garbage as TCP
header. Although it wasn't strictly an out-of-bounds access (memory was
allocated), garbage values could be read where CAKE expected the TCP
header if doff was smaller than 5.

Cc: Young Xiao <92siuyang@gmail.com>
Fixes: 8b7138814f29 ("sch_cake: Add optional ACK filter")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cake.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 7d37638ee1c7..5c15968b5155 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -943,7 +943,7 @@ static struct tcphdr *cake_get_tcphdr(const struct sk_buff *skb,
 	}
 
 	tcph = skb_header_pointer(skb, offset, sizeof(_tcph), &_tcph);
-	if (!tcph)
+	if (!tcph || tcph->doff < 5)
 		return NULL;
 
 	return skb_header_pointer(skb, offset,
@@ -967,6 +967,8 @@ static const void *cake_get_tcpopt(const struct tcphdr *tcph,
 			length--;
 			continue;
 		}
+		if (length < 2)
+			break;
 		opsize = *ptr++;
 		if (opsize < 2 || opsize > length)
 			break;
@@ -1104,6 +1106,8 @@ static bool cake_tcph_may_drop(const struct tcphdr *tcph,
 			length--;
 			continue;
 		}
+		if (length < 2)
+			break;
 		opsize = *ptr++;
 		if (opsize < 2 || opsize > length)
 			break;
-- 
2.30.2



