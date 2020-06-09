Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3025E1F4493
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731818AbgFISGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:06:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41304 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388154AbgFISF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:58 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-0001oX-4m; Tue, 09 Jun 2020 19:05:53 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidE-006Vv4-FM; Tue, 09 Jun 2020 19:05:52 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Stephen Smalley" <sds@tycho.nsa.gov>,
        "Marek Milkovic" <mmilkovi@redhat.com>,
        "Paul Moore" <pmoore@redhat.com>
Date:   Tue, 09 Jun 2020 19:04:04 +0100
Message-ID: <lsq.1591725832.755257115@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 13/61] selinux: Print 'sclass' as string when
 unrecognized netlink message occurs
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

From: Marek Milkovic <mmilkovi@redhat.com>

commit cded3fffbeab777e6ad2ec05d4a3b62c5caca0f3 upstream.

This prints the 'sclass' field as string instead of index in unrecognized netlink message.
The textual representation makes it easier to distinguish the right class.

Signed-off-by: Marek Milkovic <mmilkovi@redhat.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
[PM: 80-char width fixes]
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 security/selinux/hooks.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4685,8 +4685,9 @@ static int selinux_nlmsg_perm(struct soc
 		if (err == -EINVAL) {
 			printk(KERN_WARNING
 			       "SELinux: unrecognized netlink message:"
-			       " protocol=%hu nlmsg_type=%hu sclass=%hu\n",
-			       sk->sk_protocol, nlh->nlmsg_type, sksec->sclass);
+			       " protocol=%hu nlmsg_type=%hu sclass=%s\n",
+			       sk->sk_protocol, nlh->nlmsg_type,
+			       secclass_map[sksec->sclass - 1].name);
 			if (!selinux_enforcing || security_get_allow_unknown())
 				err = 0;
 		}

