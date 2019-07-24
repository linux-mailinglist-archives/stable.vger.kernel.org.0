Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F0E73F9D
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfGXT1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:27:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728733AbfGXT1J (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:27:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B53422387;
        Wed, 24 Jul 2019 19:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996428;
        bh=nrWoDL7XEid3OLCQ158UCjFe0QkT4IbeN4Q5Enb0E4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wvyZI1SloFZcUoYoiiRVP0amhmaEIHNXyt7GgvXxmvRA571Lz446prRGeXfj/UgNd
         +vNUmsl0FHmzfgf9UY9Eowa9f4AfZRj4tnKoTuowCTk1CaUt7clhlCgOdSeWUVEOKr
         vXjIzsHWWLE71qZzTDdQia/qwiSG/nOzwqty9blI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kir Kolyshkin <kir@sacred.ru>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 094/413] selinux: fix empty write to keycreate file
Date:   Wed, 24 Jul 2019 21:16:25 +0200
Message-Id: <20190724191741.738557199@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 94de51628fdc..3ec7ac70c313 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6351,11 +6351,12 @@ static int selinux_setprocattr(const char *name, void *value, size_t size)
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



