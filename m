Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC05103F09
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbfKTPkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:40:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53230 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731891AbfKTPkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:22 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5V-0004aq-Bg; Wed, 20 Nov 2019 15:40:13 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5V-0004Ly-1l; Wed, 20 Nov 2019 15:40:13 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David Howells" <dhowells@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Hillf Danton" <hdanton@sina.com>,
        "Sachin Sant" <sachinp@linux.vnet.ibm.com>
Date:   Wed, 20 Nov 2019 15:38:17 +0000
Message-ID: <lsq.1574264230.635488352@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 67/83] keys: Fix missing null pointer check in
 request_key_auth_describe()
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hillf Danton <hdanton@sina.com>

commit d41a3effbb53b1bcea41e328d16a4d046a508381 upstream.

If a request_key authentication token key gets revoked, there's a window in
which request_key_auth_describe() can see it with a NULL payload - but it
makes no check for this and something like the following oops may occur:

	BUG: Kernel NULL pointer dereference at 0x00000038
	Faulting instruction address: 0xc0000000004ddf30
	Oops: Kernel access of bad area, sig: 11 [#1]
	...
	NIP [...] request_key_auth_describe+0x90/0xd0
	LR [...] request_key_auth_describe+0x54/0xd0
	Call Trace:
	[...] request_key_auth_describe+0x54/0xd0 (unreliable)
	[...] proc_keys_show+0x308/0x4c0
	[...] seq_read+0x3d0/0x540
	[...] proc_reg_read+0x90/0x110
	[...] __vfs_read+0x3c/0x70
	[...] vfs_read+0xb4/0x1b0
	[...] ksys_read+0x7c/0x130
	[...] system_call+0x5c/0x70

Fix this by checking for a NULL pointer when describing such a key.

Also make the read routine check for a NULL pointer to be on the safe side.

[DH: Modified to not take already-held rcu lock and modified to also check
 in the read routine]

Fixes: 04c567d9313e ("[PATCH] Keys: Fix race between two instantiators of a key")
Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Signed-off-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 security/keys/request_key_auth.c | 6 ++++++
 1 file changed, 6 insertions(+)

--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -58,6 +58,9 @@ static void request_key_auth_describe(co
 {
 	struct request_key_auth *rka = key->payload.data;
 
+	if (!rka)
+		return;
+
 	seq_puts(m, "key:");
 	seq_puts(m, key->description);
 	if (key_is_instantiated(key))
@@ -75,6 +78,9 @@ static long request_key_auth_read(const
 	size_t datalen;
 	long ret;
 
+	if (!rka)
+		return -EKEYREVOKED;
+
 	datalen = rka->callout_len;
 	ret = datalen;
 

