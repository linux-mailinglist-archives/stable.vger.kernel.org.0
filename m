Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C6033B813
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbhCOOCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231853AbhCON7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4703264EE5;
        Mon, 15 Mar 2021 13:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816749;
        bh=pF/HBj5xKjySmeKrIbUM6hI8XEgojQkYIDMkItH5Ypo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cLlFVlpgZILIx2Sdn5FrCi1VMnheB85BbkwaBHpj7LMeUph4oSNYKQFZT3oCuBft2
         sGqikglWcmcRscyLJ3kG3l5IgeY3X3qQ0tjwQiNcaPIBA3spLRiUKH454DE3ZNPveY
         CPYO8hpTcBeYT6wBYIohrH80RpM5Q4g6joFh7/Z8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Feng <linf@wangsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/168] sysctl.c: fix underflow value setting risk in vm_table
Date:   Mon, 15 Mar 2021 14:55:16 +0100
Message-Id: <20210315135553.146806730@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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



