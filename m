Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D7B1F4505
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388601AbgFISKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:10:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41266 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388143AbgFISF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:57 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-0001od-5w; Tue, 09 Jun 2020 19:05:53 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidE-006VvA-HE; Tue, 09 Jun 2020 19:05:52 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Dmitry Vyukov" <dvyukov@google.com>, stable@vger.kernel.org,
        "Paul Moore" <paul@paul-moore.com>,
        "Stephen Smalley" <stephen.smalley.work@gmail.com>
Date:   Tue, 09 Jun 2020 19:04:06 +0100
Message-ID: <lsq.1591725832.420858282@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 15/61] selinux: properly handle multiple messages in
 selinux_netlink_send()
In-Reply-To: <lsq.1591725831.850867383@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.85-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4669,39 +4669,59 @@ static int selinux_tun_dev_open(void *se
 
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
 			pr_warn_ratelimited("SELinux: unrecognized netlink"
-			       " message: protocol=%hu nlmsg_type=%hu sclass=%s"
-			       " pig=%d comm=%s\n",
-			       sk->sk_protocol, nlh->nlmsg_type,
-			       secclass_map[sksec->sclass - 1].name,
-			       task_pid_nr(current), current->comm);
-			if (!selinux_enforcing || security_get_allow_unknown())
-				err = 0;
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

