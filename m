Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C96523FAD8
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgHHXie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:38:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728305AbgHHXia (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:38:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAE2D2075D;
        Sat,  8 Aug 2020 23:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929909;
        bh=i8CA6/j1VbHk5HL5gl8INswoxQFjy/h3zO5JJS8sS7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JrBgI4rw7+1tucuYaLtNo4TCE4hd8Lpfsk9kB9XVxd510A6AWr8jvGYeezTcv4m7I
         Yxu9m1Hw63LhOxgbLZbj2EWL06SmHBXNxTLWkNGv6rS+1/Z1+uW9Aq4/H4uwamZTnD
         v/yrh/ZHzBkKSxIFoBfm3BYVAtX8wVd7d7mQ/n5g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Smalley <stephen.smalley.work@gmail.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>, selinux@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 47/58] scripts/selinux/mdp: fix initial SID handling
Date:   Sat,  8 Aug 2020 19:37:13 -0400
Message-Id: <20200808233724.3618168-47-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233724.3618168-1-sashal@kernel.org>
References: <20200808233724.3618168-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Smalley <stephen.smalley.work@gmail.com>

[ Upstream commit 382c2b5d23b4245f1818f69286db334355488dc4 ]

commit e3e0b582c321 ("selinux: remove unused initial SIDs and improve
handling") broke scripts/selinux/mdp since the unused initial SID names
were removed and the corresponding generation of policy initial SID
definitions by mdp was not updated accordingly.  Fix it.  With latest
upstream checkpolicy it is no longer necessary to include the SID context
definitions for the unused initial SIDs but retain them for compatibility
with older checkpolicy.

Fixes: e3e0b582c321 ("selinux: remove unused initial SIDs and improve handling")
Signed-off-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/selinux/mdp/mdp.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/scripts/selinux/mdp/mdp.c b/scripts/selinux/mdp/mdp.c
index 576d11a60417b..6ceb88eb9b590 100644
--- a/scripts/selinux/mdp/mdp.c
+++ b/scripts/selinux/mdp/mdp.c
@@ -67,8 +67,14 @@ int main(int argc, char *argv[])
 
 	initial_sid_to_string_len = sizeof(initial_sid_to_string) / sizeof (char *);
 	/* print out the sids */
-	for (i = 1; i < initial_sid_to_string_len; i++)
-		fprintf(fout, "sid %s\n", initial_sid_to_string[i]);
+	for (i = 1; i < initial_sid_to_string_len; i++) {
+		const char *name = initial_sid_to_string[i];
+
+		if (name)
+			fprintf(fout, "sid %s\n", name);
+		else
+			fprintf(fout, "sid unused%d\n", i);
+	}
 	fprintf(fout, "\n");
 
 	/* print out the class permissions */
@@ -126,9 +132,16 @@ int main(int argc, char *argv[])
 #define OBJUSERROLETYPE "user_u:object_r:base_t"
 
 	/* default sids */
-	for (i = 1; i < initial_sid_to_string_len; i++)
-		fprintf(fout, "sid %s " SUBJUSERROLETYPE "%s\n",
-			initial_sid_to_string[i], mls ? ":" SYSTEMLOW : "");
+	for (i = 1; i < initial_sid_to_string_len; i++) {
+		const char *name = initial_sid_to_string[i];
+
+		if (name)
+			fprintf(fout, "sid %s ", name);
+		else
+			fprintf(fout, "sid unused%d\n", i);
+		fprintf(fout, SUBJUSERROLETYPE "%s\n",
+			mls ? ":" SYSTEMLOW : "");
+	}
 	fprintf(fout, "\n");
 
 #define FS_USE(behavior, fstype)			    \
-- 
2.25.1

