Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A55032AF75
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237366AbhCCAW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:22:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:48512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244439AbhCBMVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:21:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 664EF64F97;
        Tue,  2 Mar 2021 11:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686308;
        bh=KOOSiL8u9hwyIFP3sn4UzV1lzfYZw2vsVtIAeMZSaNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MWSFv4yFQFY74Bp/5MKDo5QeaRG9Qt9ZtVMWJXGzBS501Q3mx80KGEgmh3HtoYPvl
         UbduIZJrIRW6XZqgN7awY8y5G1qHwgIDxBWqzLKzFTMPeEI/pT5LJVcYMinCc19cSK
         aKeOZvM+je7N52almOD5BgpAHwgK9sUMo8zS5vt1DFP5BcO2uJ4fyop7VHZ5ez1ZHF
         C3GKZHQxno22YZEXlb34rlzEDg/9UGTPIM7/H0d7QUmYEVkE5r15mOggUNf7MJf01F
         sFFNSQaTDPPIHnfEdw23ayM+x8yC2mo3oCM0tRH9UrDZpSu6zn8HE3ClKbYw9vIbHy
         o5W5ernqb+mUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lin Feng <linf@wangsu.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 29/33] sysctl.c: fix underflow value setting risk in vm_table
Date:   Tue,  2 Mar 2021 06:57:45 -0500
Message-Id: <20210302115749.62653-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115749.62653-1-sashal@kernel.org>
References: <20210302115749.62653-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Feng <linf@wangsu.com>

[ Upstream commit 3b3376f222e3ab58367d9dd405cafd09d5e37b7c ]

Apart from subsystem specific .proc_handler handler, all ctl_tables with
extra1 and extra2 members set should use proc_dointvec_minmax instead of
proc_dointvec, or the limit set in extra* never work and potentially echo
underflow values(negative numbers) is likely make system unstable.

Especially vfs_cache_pressure and zone_reclaim_mode, -1 is apparently not
a valid value, but we can set to them.  And then kernel may crash.

# echo -1 > /proc/sys/vm/vfs_cache_pressure

Link: https://lkml.kernel.org/r/20201223105535.2875-1-linf@wangsu.com
Signed-off-by: Lin Feng <linf@wangsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sysctl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 70665934d53e..eae6a078619f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1563,7 +1563,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &block_dump,
 		.maxlen		= sizeof(block_dump),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 	},
 	{
@@ -1571,7 +1571,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_vfs_cache_pressure,
 		.maxlen		= sizeof(sysctl_vfs_cache_pressure),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 	},
 #if defined(HAVE_ARCH_PICK_MMAP_LAYOUT) || \
@@ -1581,7 +1581,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_legacy_va_layout,
 		.maxlen		= sizeof(sysctl_legacy_va_layout),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 	},
 #endif
@@ -1591,7 +1591,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &node_reclaim_mode,
 		.maxlen		= sizeof(node_reclaim_mode),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 	},
 	{
-- 
2.30.1

