Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD9873BD7
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392452AbfGXUEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:04:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392456AbfGXUEI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:04:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 496A32147A;
        Wed, 24 Jul 2019 20:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998647;
        bh=lgxI0LR00qRyA3YaGTN518XuZEY2K4RnWD2AbaPaGdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5yq8Uw50EIAxughepC+xf74JxhFPogfo7Y+9EhQLajk8yk8PQXLPID71rEqUX4G/
         NMjMmDRe3Jj0EAJjw4oAuLPzeiaih2lv1DFe6PtxB8H6RclycMugRiSWt4Jj/F81G9
         P6ADdWTQqald252A2tT7C4oP/Uc7f/JEFWcZEZlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kir Kolyshkin <kir@sacred.ru>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 066/271] selinux: fix empty write to keycreate file
Date:   Wed, 24 Jul 2019 21:18:55 +0200
Message-Id: <20190724191700.851717639@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
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
index 70bad15ed7a0..109ab510bdb1 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6550,11 +6550,12 @@ static int selinux_setprocattr(const char *name, void *value, size_t size)
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



