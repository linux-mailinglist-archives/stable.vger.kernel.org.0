Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B8C1EAF19
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgFAS7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728861AbgFAR5M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:57:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B214A206E2;
        Mon,  1 Jun 2020 17:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034232;
        bh=ru+pvfRNkcRro2tT1hG+yGfIL3EmNtJfHDStCSXK02A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vv1R9rtkBStK6PuPxeHN/FSTamwQ9owKfw3cGfmWJ9BzZSxiJ+FG1eJEU0+P2m8Uu
         7XNBeeLWWGbyLS1CfhTb8bQTSAVso3pmJl5vcPm3ngDMeioaOHhKthV8skKS6hr2/x
         zfcyezL/QFVkeFJLFeTmpyhmltoqI6jRIZy6gmZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.4 34/48] netfilter: nf_conntrack_pptp: prevent buffer overflows in debug code
Date:   Mon,  1 Jun 2020 19:53:44 +0200
Message-Id: <20200601174002.511218187@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601173952.175939894@linuxfoundation.org>
References: <20200601173952.175939894@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 4c559f15efcc43b996f4da528cd7f9483aaca36d upstream.

Dan Carpenter says: "Smatch complains that the value for "cmd" comes
from the network and can't be trusted."

Add pptp_msg_name() helper function that checks for the array boundary.

Fixes: f09943fefe6b ("[NETFILTER]: nf_conntrack/nf_nat: add PPTP helper port")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/netfilter/nf_conntrack_pptp.h |    2 
 net/ipv4/netfilter/nf_nat_pptp.c            |    7 ---
 net/netfilter/nf_conntrack_pptp.c           |   62 +++++++++++++++-------------
 3 files changed, 38 insertions(+), 33 deletions(-)

--- a/include/linux/netfilter/nf_conntrack_pptp.h
+++ b/include/linux/netfilter/nf_conntrack_pptp.h
@@ -4,7 +4,7 @@
 
 #include <linux/netfilter/nf_conntrack_common.h>
 
-extern const char *const pptp_msg_name[];
+extern const char *const pptp_msg_name(u_int16_t msg);
 
 /* state of the control session */
 enum pptp_ctrlsess_state {
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -156,8 +156,7 @@ pptp_outbound_pkt(struct sk_buff *skb,
 		break;
 	default:
 		pr_debug("unknown outbound packet 0x%04x:%s\n", msg,
-			 msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] :
-					       pptp_msg_name[0]);
+			 pptp_msg_name(msg));
 		/* fall through */
 	case PPTP_SET_LINK_INFO:
 		/* only need to NAT in case PAC is behind NAT box */
