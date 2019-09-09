Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0738AAE0BF
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 00:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406401AbfIIWRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 18:17:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406390AbfIIWRf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Sep 2019 18:17:35 -0400
Received: from sasha-vm.mshome.net (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58A2221A4A;
        Mon,  9 Sep 2019 22:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568067455;
        bh=mvLCPdH8ks+yBxxce7wpWGFYX0C27A1EL9Rft6B6j8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNg+e69h8YI4OH6y3c6cMVHzt4QpZ25sub5MT+DpEbUxOSTqtllSix42g1e/ZpAP2
         A1VVHr5CZJFIwmtuX0JhlGCNpF262B6KJVnpEUQxdSi54iTqpoFH25cMrV1yKZPpwo
         qTzc0O8UV40hD0SKNuEfWkzvqqA08xqHakXoGCUU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hillf Danton <hdanton@sina.com>,
        Sachin Sant <sachinp@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 2/2] keys: Fix missing null pointer check in request_key_auth_describe()
Date:   Mon,  9 Sep 2019 11:42:21 -0400
Message-Id: <20190909154221.31473-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909154221.31473-1-sashal@kernel.org>
References: <20190909154221.31473-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hillf Danton <hdanton@sina.com>

[ Upstream commit d41a3effbb53b1bcea41e328d16a4d046a508381 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/request_key_auth.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index 8882b729924dd..976deea0569e3 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -71,6 +71,9 @@ static void request_key_auth_describe(const struct key *key,
 {
 	struct request_key_auth *rka = key->payload.data[0];
 
+	if (!rka)
+		return;
+
 	seq_puts(m, "key:");
 	seq_puts(m, key->description);
 	if (key_is_positive(key))
@@ -88,6 +91,9 @@ static long request_key_auth_read(const struct key *key,
 	size_t datalen;
 	long ret;
 
+	if (!rka)
+		return -EKEYREVOKED;
+
 	datalen = rka->callout_len;
 	ret = datalen;
 
-- 
2.20.1

