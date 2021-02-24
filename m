Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5400323E04
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235054AbhBXNXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:23:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:60516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231809AbhBXNS1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:18:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C45764FBA;
        Wed, 24 Feb 2021 12:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171374;
        bh=BvfUVNlmW6hpcqof91JmPyLE9pKH75gTqzb99INrfgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OAnz02cYmhtsuXqcPmq/v3LLc2Lu8LfC84Q6df8Ei2aILcTKfIb2iOkBaZA0GkhAx
         yt1n6e+XtL2WhUYxssg5O888qcOp61GJoEB6YRS8ZZ8HRCTJjwKOIYrQFLviPYY0wF
         y8JD6S4jy775Xv/tNS9wba2yZIHEl/nqxW2Jtk0w+lpdIWS4v4q81trchw86qHzjkk
         Iie+dS7riWQdUk46f9qxzogWR9y3/Gmc+2h5DKsK4bIwisaX77nQrZ3aS+H4CZE5w1
         euCxyn+D9H7hjqGmHM4Dwxh3Ywvwv1Ccm1YXQNegPazsn/gyWcmjo4GD0O6hrpcl0A
         GNiU/YvXKZQjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+0789a72b46fd91431bd8@syzkaller.appspotmail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 11/11] tomoyo: ignore data race while checking quota
Date:   Wed, 24 Feb 2021 07:55:59 -0500
Message-Id: <20210224125600.484437-11-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125600.484437-1-sashal@kernel.org>
References: <20210224125600.484437-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 5797e861e402fff2bedce4ec8b7c89f4248b6073 ]

syzbot is reporting that tomoyo's quota check is racy [1]. But this check
is tolerant of some degree of inaccuracy. Thus, teach KCSAN to ignore
this data race.

[1] https://syzkaller.appspot.com/bug?id=999533deec7ba6337f8aa25d8bd1a4d5f7e50476

Reported-by: syzbot <syzbot+0789a72b46fd91431bd8@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/tomoyo/file.c    | 16 ++++++++--------
 security/tomoyo/network.c |  8 ++++----
 security/tomoyo/util.c    | 24 ++++++++++++------------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/security/tomoyo/file.c b/security/tomoyo/file.c
