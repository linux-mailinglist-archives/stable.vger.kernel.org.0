Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC63AB8515
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406460AbfISWRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:17:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406465AbfISWRa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:17:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55C0420678;
        Thu, 19 Sep 2019 22:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931449;
        bh=dHaNzdX8RhfYNR3G9kvpasvBZPNiOdCFP+q6x9pJ5Pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdSojR/Og12xQNgrI6KDcVsiY7oepRQMyw8OXpXS2jh7/zAJ1CE5FQfoJGfpADLfy
         ODvU8u6ogUwKvSKMHV95rDP4LLjp/VchBRXKs3VaESzHuvF4/qzpXJ39C7LKOyQy0H
         2bNhvdaQCFF31utGqxulcUbRStnyDyuZF78eLXoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachin Sant <sachinp@linux.vnet.ibm.com>,
        Hillf Danton <hdanton@sina.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 51/59] keys: Fix missing null pointer check in request_key_auth_describe()
Date:   Fri, 20 Sep 2019 00:04:06 +0200
Message-Id: <20190919214807.790861796@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214755.852282682@linuxfoundation.org>
References: <20190919214755.852282682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5e515791ccd11..1d34b2a5f485e 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -71,6 +71,9 @@ static void request_key_auth_describe(const struct key *key,
 {
 	struct request_key_auth *rka = get_request_key_auth(key);
 
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



