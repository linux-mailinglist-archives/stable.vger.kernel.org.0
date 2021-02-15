Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD2331BD1C
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhBOPkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:40:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231494AbhBOPhx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:37:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 906D264EAC;
        Mon, 15 Feb 2021 15:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403205;
        bh=DsiKUk3GygY9jko2vQZXxEPF1RWrFbhLv7k8z45r9ZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PHtZui+m/8AKz/f8kFzT1uAVhjpVsVNsO79/Nnq1udAsO2zPvzT/qLMDdyvjXDg+t
         ECbSqcXzVRrio7K/cuoNUAS9ye05gmrVSN0XqJ9mW1N0tmpcsBt+LpunDxVMegswP6
         vnRwNcYXoIX2bM5nC6r/1IKGsPCpULPbcoM6GbfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/104] selftests: txtimestamp: fix compilation issue
Date:   Mon, 15 Feb 2021 16:27:19 +0100
Message-Id: <20210215152721.599910786@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Fedorenko <vfedorenko@novek.ru>

[ Upstream commit 647b8dd5184665432cc8a2b5bca46a201f690c37 ]

PACKET_TX_TIMESTAMP is defined in if_packet.h but it is not included in
test. Include it instead of <netpacket/packet.h> otherwise the error of
redefinition arrives.
Also fix the compiler warning about ambiguous control flow by adding
explicit braces.

Fixes: 8fe2f761cae9 ("net-timestamp: expand documentation")
Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
Acked-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/1612461034-24524-1-git-send-email-vfedorenko@novek.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/txtimestamp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/txtimestamp.c b/tools/testing/selftests/net/txtimestamp.c
index 490a8cca708a8..fabb1d555ee5c 100644
--- a/tools/testing/selftests/net/txtimestamp.c
+++ b/tools/testing/selftests/net/txtimestamp.c
@@ -26,6 +26,7 @@
 #include <inttypes.h>
 #include <linux/errqueue.h>
 #include <linux/if_ether.h>
+#include <linux/if_packet.h>
 #include <linux/ipv6.h>
 #include <linux/net_tstamp.h>
 #include <netdb.h>
@@ -34,7 +35,6 @@
 #include <netinet/ip.h>
 #include <netinet/udp.h>
 #include <netinet/tcp.h>
-#include <netpacket/packet.h>
 #include <poll.h>
 #include <stdarg.h>
 #include <stdbool.h>
@@ -495,12 +495,12 @@ static void do_test(int family, unsigned int report_opt)
 	total_len = cfg_payload_len;
 	if (cfg_use_pf_packet || cfg_proto == SOCK_RAW) {
 		total_len += sizeof(struct udphdr);
-		if (cfg_use_pf_packet || cfg_ipproto == IPPROTO_RAW)
+		if (cfg_use_pf_packet || cfg_ipproto == IPPROTO_RAW) {
 			if (family == PF_INET)
 				total_len += sizeof(struct iphdr);
 			else
 				total_len += sizeof(struct ipv6hdr);
-
+		}
 		/* special case, only rawv6_sendmsg:
 		 * pass proto in sin6_port if not connected
 		 * also see ANK comment in net/ipv4/raw.c
-- 
2.27.0



