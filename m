Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AD01C363C
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 11:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgEDJza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 05:55:30 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:38675 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726666AbgEDJza (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 05:55:30 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 3A79D414;
        Mon,  4 May 2020 05:55:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 04 May 2020 05:55:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3ysGEP
        lcXDv2AlLdGoOMF3W097IDMjkuXAZwMvORRqM=; b=Vy+6dj6LbHdooAzFqDI/Kp
        ObyMB1c38wwpGJGRdXmXFPa5zb8B1/KIG/4tAZNfWUVpp52FdNidfDxY0pKGaIGV
        5HxZ6zTuvPXnxyIA3hMdLtWux3LNKR80wJc93oUPE6w1V2BcSeuabbif6+ARUzK+
        ggxxpw0RVOMdfFrGDJn3dAOUdVdA2nUNAMlw/g5au9aWRyWaKY4dZypNetQVw/N4
        CB5UYay+MdWPtQJPg5170JrJtl5bFim1MbeuJl+lPWz6cidESnpeIIym0pVGI1AM
        y3Pc6S9tMIyxeamcIMYt/MsJTcAcA8upa5QTgUpZysmuBRRRMAvwiISWMGr0d4TQ
        ==
X-ME-Sender: <xms:kOavXgnK-wSQQlTmoPL-tslKZhJj3ZUSPPEtGeWX0KKwTeXvSUbc4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrjeeggddvtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:kOavXqdLheaWoD2zcXe3R6L3R4QWEZsMcL33BbZLymWflWlXrNaaeg>
    <xmx:kOavXkr2TopkKYpcep5gpzip4HQrPTmCb5yTRItmSWTBC5ZNsuiU3g>
    <xmx:kOavXsNVJNZi498I5hEPYBsaJ22TREXToruLIdVrFvZFFIN9EHx7Rg>
    <xmx:kOavXmffsmLhc4-SGXWoKS7wjXF5MtEANSBTgSh5x5SqvDhLTg6HFwfCWns>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2CAD13065FFD;
        Mon,  4 May 2020 05:55:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] selinux: properly handle multiple messages in" failed to apply to 5.4-stable tree
To:     paul@paul-moore.com, dvyukov@google.com,
        stephen.smalley.work@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 May 2020 11:55:24 +0200
Message-ID: <1588586124220222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fb73974172ffaaf57a7c42f35424d9aece1a5af6 Mon Sep 17 00:00:00 2001
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 28 Apr 2020 09:59:02 -0400
Subject: [PATCH] selinux: properly handle multiple messages in
 selinux_netlink_send()

Fix the SELinux netlink_send hook to properly handle multiple netlink
messages in a single sk_buff; each message is parsed and subject to
SELinux access control.  Prior to this patch, SELinux only inspected
the first message in the sk_buff.

Cc: stable@vger.kernel.org
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index b8e09aedbc56..487d4df0e37c 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5842,40 +5842,60 @@ static unsigned int selinux_ipv6_postroute(void *priv,
 
 static int selinux_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
-	int err = 0;
-	u32 perm;
+	int rc = 0;
+	unsigned int msg_len;
+	unsigned int data_len = skb->len;
+	unsigned char *data = skb->data;
 	struct nlmsghdr *nlh;
 	struct sk_security_struct *sksec = sk->sk_security;
+	u16 sclass = sksec->sclass;
+	u32 perm;
 
-	if (skb->len < NLMSG_HDRLEN) {
-		err = -EINVAL;
-		goto out;
-	}
-	nlh = nlmsg_hdr(skb);
+	while (data_len >= nlmsg_total_size(0)) {
+		nlh = (struct nlmsghdr *)data;
+
+		/* NOTE: the nlmsg_len field isn't reliably set by some netlink
+		 *       users which means we can't reject skb's with bogus
+		 *       length fields; our solution is to follow what
+		 *       netlink_rcv_skb() does and simply skip processing at
+		 *       messages with length fields that are clearly junk
+		 */
+		if (nlh->nlmsg_len < NLMSG_HDRLEN || nlh->nlmsg_len > data_len)
+			return 0;
 
-	err = selinux_nlmsg_lookup(sksec->sclass, nlh->nlmsg_type, &perm);
-	if (err) {
-		if (err == -EINVAL) {
+		rc = selinux_nlmsg_lookup(sclass, nlh->nlmsg_type, &perm);
+		if (rc == 0) {
+			rc = sock_has_perm(sk, perm);
+			if (rc)
+				return rc;
+		} else if (rc == -EINVAL) {
+			/* -EINVAL is a missing msg/perm mapping */
 			pr_warn_ratelimited("SELinux: unrecognized netlink"
-			       " message: protocol=%hu nlmsg_type=%hu sclass=%s"
-			       " pid=%d comm=%s\n",
-			       sk->sk_protocol, nlh->nlmsg_type,
-			       secclass_map[sksec->sclass - 1].name,
-			       task_pid_nr(current), current->comm);
-			if (!enforcing_enabled(&selinux_state) ||
-			    security_get_allow_unknown(&selinux_state))
-				err = 0;
+				" message: protocol=%hu nlmsg_type=%hu sclass=%s"
+				" pid=%d comm=%s\n",
+				sk->sk_protocol, nlh->nlmsg_type,
+				secclass_map[sclass - 1].name,
+				task_pid_nr(current), current->comm);
+			if (enforcing_enabled(&selinux_state) &&
+			    !security_get_allow_unknown(&selinux_state))
+				return rc;
+			rc = 0;
+		} else if (rc == -ENOENT) {
+			/* -ENOENT is a missing socket/class mapping, ignore */
+			rc = 0;
+		} else {
+			return rc;
 		}
 
-		/* Ignore */
-		if (err == -ENOENT)
-			err = 0;
-		goto out;
+		/* move to the next message after applying netlink padding */
+		msg_len = NLMSG_ALIGN(nlh->nlmsg_len);
+		if (msg_len >= data_len)
+			return 0;
+		data_len -= msg_len;
+		data += msg_len;
 	}
 
-	err = sock_has_perm(sk, perm);
-out:
-	return err;
+	return rc;
 }
 
 static void ipc_init_security(struct ipc_security_struct *isec, u16 sclass)