index 2367b100cc62d..6c57be9d53898 100644
--- a/security/tomoyo/file.c
+++ b/security/tomoyo/file.c
@@ -355,13 +355,13 @@ static bool tomoyo_merge_path_acl(struct tomoyo_acl_info *a,
 {
 	u16 * const a_perm = &container_of(a, struct tomoyo_path_acl, head)
 		->perm;
-	u16 perm = *a_perm;
+	u16 perm = READ_ONCE(*a_perm);
 	const u16 b_perm = container_of(b, struct tomoyo_path_acl, head)->perm;
 	if (is_delete)
 		perm &= ~b_perm;
 	else
 		perm |= b_perm;
-	*a_perm = perm;
+	WRITE_ONCE(*a_perm, perm);
 	return !perm;
 }
 
@@ -427,14 +427,14 @@ static bool tomoyo_merge_mkdev_acl(struct tomoyo_acl_info *a,
 {
 	u8 *const a_perm = &container_of(a, struct tomoyo_mkdev_acl,
 					 head)->perm;
-	u8 perm = *a_perm;
+	u8 perm = READ_ONCE(*a_perm);
 	const u8 b_perm = container_of(b, struct tomoyo_mkdev_acl, head)
 		->perm;
 	if (is_delete)
 		perm &= ~b_perm;
 	else
 		perm |= b_perm;
-	*a_perm = perm;
+	WRITE_ONCE(*a_perm, perm);
 	return !perm;
 }
 
@@ -504,13 +504,13 @@ static bool tomoyo_merge_path2_acl(struct tomoyo_acl_info *a,
 {
 	u8 * const a_perm = &container_of(a, struct tomoyo_path2_acl, head)
 		->perm;
-	u8 perm = *a_perm;
+	u8 perm = READ_ONCE(*a_perm);
 	const u8 b_perm = container_of(b, struct tomoyo_path2_acl, head)->perm;
 	if (is_delete)
 		perm &= ~b_perm;
 	else
 		perm |= b_perm;
-	*a_perm = perm;
+	WRITE_ONCE(*a_perm, perm);
 	return !perm;
 }
 
@@ -639,14 +639,14 @@ static bool tomoyo_merge_path_number_acl(struct tomoyo_acl_info *a,
 {
 	u8 * const a_perm = &container_of(a, struct tomoyo_path_number_acl,
 					  head)->perm;
-	u8 perm = *a_perm;
+	u8 perm = READ_ONCE(*a_perm);
 	const u8 b_perm = container_of(b, struct tomoyo_path_number_acl, head)
 		->perm;
 	if (is_delete)
 		perm &= ~b_perm;
 	else
 		perm |= b_perm;
-	*a_perm = perm;
+	WRITE_ONCE(*a_perm, perm);
 	return !perm;
 }
 
diff --git a/security/tomoyo/network.c b/security/tomoyo/network.c
index 97527710a72a5..facb8409768d3 100644
--- a/security/tomoyo/network.c
+++ b/security/tomoyo/network.c
@@ -232,14 +232,14 @@ static bool tomoyo_merge_inet_acl(struct tomoyo_acl_info *a,
 {
 	u8 * const a_perm =
 		&container_of(a, struct tomoyo_inet_acl, head)->perm;
-	u8 perm = *a_perm;
+	u8 perm = READ_ONCE(*a_perm);
 	const u8 b_perm = container_of(b, struct tomoyo_inet_acl, head)->perm;
 
 	if (is_delete)
 		perm &= ~b_perm;
 	else
 		perm |= b_perm;
-	*a_perm = perm;
+	WRITE_ONCE(*a_perm, perm);
 	return !perm;
 }
 
@@ -258,14 +258,14 @@ static bool tomoyo_merge_unix_acl(struct tomoyo_acl_info *a,
 {
 	u8 * const a_perm =
 		&container_of(a, struct tomoyo_unix_acl, head)->perm;
-	u8 perm = *a_perm;
+	u8 perm = READ_ONCE(*a_perm);
 	const u8 b_perm = container_of(b, struct tomoyo_unix_acl, head)->perm;
 
 	if (is_delete)
 		perm &= ~b_perm;
 	else
 		perm |= b_perm;
-	*a_perm = perm;
+	WRITE_ONCE(*a_perm, perm);
 	return !perm;
 }
 
diff --git a/security/tomoyo/util.c b/security/tomoyo/util.c
index b974a6997d7f8..e7ae94d28202e 100644
--- a/security/tomoyo/util.c
+++ b/security/tomoyo/util.c
@@ -1038,30 +1038,30 @@ bool tomoyo_domain_quota_is_ok(struct tomoyo_request_info *r)
 		u8 i;
 		if (ptr->is_deleted)
 			continue;
+		/*
+		 * Reading perm bitmap might race with tomoyo_merge_*() because
+		 * caller does not hold tomoyo_policy_lock mutex. But exceeding
+		 * max_learning_entry parameter by a few entries does not harm.
+		 */
 		switch (ptr->type) {
 		case TOMOYO_TYPE_PATH_ACL:
-			perm = container_of(ptr, struct tomoyo_path_acl, head)
-				->perm;
+			data_race(perm = container_of(ptr, struct tomoyo_path_acl, head)->perm);
 			break;
 		case TOMOYO_TYPE_PATH2_ACL:
-			perm = container_of(ptr, struct tomoyo_path2_acl, head)
-				->perm;
+			data_race(perm = container_of(ptr, struct tomoyo_path2_acl, head)->perm);
 			break;
 		case TOMOYO_TYPE_PATH_NUMBER_ACL:
-			perm = container_of(ptr, struct tomoyo_path_number_acl,
-					    head)->perm;
+			data_race(perm = container_of(ptr, struct tomoyo_path_number_acl, head)
+				  ->perm);
 			break;
 		case TOMOYO_TYPE_MKDEV_ACL:
-			perm = container_of(ptr, struct tomoyo_mkdev_acl,
-					    head)->perm;
+			data_race(perm = container_of(ptr, struct tomoyo_mkdev_acl, head)->perm);
 			break;
 		case TOMOYO_TYPE_INET_ACL:
-			perm = container_of(ptr, struct tomoyo_inet_acl,
-					    head)->perm;
+			data_race(perm = container_of(ptr, struct tomoyo_inet_acl, head)->perm);
 			break;
 		case TOMOYO_TYPE_UNIX_ACL:
-			perm = container_of(ptr, struct tomoyo_unix_acl,
-					    head)->perm;
+			data_race(perm = container_of(ptr, struct tomoyo_unix_acl, head)->perm);
 			break;
 		case TOMOYO_TYPE_MANUAL_TASK_ACL:
 			perm = 0;
-- 
2.27.0

