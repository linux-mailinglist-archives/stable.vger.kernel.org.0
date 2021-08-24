Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4213F660E
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240137AbhHXRUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:20:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240354AbhHXRRy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:17:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1F0361ABF;
        Tue, 24 Aug 2021 17:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824527;
        bh=/q8yQ3JYw3AYKOWdv4iXUAHFPvHCHSE40XuW/0e42jE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDAk8IajJ1Od3ZF2xIrZZxA5QaWdiObft1CSnrfBMVacne9bcEIQOgRSao2R/rEfN
         Ex2buDy9Jvunx4Ta5yWcSdVCqXkNGEtQoJIPYYLIXx+3f7WZRSUwnZ/25P4A1FqNRw
         kfKCj7Kv+FUO7Gh9kPK+wjAh3R1a20k2/PX/t0H5nOhtFwpTAKf80r1KvQ8GDUvRO+
         z9Z7M889jufyfaXXoRYhGOurJyRdySwAx+Bo974rxLOu09N+YTd+7INIFyE4G37433
         6kWFI9mSs3tOp09oxBy68+9CGtKMGukiwmQ+nTb0zXt/a2ADIAjGlvD6Jmpnt/ifcu
         t2TPsYk4sBLfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 59/61] fs: warn about impending deprecation of mandatory locks
Date:   Tue, 24 Aug 2021 13:01:04 -0400
Message-Id: <20210824170106.710221-60-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
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
index a092611d89e7..5782cd55dfdb 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1647,8 +1647,12 @@ static inline bool may_mount(void)
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