@@ -250,9 +249,7 @@ pptp_inbound_pkt(struct sk_buff *skb,
 		pcid_off = offsetof(union pptp_ctrl_union, setlink.peersCallID);
 		break;
 	default:
-		pr_debug("unknown inbound packet %s\n",
-			 msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] :
-					       pptp_msg_name[0]);
+		pr_debug("unknown inbound packet %s\n", pptp_msg_name(msg));
 		/* fall through */
 	case PPTP_START_SESSION_REQUEST:
 	case PPTP_START_SESSION_REPLY:
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -71,24 +71,32 @@ EXPORT_SYMBOL_GPL(nf_nat_pptp_hook_expec
 
 #if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
 /* PptpControlMessageType names */
-const char *const pptp_msg_name[] = {
-	"UNKNOWN_MESSAGE",
-	"START_SESSION_REQUEST",
-	"START_SESSION_REPLY",
-	"STOP_SESSION_REQUEST",
-	"STOP_SESSION_REPLY",
-	"ECHO_REQUEST",
-	"ECHO_REPLY",
-	"OUT_CALL_REQUEST",
-	"OUT_CALL_REPLY",
-	"IN_CALL_REQUEST",
-	"IN_CALL_REPLY",
-	"IN_CALL_CONNECT",
-	"CALL_CLEAR_REQUEST",
-	"CALL_DISCONNECT_NOTIFY",
-	"WAN_ERROR_NOTIFY",
-	"SET_LINK_INFO"
+static const char *const pptp_msg_name_array[PPTP_MSG_MAX + 1] = {
+	[0]				= "UNKNOWN_MESSAGE",
+	[PPTP_START_SESSION_REQUEST]	= "START_SESSION_REQUEST",
+	[PPTP_START_SESSION_REPLY]	= "START_SESSION_REPLY",
+	[PPTP_STOP_SESSION_REQUEST]	= "STOP_SESSION_REQUEST",
+	[PPTP_STOP_SESSION_REPLY]	= "STOP_SESSION_REPLY",
+	[PPTP_ECHO_REQUEST]		= "ECHO_REQUEST",
+	[PPTP_ECHO_REPLY]		= "ECHO_REPLY",
+	[PPTP_OUT_CALL_REQUEST]		= "OUT_CALL_REQUEST",
+	[PPTP_OUT_CALL_REPLY]		= "OUT_CALL_REPLY",
+	[PPTP_IN_CALL_REQUEST]		= "IN_CALL_REQUEST",
+	[PPTP_IN_CALL_REPLY]		= "IN_CALL_REPLY",
+	[PPTP_IN_CALL_CONNECT]		= "IN_CALL_CONNECT",
+	[PPTP_CALL_CLEAR_REQUEST]	= "CALL_CLEAR_REQUEST",
+	[PPTP_CALL_DISCONNECT_NOTIFY]	= "CALL_DISCONNECT_NOTIFY",
+	[PPTP_WAN_ERROR_NOTIFY]		= "WAN_ERROR_NOTIFY",
+	[PPTP_SET_LINK_INFO]		= "SET_LINK_INFO"
 };
+
+const char *const pptp_msg_name(u_int16_t msg)
+{
+	if (msg > PPTP_MSG_MAX)
+		return pptp_msg_name_array[0];
+
+	return pptp_msg_name_array[msg];
+}
 EXPORT_SYMBOL(pptp_msg_name);
 #endif
 
@@ -278,7 +286,7 @@ pptp_inbound_pkt(struct sk_buff *skb, un
 	typeof(nf_nat_pptp_hook_inbound) nf_nat_pptp_inbound;
 
 	msg = ntohs(ctlh->messageType);
-	pr_debug("inbound control message %s\n", pptp_msg_name[msg]);
+	pr_debug("inbound control message %s\n", pptp_msg_name(msg));
 
 	switch (msg) {
 	case PPTP_START_SESSION_REPLY:
@@ -313,7 +321,7 @@ pptp_inbound_pkt(struct sk_buff *skb, un
 		pcid = pptpReq->ocack.peersCallID;
 		if (info->pns_call_id != pcid)
 			goto invalid;
-		pr_debug("%s, CID=%X, PCID=%X\n", pptp_msg_name[msg],
+		pr_debug("%s, CID=%X, PCID=%X\n", pptp_msg_name(msg),
 			 ntohs(cid), ntohs(pcid));
 
 		if (pptpReq->ocack.resultCode == PPTP_OUTCALL_CONNECT) {
@@ -330,7 +338,7 @@ pptp_inbound_pkt(struct sk_buff *skb, un
 			goto invalid;
 
 		cid = pptpReq->icreq.callID;
-		pr_debug("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
+		pr_debug("%s, CID=%X\n", pptp_msg_name(msg), ntohs(cid));
 		info->cstate = PPTP_CALL_IN_REQ;
 		info->pac_call_id = cid;
 		break;
@@ -349,7 +357,7 @@ pptp_inbound_pkt(struct sk_buff *skb, un
 		if (info->pns_call_id != pcid)
 			goto invalid;
 
-		pr_debug("%s, PCID=%X\n", pptp_msg_name[msg], ntohs(pcid));
+		pr_debug("%s, PCID=%X\n", pptp_msg_name(msg), ntohs(pcid));
 		info->cstate = PPTP_CALL_IN_CONF;
 
 		/* we expect a GRE connection from PAC to PNS */
@@ -359,7 +367,7 @@ pptp_inbound_pkt(struct sk_buff *skb, un
 	case PPTP_CALL_DISCONNECT_NOTIFY:
 		/* server confirms disconnect */
 		cid = pptpReq->disc.callID;
-		pr_debug("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
+		pr_debug("%s, CID=%X\n", pptp_msg_name(msg), ntohs(cid));
 		info->cstate = PPTP_CALL_NONE;
 
 		/* untrack this call id, unexpect GRE packets */
@@ -386,7 +394,7 @@ pptp_inbound_pkt(struct sk_buff *skb, un
 invalid:
 	pr_debug("invalid %s: type=%d cid=%u pcid=%u "
 		 "cstate=%d sstate=%d pns_cid=%u pac_cid=%u\n",
-		 msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] : pptp_msg_name[0],
+		 pptp_msg_name(msg),
 		 msg, ntohs(cid), ntohs(pcid),  info->cstate, info->sstate,
 		 ntohs(info->pns_call_id), ntohs(info->pac_call_id));
 	return NF_ACCEPT;
@@ -406,7 +414,7 @@ pptp_outbound_pkt(struct sk_buff *skb, u
 	typeof(nf_nat_pptp_hook_outbound) nf_nat_pptp_outbound;
 
 	msg = ntohs(ctlh->messageType);
-	pr_debug("outbound control message %s\n", pptp_msg_name[msg]);
+	pr_debug("outbound control message %s\n", pptp_msg_name(msg));
 
 	switch (msg) {
 	case PPTP_START_SESSION_REQUEST:
@@ -428,7 +436,7 @@ pptp_outbound_pkt(struct sk_buff *skb, u
 		info->cstate = PPTP_CALL_OUT_REQ;
 		/* track PNS call id */
 		cid = pptpReq->ocreq.callID;
-		pr_debug("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
+		pr_debug("%s, CID=%X\n", pptp_msg_name(msg), ntohs(cid));
 		info->pns_call_id = cid;
 		break;
 
@@ -442,7 +450,7 @@ pptp_outbound_pkt(struct sk_buff *skb, u
 		pcid = pptpReq->icack.peersCallID;
 		if (info->pac_call_id != pcid)
 			goto invalid;
-		pr_debug("%s, CID=%X PCID=%X\n", pptp_msg_name[msg],
+		pr_debug("%s, CID=%X PCID=%X\n", pptp_msg_name(msg),
 			 ntohs(cid), ntohs(pcid));
 
 		if (pptpReq->icack.resultCode == PPTP_INCALL_ACCEPT) {
@@ -482,7 +490,7 @@ pptp_outbound_pkt(struct sk_buff *skb, u
 invalid:
 	pr_debug("invalid %s: type=%d cid=%u pcid=%u "
 		 "cstate=%d sstate=%d pns_cid=%u pac_cid=%u\n",
-		 msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] : pptp_msg_name[0],
+		 pptp_msg_name(msg),
 		 msg, ntohs(cid), ntohs(pcid),  info->cstate, info->sstate,
 		 ntohs(info->pns_call_id), ntohs(info->pac_call_id));
 	return NF_ACCEPT;


