Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCE7483324
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbiACOdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:33:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33000 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234023AbiACObz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:31:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15F1B6111D;
        Mon,  3 Jan 2022 14:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCF6C36AEB;
        Mon,  3 Jan 2022 14:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220314;
        bh=BZ20Galzn1I8vy3gFLN6Zn7/ni5xt6lwWKK/pr0QZBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bveJpX1gPnawZ0GBLsB6Nygvu2ViMTlsC+ohelxFaLzN3oP+UPkzdyMEFWzlh+zmU
         D0Il6k/3lpUpg+jcS5f8nte6cSXPfr5ituZLoj78bTzl+fpuGfkFghmj176YKA9V+n
         viP7Tx2bzZtYiXtJYmWBn/e0yBf9tsUO2bnkRB3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 03/73] tomoyo: Check exceeded quota early in tomoyo_domain_quota_is_ok().
Date:   Mon,  3 Jan 2022 15:23:24 +0100
Message-Id: <20220103142057.026140766@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Vyukov <dvyukov@google.com>

[ Upstream commit 04e57a2d952bbd34bc45744e72be3eecdc344294 ]

If tomoyo is used in a testing/fuzzing environment in learning mode,
for lots of domains the quota will be exceeded and stay exceeded
for prolonged periods of time. In such cases it's pointless (and slow)
to walk the whole acl list again and again just to rediscover that
the quota is exceeded. We already have the TOMOYO_DIF_QUOTA_WARNED flag
that notes the overflow condition. Check it early to avoid the slowdown.

[penguin-kernel]
This patch causes a user visible change that the learning mode will not be
automatically resumed after the quota is increased. To resume the learning
mode, administrator will need to explicitly clear TOMOYO_DIF_QUOTA_WARNED
flag after increasing the quota. But I think that this change is generally
preferable, for administrator likely wants to optimize the acl list for
that domain before increasing the quota, or that domain likely hits the
quota again. Therefore, don't try to care to clear TOMOYO_DIF_QUOTA_WARNED
flag automatically when the quota for that domain changed.

Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/tomoyo/util.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/security/tomoyo/util.c b/security/tomoyo/util.c
index 1da2e3722b126..af8cd2af3466d 100644
--- a/security/tomoyo/util.c
+++ b/security/tomoyo/util.c
@@ -1051,6 +1051,8 @@ bool tomoyo_domain_quota_is_ok(struct tomoyo_request_info *r)
 		return false;
 	if (!domain)
 		return true;
+	if (READ_ONCE(domain->flags[TOMOYO_DIF_QUOTA_WARNED]))
+		return false;
 	list_for_each_entry_rcu(ptr, &domain->acl_info_list, list,
 				srcu_read_lock_held(&tomoyo_ss)) {
 		u16 perm;
@@ -1096,14 +1098,12 @@ bool tomoyo_domain_quota_is_ok(struct tomoyo_request_info *r)
 	if (count < tomoyo_profile(domain->ns, domain->profile)->
 	    pref[TOMOYO_PREF_MAX_LEARNING_ENTRY])
 		return true;
-	if (!domain->flags[TOMOYO_DIF_QUOTA_WARNED]) {
-		domain->flags[TOMOYO_DIF_QUOTA_WARNED] = true;
-		/* r->granted = false; */
-		tomoyo_write_log(r, "%s", tomoyo_dif[TOMOYO_DIF_QUOTA_WARNED]);
+	WRITE_ONCE(domain->flags[TOMOYO_DIF_QUOTA_WARNED], true);
+	/* r->granted = false; */
+	tomoyo_write_log(r, "%s", tomoyo_dif[TOMOYO_DIF_QUOTA_WARNED]);
 #ifndef CONFIG_SECURITY_TOMOYO_INSECURE_BUILTIN_SETTING
-		pr_warn("WARNING: Domain '%s' has too many ACLs to hold. Stopped learning mode.\n",
-			domain->domainname->name);
+	pr_warn("WARNING: Domain '%s' has too many ACLs to hold. Stopped learning mode.\n",
+		domain->domainname->name);
 #endif
-	}
 	return false;
 }
-- 
2.34.1



