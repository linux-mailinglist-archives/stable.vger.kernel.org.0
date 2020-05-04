Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822941C4583
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730754AbgEDR7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 13:59:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730745AbgEDR7R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 13:59:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 163782075E;
        Mon,  4 May 2020 17:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615155;
        bh=t8w+2sRhxZxwbC+2v98jlCyInsXJZ75euXsY6SRpUOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v19dZid/AQd+EPzsZpILO1zPGBjQUShpH7tG1ehu23lF6qLHhHB/yzli888coNwor
         MPHGzLnsotFas0opZm1a/N0VZ6XbJI472aWtaUBqFGylWPkZJmo8G9kpt3dg+VLnuC
         FfY9p98y0uqy6QE0pWhz6TpK49XjuzHQ/3wEPIXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 4.4 18/18] selinux: properly handle multiple messages in selinux_netlink_send()
Date:   Mon,  4 May 2020 19:57:16 +0200
Message-Id: <20200504165445.396260466@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165441.533160703@linuxfoundation.org>
References: <20200504165441.533160703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>

commit fb73974172ffaaf57a7c42f35424d9aece1a5af6 upstream.

Fix the SELinux netlink_send hook to properly handle multiple netlink
messages in a single sk_buff; each message is parsed and subject to
SELinux access control.  Prior to this patch, SELinux only inspected
the first message in the sk_buff.

Cc: stable@vger.kernel.org
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/hooks.c |   69 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 24 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4791,38 +4791,59 @@ static int selinux_tun_dev_open(void *se
 
 static int selinux_nlmsg_perm(struct sock *sk, struct sk_buff *skb)
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
 
-	err = selinux_nlmsg_lookup(sksec->sclass, nlh->nlmsg_type, &perm);
-	if (err) {
-		if (err == -EINVAL) {
-			printk(KERN_WARNING
-			       "SELinux: unrecognized netlink message:"
-			       " protocol=%hu nlmsg_type=%hu sclass=%s\n",
-			       sk->sk_protocol, nlh->nlmsg_type,
-			       secclass_map[sksec->sclass - 1].name);
-			if (!selinux_enforcing || security_get_allow_unknown())
-				err = 0;
+		/* NOTE: the nlmsg_len field isn't reliably set by some netlink
+		 *       users which means we can't reject skb's with bogus
+		 *       length fields; our solution is to follow what
+		 *       netlink_rcv_skb() does and simply skip processing at
+		 *       messages with length fields that are clearly junk
+		 */
+		if (nlh->nlmsg_len < NLMSG_HDRLEN || nlh->nlmsg_len > data_len)
+			return 0;
+
+		rc = selinux_nlmsg_lookup(sclass, nlh->nlmsg_type, &perm);
+		if (rc == 0) {
+			rc = sock_has_perm(current, sk, perm);
+			if (rc)
+				return rc;
+		} else if (rc == -EINVAL) {
+			/* -EINVAL is a missing msg/perm mapping */
+			pr_warn_ratelimited("SELinux: unrecognized netlink"
+				" message: protocol=%hu nlmsg_type=%hu sclass=%s"
+				" pid=%d comm=%s\n",
+				sk->sk_protocol, nlh->nlmsg_type,
+				secclass_map[sclass - 1].name,
+				task_pid_nr(current), current->comm);
+			if (selinux_enforcing && !security_get_allow_unknown())
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
 
-	err = sock_has_perm(current, sk, perm);
-out:
-	return err;
+	return rc;
 }
 
 #ifdef CONFIG_NETFILTER


