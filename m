Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12D2869666
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387421AbfGOOIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:08:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388577AbfGOOIo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:08:44 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9514C20C01;
        Mon, 15 Jul 2019 14:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199723;
        bh=w5v7sWLAcSUnhsaiQsTidlDrLl91cqg976ss1tbUK9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OWkM9gRjavzej2RGTNA3ISY2sK5DSLNEWI1Yi83iRI0ipP5O5XEf5sZ+1HP+gsqg5
         pGBz6AjPf4U7UhpmxC/PUez9SZ2keE6DE2n55iSYdP752OLDj4PaYiSl7XXxvDe1mu
         c4gVV/hcRunfcTvoLahb8NF+OTBoyd/K2Rd8iYpY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        Kir Kolyshkin <kir@sacred.ru>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>, selinux@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 085/219] selinux: fix empty write to keycreate file
Date:   Mon, 15 Jul 2019 10:01:26 -0400
Message-Id: <20190715140341.6443-85-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Mosnacek <omosnace@redhat.com>

[ Upstream commit 464c258aa45b09f16aa0f05847ed8895873262d9 ]

When sid == 0 (we are resetting keycreate_sid to the default value), we
should skip the KEY__CREATE check.

Before this patch, doing a zero-sized write to /proc/self/keycreate
would check if the current task can create unlabeled keys (which would
usually fail with -EACCESS and generate an AVC). Now it skips the check
and correctly sets the task's keycreate_sid to 0.

Bug report: https://bugzilla.redhat.com/show_bug.cgi?id=1719067

Tested using the reproducer from the report above.

Fixes: 4eb582cf1fbd ("[PATCH] keys: add a way to store the appropriate context for newly-created keys")
Reported-by: Kir Kolyshkin <kir@sacred.ru>
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/hooks.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 614bc753822c..bf37bdce9918 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6269,11 +6269,12 @@ static int selinux_setprocattr(const char *name, void *value, size_t size)
 	} else if (!strcmp(name, "fscreate")) {
 		tsec->create_sid = sid;
 	} else if (!strcmp(name, "keycreate")) {
-		error = avc_has_perm(&selinux_state,
-				     mysid, sid, SECCLASS_KEY, KEY__CREATE,
-				     NULL);
-		if (error)
-			goto abort_change;
+		if (sid) {
+			error = avc_has_perm(&selinux_state, mysid, sid,
+					     SECCLASS_KEY, KEY__CREATE, NULL);
+			if (error)
+				goto abort_change;
+		}
 		tsec->keycreate_sid = sid;
 	} else if (!strcmp(name, "sockcreate")) {
 		tsec->sockcreate_sid = sid;
-- 
2.20.1

