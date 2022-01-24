Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1C8498D78
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346522AbiAXTcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:32:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52262 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352052AbiAXT3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:29:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FAB6B811F9;
        Mon, 24 Jan 2022 19:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332FBC340E7;
        Mon, 24 Jan 2022 19:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052569;
        bh=8PyNwfE8AMHt87zLF1fUP0V9ClhrAz8U/sYGHvaLTDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zEqqt95hBf65fslQ9P2FuQxpB6Uhm68vHPp0gFAC5diZvh9+xUQ1EupCeiCgF7A3d
         LZ51b9Q5yTvAgz/IRRPl6Wa4baxmxsbzbuHBr2lOFbqmDScX1OF5VmQ2QNEjuKlLvm
         GxPRF6AxP8Y5sEYRyYdjiTSE038LeNh+fntSHAVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernard Zhao <bernard@vivo.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 095/320] selinux: fix potential memleak in selinux_add_opt()
Date:   Mon, 24 Jan 2022 19:41:19 +0100
Message-Id: <20220124183956.964553715@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernard Zhao <bernard@vivo.com>

[ Upstream commit 2e08df3c7c4e4e74e3dd5104c100f0bf6288aaa8 ]

This patch try to fix potential memleak in error branch.

Fixes: ba6418623385 ("selinux: new helper - selinux_add_opt()")
Signed-off-by: Bernard Zhao <bernard@vivo.com>
[PM: tweak the subject line, add Fixes tag]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/hooks.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 91f2ba0b225b7..56418cf72069d 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -995,18 +995,22 @@ out:
 static int selinux_add_opt(int token, const char *s, void **mnt_opts)
 {
 	struct selinux_mnt_opts *opts = *mnt_opts;
+	bool is_alloc_opts = false;
 
 	if (token == Opt_seclabel)	/* eaten and completely ignored */
 		return 0;
 
+	if (!s)
+		return -ENOMEM;
+
 	if (!opts) {
 		opts = kzalloc(sizeof(struct selinux_mnt_opts), GFP_KERNEL);
 		if (!opts)
 			return -ENOMEM;
 		*mnt_opts = opts;
+		is_alloc_opts = true;
 	}
-	if (!s)
-		return -ENOMEM;
+
 	switch (token) {
 	case Opt_context:
 		if (opts->context || opts->defcontext)
@@ -1031,6 +1035,10 @@ static int selinux_add_opt(int token, const char *s, void **mnt_opts)
 	}
 	return 0;
 Einval:
+	if (is_alloc_opts) {
+		kfree(opts);
+		*mnt_opts = NULL;
+	}
 	pr_warn(SEL_MOUNT_FAIL_MSG);
 	return -EINVAL;
 }
-- 
2.34.1



