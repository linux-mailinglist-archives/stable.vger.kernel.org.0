Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1CF33B610
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhCON5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230171AbhCON42 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:56:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2998F64EEC;
        Mon, 15 Mar 2021 13:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816588;
        bh=l+hG+PDxI5oUmeycNqyLAqFnhVmuZGA9y8eqVYh3WT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UK/5JUvK2L79lmP+8SxyF9F6iCgAMWzBz+Y2Hr+X6gOW0npC84REu4qBNvFWLddXZ
         bKrH5V1NH2UOku9K82YEGG8g79nbE9ev+mm8Cr2nLBEf+n68nBN1VVHZrFf7pqDZVp
         LPaUFmSz1t/HAwV9GUKVqKijkjrSRzUU/WDafaYc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH 5.11 007/306] mptcp: fix length of ADD_ADDR with port sub-option
Date:   Mon, 15 Mar 2021 14:51:10 +0100
Message-Id: <20210315135507.868324590@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Davide Caratti <dcaratti@redhat.com>

commit 27ab92d9996e4e003a726d22c56d780a1655d6b4 upstream.

in current Linux, MPTCP peers advertising endpoints with port numbers use
a sub-option length that wrongly accounts for the trailing TCP NOP. Also,
receivers will only process incoming ADD_ADDR with port having such wrong
sub-option length. Fix this, making ADD_ADDR compliant to RFC8684 §3.4.1.

this can be verified running tcpdump on the kselftests artifacts:

 unpatched kernel:
 [root@bottarga mptcp]# tcpdump -tnnr unpatched.pcap | grep add-addr
 reading from file unpatched.pcap, link-type LINUX_SLL (Linux cooked v1), snapshot length 65535
 IP 10.0.1.1.10000 > 10.0.1.2.53078: Flags [.], ack 101, win 509, options [nop,nop,TS val 214459678 ecr 521312851,mptcp add-addr v1 id 1 a00:201:2774:2d88:7436:85c3:17fd:101], length 0
 IP 10.0.1.2.53078 > 10.0.1.1.10000: Flags [.], ack 101, win 502, options [nop,nop,TS val 521312852 ecr 214459678,mptcp add-addr[bad opt]]

 patched kernel:
 [root@bottarga mptcp]# tcpdump -tnnr patched.pcap | grep add-addr
 reading from file patched.pcap, link-type LINUX_SLL (Linux cooked v1), snapshot length 65535
 IP 10.0.1.1.10000 > 10.0.1.2.38178: Flags [.], ack 101, win 509, options [nop,nop,TS val 3728873902 ecr 2732713192,mptcp add-addr v1 id 1 10.0.2.1:10100 hmac 0xbccdfcbe59292a1f,nop,nop], length 0
 IP 10.0.1.2.38178 > 10.0.1.1.10000: Flags [.], ack 101, win 502, options [nop,nop,TS val 2732713195 ecr 3728873902,mptcp add-addr v1-echo id 1 10.0.2.1:10100,nop,nop], length 0

Fixes: 22fb85ffaefb ("mptcp: add port support for ADD_ADDR suboption writing")
CC: stable@vger.kernel.org # 5.11+
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Acked-and-tested-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.h |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -50,14 +50,15 @@
 #define TCPOLEN_MPTCP_DSS_MAP64		14
 #define TCPOLEN_MPTCP_DSS_CHECKSUM	2
 #define TCPOLEN_MPTCP_ADD_ADDR		16
-#define TCPOLEN_MPTCP_ADD_ADDR_PORT	20
+#define TCPOLEN_MPTCP_ADD_ADDR_PORT	18
 #define TCPOLEN_MPTCP_ADD_ADDR_BASE	8
-#define TCPOLEN_MPTCP_ADD_ADDR_BASE_PORT	12
+#define TCPOLEN_MPTCP_ADD_ADDR_BASE_PORT	10
 #define TCPOLEN_MPTCP_ADD_ADDR6		28
-#define TCPOLEN_MPTCP_ADD_ADDR6_PORT	32
+#define TCPOLEN_MPTCP_ADD_ADDR6_PORT	30
 #define TCPOLEN_MPTCP_ADD_ADDR6_BASE	20
-#define TCPOLEN_MPTCP_ADD_ADDR6_BASE_PORT	24
-#define TCPOLEN_MPTCP_PORT_LEN		4
+#define TCPOLEN_MPTCP_ADD_ADDR6_BASE_PORT	22
+#define TCPOLEN_MPTCP_PORT_LEN		2
+#define TCPOLEN_MPTCP_PORT_ALIGN	2
 #define TCPOLEN_MPTCP_RM_ADDR_BASE	4
 #define TCPOLEN_MPTCP_FASTCLOSE		12
 
@@ -587,8 +588,9 @@ static inline unsigned int mptcp_add_add
 		len = TCPOLEN_MPTCP_ADD_ADDR6_BASE;
 	if (!echo)
 		len += MPTCPOPT_THMAC_LEN;
+	/* account for 2 trailing 'nop' options */
 	if (port)
-		len += TCPOLEN_MPTCP_PORT_LEN;
+		len += TCPOLEN_MPTCP_PORT_LEN + TCPOLEN_MPTCP_PORT_ALIGN;
 
 	return len;
 }


