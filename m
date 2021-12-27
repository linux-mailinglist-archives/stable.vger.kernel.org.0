Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B4A4803DD
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbhL0TGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232314AbhL0TF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:05:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FFAC061394;
        Mon, 27 Dec 2021 11:05:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 949C6B81142;
        Mon, 27 Dec 2021 19:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B759C36AEE;
        Mon, 27 Dec 2021 19:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631925;
        bh=5oKonMdfPWcTcP5aLeNS3LwAb3WS0ZaSP+v5iP7J+QU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBY/RM9gWWFDpytCcCSL9gh1DAQo3Eb+ql9iH1GJEq6EDkBlfuEmSKjY2Tumks4Gb
         YdFTtWnMFeB+NDfKW49+Qeh/He3tJ+BM1Hghi/V9tXfSu2dYpOrftatUQHrqNpvAAp
         AvPewcAvz7mOxuM5Arnb17h06RFU6mmXjpOXj0cdduijKMlkxL8T5gd2Yqt3lZRm9S
         /4jp0gIVukWADh/Hymx4PQrBeNAHR055YoLtQ1OuFMRAFdDwLwCgaNf3xlrVWOfXqG
         +24lY7Xsrp76WU5GjzfLlXUD4Yx6kb0msAki7D5+yUurOR2K6H5NjiILkOEBoFiGXX
         jm0m3hlMjXbwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Sasha Levin <sashal@kernel.org>, takedakn@nttdata.co.jp,
        jmorris@namei.org, serge@hallyn.com,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 08/14] tomoyo: Check exceeded quota early in tomoyo_domain_quota_is_ok().
Date:   Mon, 27 Dec 2021 14:04:46 -0500
Message-Id: <20211227190452.1042714-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190452.1042714-1-sashal@kernel.org>
References: <20211227190452.1042714-1-sashal@kernel.org>
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
index cd458e10cf2af..ee9c2aa0c8df9 100644
--- a/security/tomoyo/util.c
+++ b/security/tomoyo/util.c
@@ -1046,6 +1046,8 @@ bool tomoyo_domain_quota_is_ok(struct tomoyo_request_info *r)
 		return false;
 	if (!domain)
 		return true;
+	if (READ_ONCE(domain->flags[TOMOYO_DIF_QUOTA_WARNED]))
+		return false;
 	list_for_each_entry_rcu(ptr, &domain->acl_info_list, list,
 				srcu_read_lock_held(&tomoyo_ss)) {
 		u16 perm;
@@ -1091,14 +1093,12 @@ bool tomoyo_domain_quota_is_ok(struct tomoyo_request_info *r)
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

