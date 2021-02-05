Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0256311371
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 22:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbhBEVYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 16:24:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233040AbhBEPCI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:02:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1D0764FD6;
        Fri,  5 Feb 2021 14:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534171;
        bh=Q0YJMTrTR/l+F4HaZBDwWoGPnUXN9co/CyBgHBWXlyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8BVJbLte3r+DbYmqEYPSZLq3e/WLv0GVsILJXPqrHWQA/kWnhQdyKp5PGX7c7Qsq
         ALEuqdmJGjeqOqbpUCBhL0a/QLIUM+wTNqKpE/lMsqOY15vo6ADz5b03RunBzD/NzJ
         N0xUpMdWXhI+WFBl8xbNHcfLuvfJdhyUVoAT0SsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        stable@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 15/57] Revert "x86/setup: dont remove E820_TYPE_RAM for pfn 0"
Date:   Fri,  5 Feb 2021 15:06:41 +0100
Message-Id: <20210205140656.632810535@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

commit 5c279c4cf206e03995e04fd3404fa95ffd243a97 upstream.

This reverts commit bde9cfa3afe4324ec251e4af80ebf9b7afaf7afe.

Changing the first memory page type from E820_TYPE_RESERVED to
E820_TYPE_RAM makes it a part of "System RAM" resource rather than a
reserved resource and this in turn causes devmem_is_allowed() to treat
is as area that can be accessed but it is filled with zeroes instead of
the actual data as previously.

The change in /dev/mem output causes lilo to fail as was reported at
slakware users forum, and probably other legacy applications will
experience similar problems.

Link: https://www.linuxquestions.org/questions/slackware-14/slackware-current-lilo-vesa-warnings-after-recent-updates-4175689617/#post6214439
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/setup.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -666,6 +666,17 @@ static void __init trim_platform_memory_
 static void __init trim_bios_range(void)
 {
 	/*
+	 * A special case is the first 4Kb of memory;
+	 * This is a BIOS owned area, not kernel ram, but generally
+	 * not listed as such in the E820 table.
+	 *
+	 * This typically reserves additional memory (64KiB by default)
+	 * since some BIOSes are known to corrupt low memory.  See the
+	 * Kconfig help text for X86_RESERVE_LOW.
+	 */
+	e820__range_update(0, PAGE_SIZE, E820_TYPE_RAM, E820_TYPE_RESERVED);
+
+	/*
 	 * special case: Some BIOSes report the PC BIOS
 	 * area (640Kb -> 1Mb) as RAM even though it is not.
 	 * take them out.
@@ -722,15 +733,6 @@ early_param("reservelow", parse_reservel
 
 static void __init trim_low_memory_range(void)
 {
-	/*
-	 * A special case is the first 4Kb of memory;
-	 * This is a BIOS owned area, not kernel ram, but generally
-	 * not listed as such in the E820 table.
-	 *
-	 * This typically reserves additional memory (64KiB by default)
-	 * since some BIOSes are known to corrupt low memory.  See the
-	 * Kconfig help text for X86_RESERVE_LOW.
-	 */
 	memblock_reserve(0, ALIGN(reserve_low, PAGE_SIZE));
 }
 	


