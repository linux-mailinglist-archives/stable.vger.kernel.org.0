Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC5B480406
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbhL0TGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232792AbhL0TGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:06:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3221C061759;
        Mon, 27 Dec 2021 11:06:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5475661129;
        Mon, 27 Dec 2021 19:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7C2C36AED;
        Mon, 27 Dec 2021 19:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631964;
        bh=8GgqGsbxpCWx8a0xDbp37nRZ70LFcMCuY9GWf0vsys4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzB+bz3Y4sshmFfZ8OdGoG8U+QgZoGKs7u4p+35hECEUIXHrWFuY4VuhTU8bOHY1W
         KZagh2WfrQeRjVrLmn1Zy5qxa00DDRTBPkK6IRkpKUfQeRrmb6LGGoCUtAPu/ycDP6
         M6+ZzCUvt+fDUpsGAHelz3qURdKe3oWVkuKe8U+Lfg2Ml+UVkyWx63NQLgGMvgzjT4
         m3CiX+2KB8NA/gB9EK5bNcVLeWOVriD+Bgi9DMxSoowTQzV3ew7yY1JWq4pvZwcf8C
         MAZ9KBGJqFUE/afOHvRvZuirAGmz0IWmcleycsHREQybhp0jVeY72z08KVagh9tSWq
         6GOMs8h0sk0xw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Sasha Levin <sashal@kernel.org>, takedakn@nttdata.co.jp,
        jmorris@namei.org, serge@hallyn.com,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 5/9] tomoyo: Check exceeded quota early in tomoyo_domain_quota_is_ok().
Date:   Mon, 27 Dec 2021 14:05:32 -0500
Message-Id: <20211227190536.1042975-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190536.1042975-1-sashal@kernel.org>
References: <20211227190536.1042975-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index eba0b3395851e..861fc6f4ebfb7 100644
--- a/security/tomoyo/util.c
+++ b/security/tomoyo/util.c
@@ -1029,6 +1029,8 @@ bool tomoyo_domain_quota_is_ok(struct tomoyo_request_info *r)
 		return false;
 	if (!domain)
 		return true;
+	if (READ_ONCE(domain->flags[TOMOYO_DIF_QUOTA_WARNED]))
+		return false;
 	list_for_each_entry_rcu(ptr, &domain->acl_info_list, list,
 				srcu_read_lock_held(&tomoyo_ss)) {
 		u16 perm;
@@ -1074,14 +1076,12 @@ bool tomoyo_domain_quota_is_ok(struct tomoyo_request_info *r)
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

