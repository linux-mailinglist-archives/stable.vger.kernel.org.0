Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739A71F4528
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388425AbgFISMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:12:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41218 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387667AbgFISF4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:56 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-0001oR-1J; Tue, 09 Jun 2020 19:05:53 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidE-006Vuy-DJ; Tue, 09 Jun 2020 19:05:52 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Paul Moore" <pmoore@redhat.com>,
        "Richard Guy Briggs" <rgb@redhat.com>
Date:   Tue, 09 Jun 2020 19:04:02 +0100
Message-ID: <lsq.1591725832.108846056@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 11/61] selinux: cleanup error reporting in
 selinux_nlmsg_perm()
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

From: Richard Guy Briggs <rgb@redhat.com>

commit e173fb2646a832b424c80904c306b816760ce477 upstream.

Convert audit_log() call to WARN_ONCE().

Rename "type=" to nlmsg_type=" to avoid confusion with the audit record
type.

Added "protocol=" to help track down which protocol (NETLINK_AUDIT?) was used
within the netlink protocol family.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
[Rewrote the patch subject line]
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 security/selinux/hooks.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4683,10 +4683,9 @@ static int selinux_nlmsg_perm(struct soc
 	err = selinux_nlmsg_lookup(sksec->sclass, nlh->nlmsg_type, &perm);
 	if (err) {
 		if (err == -EINVAL) {
-			audit_log(current->audit_context, GFP_KERNEL, AUDIT_SELINUX_ERR,
-				  "SELinux:  unrecognized netlink message"
-				  " type=%hu for sclass=%hu\n",
-				  nlh->nlmsg_type, sksec->sclass);
+			WARN_ONCE(1, "selinux_nlmsg_perm: unrecognized netlink message:"
+				  " protocol=%hu nlmsg_type=%hu sclass=%hu\n",
+				  sk->sk_protocol, nlh->nlmsg_type, sksec->sclass);
 			if (!selinux_enforcing || security_get_allow_unknown())
 				err = 0;
 		}

