Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D171DB6A8
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgETO0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:26:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33024 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727016AbgETOW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:27 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbz-000376-Dd; Wed, 20 May 2020 15:22:23 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPby-007DXd-9x; Wed, 20 May 2020 15:22:22 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "J. Bruce Fields" <bfields@redhat.com>,
        "Roberto Bergantinos Corpas" <rbergant@redhat.com>,
        "Frank Sorenson" <sorenson@redhat.com>
Date:   Wed, 20 May 2020 15:15:07 +0100
Message-ID: <lsq.1589984009.543691312@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 99/99] sunrpc: expiry_time should be seconds not timeval
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Roberto Bergantinos Corpas <rbergant@redhat.com>

commit 3d96208c30f84d6edf9ab4fac813306ac0d20c10 upstream.

When upcalling gssproxy, cache_head.expiry_time is set as a
timeval, not seconds since boot. As such, RPC cache expiry
logic will not clean expired objects created under
auth.rpcsec.context cache.

This has proven to cause kernel memory leaks on field. Using
64 bit variants of getboottime/timespec

Expiration times have worked this way since 2010's c5b29f885afe "sunrpc:
use seconds since boot in expiry cache".  The gssproxy code introduced
in 2012 added gss_proxy_save_rsc and introduced the bug.  That's a while
for this to lurk, but it required a bit of an extreme case to make it
obvious.

Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
Fixes: 030d794bf498 "SUNRPC: Use gssproxy upcall for server..."
Tested-By: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[bwh: Backported to 3.16: Use struct timespec and getboottime()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/auth_gss/svcauth_gss.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1171,6 +1171,7 @@ static int gss_proxy_save_rsc(struct cac
 		dprintk("RPC:       No creds found!\n");
 		goto out;
 	} else {
+		struct timespec boot;
 
 		/* steal creds */
 		rsci.cred = ud->creds;
@@ -1191,6 +1192,9 @@ static int gss_proxy_save_rsc(struct cac
 						&expiry, GFP_KERNEL);
 		if (status)
 			goto out;
+
+		getboottime(&boot);
+		expiry -= boot.tv_sec;
 	}
 
 	rsci.h.expiry_time = expiry;

