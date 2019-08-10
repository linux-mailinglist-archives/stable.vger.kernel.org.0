Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B538B88E3F
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfHJUxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:53:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53900 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726516AbfHJUnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:49 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDK-00053a-0P; Sat, 10 Aug 2019 21:43:46 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-0003Zb-7R; Sat, 10 Aug 2019 21:43:45 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jann Horn" <jannh@google.com>, "Michal Hocko" <mhocko@suse.com>,
        "Tejun Heo" <tj@kernel.org>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.192118175@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 027/157] device_cgroup: fix RCU imbalance in error case
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 0fcc4c8c044e117ac126ab6df4138ea9a67fa2a9 upstream.

When dev_exception_add() returns an error (due to a failed memory
allocation), make sure that we move the RCU preemption count back to where
it was before we were called. We dropped the RCU read lock inside the loop
body, so we can't just "break".

sparse complains about this, too:

$ make -s C=2 security/device_cgroup.o
./include/linux/rcupdate.h:647:9: warning: context imbalance in
'propagate_exception' - unexpected unlock

Fixes: d591fb56618f ("device_cgroup: simplify cgroup tree walk in propagate_exception()")
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 security/device_cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -568,7 +568,7 @@ static int propagate_exception(struct de
 		    devcg->behavior == DEVCG_DEFAULT_ALLOW) {
 			rc = dev_exception_add(devcg, ex);
 			if (rc)
-				break;
+				return rc;
 		} else {
 			/*
 			 * in the other possible cases:

