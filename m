Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394421F4491
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733005AbgFISGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:06:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41212 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733019AbgFISF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:57 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-0001oY-2V; Tue, 09 Jun 2020 19:05:53 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidE-006Vv8-G0; Tue, 09 Jun 2020 19:05:52 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Paul Moore" <pmoore@redhat.com>,
        "Vladis Dronov" <vdronov@redhat.com>,
        "Florian Weimer" <fweimer@redhat.com>
Date:   Tue, 09 Jun 2020 19:04:05 +0100
Message-ID: <lsq.1591725832.177460283@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 14/61] selinux: rate-limit netlink message warnings
 in selinux_nlmsg_perm()
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

From: Vladis Dronov <vdronov@redhat.com>

commit 76319946f321e30872dd72af7de867cb26e7a373 upstream.

Any process is able to send netlink messages with invalid types.
Make the warning rate-limited to prevent too much log spam.

The warning is supposed to help to find misbehaving programs, so
print the triggering command name and pid.

Reported-by: Florian Weimer <fweimer@redhat.com>
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
[PM: subject line tweak to make checkpatch.pl happy]
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 security/selinux/hooks.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4683,11 +4683,12 @@ static int selinux_nlmsg_perm(struct soc
 	err = selinux_nlmsg_lookup(sksec->sclass, nlh->nlmsg_type, &perm);
 	if (err) {
 		if (err == -EINVAL) {
-			printk(KERN_WARNING
-			       "SELinux: unrecognized netlink message:"
-			       " protocol=%hu nlmsg_type=%hu sclass=%s\n",
+			pr_warn_ratelimited("SELinux: unrecognized netlink"
+			       " message: protocol=%hu nlmsg_type=%hu sclass=%s"
+			       " pig=%d comm=%s\n",
 			       sk->sk_protocol, nlh->nlmsg_type,
-			       secclass_map[sksec->sclass - 1].name);
+			       secclass_map[sksec->sclass - 1].name,
+			       task_pid_nr(current), current->comm);
 			if (!selinux_enforcing || security_get_allow_unknown())
 				err = 0;
 		}

