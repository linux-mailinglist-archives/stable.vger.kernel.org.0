Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BE43F6793
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240529AbhHXRgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240490AbhHXRcE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:32:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19F47610D1;
        Tue, 24 Aug 2021 17:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824758;
        bh=g+YEbINb/kUFZB5S5iLxbmNjgwyj6f8shFy1WJf2Ilg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fQsJe2oU6kg5Afc9Hfu4chtMnBk3vx5Nu9wtzgdzlDmj/csPt9MahJpHA8l5cvQ6J
         8NMKyMo2rL/HijR5Osf81j50aHziURDche3PN2rYIM8EuT9POs6oj8ir89JX7u0OZb
         7MHqxB3n/HRZw+6c+tyD65Kym3EUsZALec09bsGAp2B8GJemLJ8HIeRdHfprAukoDD
         co5C4qW9a1kdbH4Y9fwR3uoVmDwA+sgsvYZq2R4wnraav7jTb74EI75Vn6GQV7Mn0U
         gF7CMzSd8kSDVV36bWGbSDSrOUcrRy2o1ie8JddWcMPMvEv/0qvRDDIOTfk63uEnGw
         xg5pUwlA791RA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 62/64] fs: warn about impending deprecation of mandatory locks
Date:   Tue, 24 Aug 2021 13:04:55 -0400
Message-Id: <20210824170457.710623-63-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit fdd92b64d15bc4aec973caa25899afd782402e68 ]

We've had CONFIG_MANDATORY_FILE_LOCKING since 2015 and a lot of distros
have disabled it. Warn the stragglers that still use "-o mand" that
we'll be dropping support for that mount option.

Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 11def59b0d50..683668a20bed 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1696,8 +1696,12 @@ static inline bool may_mount(void)
 }
 
 #ifdef	CONFIG_MANDATORY_FILE_LOCKING
-static inline bool may_mandlock(void)
+static bool may_mandlock(void)
 {
+	pr_warn_once("======================================================\n"
+		     "WARNING: the mand mount option is being deprecated and\n"
+		     "         will be removed in v5.15!\n"
+		     "======================================================\n");
 	return capable(CAP_SYS_ADMIN);
 }
 #else
-- 
2.30.2

