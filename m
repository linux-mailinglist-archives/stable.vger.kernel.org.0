Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6BC9272814
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgIUOlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:41:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727928AbgIUOlF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 10:41:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A3D2238A0;
        Mon, 21 Sep 2020 14:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600699265;
        bh=E/eordJgpj414Zak6XySMtMq6zo0ro8d8JKgukVHNVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSyc+l7I3hKk9hb7IhZqvROZfXU0PoVbfJ3iuBa4hiEJR5A1UfZS9Hpkg6hY51yuX
         FrhtyRVtcq9DzlRKwFB64g9na1HjlL9RMwfkY/2W75LgZVtCmHXwBQqcUvcV0ewcuK
         LfZAHawvPcQpXbbF6npZ8nW2y64In9rOA4pizWv4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/15] s390/init: add missing __init annotations
Date:   Mon, 21 Sep 2020 10:40:47 -0400
Message-Id: <20200921144054.2135602-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921144054.2135602-1-sashal@kernel.org>
References: <20200921144054.2135602-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit fcb2b70cdb194157678fb1a75f9ff499aeba3d2a ]

Add __init to reserve_memory_end, reserve_oldmem and remove_oldmem.
Sometimes these functions are not inlined, and then the build
complains about section mismatch.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/setup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 07b2b61a0289f..cc7726e962639 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -634,7 +634,7 @@ static struct notifier_block kdump_mem_nb = {
 /*
  * Make sure that the area behind memory_end is protected
  */
-static void reserve_memory_end(void)
+static void __init reserve_memory_end(void)
 {
 	if (memory_end_set)
 		memblock_reserve(memory_end, ULONG_MAX);
@@ -643,7 +643,7 @@ static void reserve_memory_end(void)
 /*
  * Make sure that oldmem, where the dump is stored, is protected
  */
-static void reserve_oldmem(void)
+static void __init reserve_oldmem(void)
 {
 #ifdef CONFIG_CRASH_DUMP
 	if (OLDMEM_BASE)
@@ -655,7 +655,7 @@ static void reserve_oldmem(void)
 /*
  * Make sure that oldmem, where the dump is stored, is protected
  */
-static void remove_oldmem(void)
+static void __init remove_oldmem(void)
 {
 #ifdef CONFIG_CRASH_DUMP
 	if (OLDMEM_BASE)
-- 
2.25.1

