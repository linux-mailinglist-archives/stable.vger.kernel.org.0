Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE5732E7DD
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbhCEMXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:23:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:58232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229821AbhCEMXZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:23:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D861564FEE;
        Fri,  5 Mar 2021 12:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947005;
        bh=MuQQ9FfgXAtpfwnYyB0YETjp8KeoehMkoIzxsMgu8ZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1P6dKXSPaKdidcMVw04o2PlNEYa+APr2L5bf7vq+vH0yW3rZqUffRSHgJHZSby9uM
         eg/jk3t8P69s4vozoxEl1Xfoc8p3rEe9s2YykvyHapC/DAQKH7di0Ms/yrNK8Ocjgf
         m8mvGTHDKAq+rxNQcK6LiIvBdBF6BtxCxLGFp5NY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+0789a72b46fd91431bd8@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 5.11 014/104] tomoyo: ignore data race while checking quota
Date:   Fri,  5 Mar 2021 13:20:19 +0100
Message-Id: <20210305120903.884706871@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 5797e861e402fff2bedce4ec8b7c89f4248b6073 upstream.

syzbot is reporting that tomoyo's quota check is racy [1]. But this check
is tolerant of some degree of inaccuracy. Thus, teach KCSAN to ignore
this data race.

[1] https://syzkaller.appspot.com/bug?id=999533deec7ba6337f8aa25d8bd1a4d5f7e50476

Reported-by: syzbot <syzbot+0789a72b46fd91431bd8@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/tomoyo/file.c    |   16 ++++++++--------
 security/tomoyo/network.c |    8 ++++----
 security/tomoyo/util.c    |   24 ++++++++++++------------
 3 files changed, 24 insertions(+), 24 deletions(-)

--- a/security/tomoyo/file.c
+++ b/security/tomoyo/file.c
@@ -362,14 +362,14 @@ static bool tomoyo_merge_path_acl(struct
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
 
@@ -437,7 +437,7 @@ static bool tomoyo_merge_mkdev_acl(struc
 {
 	u8 *const a_perm = &container_of(a, struct tomoyo_mkdev_acl,
 					 head)->perm;
-	u8 perm = *a_perm;
+	u8 perm = READ_ONCE(*a_perm);
 	const u8 b_perm = container_of(b, struct tomoyo_mkdev_acl, head)
 		->perm;
 
@@ -445,7 +445,7 @@ static bool tomoyo_merge_mkdev_acl(struc
 		perm &= ~b_perm;
 	else
 		perm |= b_perm;
-	*a_perm = perm;
+	WRITE_ONCE(*a_perm, perm);
 	return !perm;
 }
 
@@ -517,14 +517,14 @@ static bool tomoyo_merge_path2_acl(struc
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
 
@@ -655,7 +655,7 @@ static bool tomoyo_merge_path_number_acl
 {
 	u8 * const a_perm = &container_of(a, struct tomoyo_path_number_acl,
 					  head)->perm;
-	u8 perm = *a_perm;
+	u8 perm = READ_ONCE(*a_perm);
 	const u8 b_perm = container_of(b, struct tomoyo_path_number_acl, head)
 		->perm;
 
@@ -663,7 +663,7 @@ static bool tomoyo_merge_path_number_acl
 		perm &= ~b_perm;
 	else
 		perm |= b_perm;
-	*a_perm = perm;
+	WRITE_ONCE(*a_perm, perm);
 	return !perm;
 }
 
--- a/security/tomoyo/network.c
+++ b/security/tomoyo/network.c
@@ -233,14 +233,14 @@ static bool tomoyo_merge_inet_acl(struct
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
 
@@ -259,14 +259,14 @@ static bool tomoyo_merge_unix_acl(struct
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
 
--- a/security/tomoyo/util.c
+++ b/security/tomoyo/util.c
@@ -1058,30 +1058,30 @@ bool tomoyo_domain_quota_is_ok(struct to
 
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


