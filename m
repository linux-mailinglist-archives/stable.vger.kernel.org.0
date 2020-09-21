Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37EA27283F
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgIUOlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:41:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728073AbgIUOle (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 10:41:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EE9E2311D;
        Mon, 21 Sep 2020 14:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600699294;
        bh=y2rnfhnxpWlFVztN7chK05aa0bL7kLddsCgaa2wztrI=;
        h=From:To:Cc:Subject:Date:From;
        b=KNKwI7nsghcc0zY3piJa9QfsI4ypLnLE0LUW5rKUfnCDlT3TT1av2SsQ6+OaPCR5i
         K8pQFUOLvDlv/lhfMsjQyi4RlV7CNRI+ksZZdxBne4GeL1PpGrob1H05d0mgSheKaX
         bNFA1a8KHxgoyNYPzkEzuyXqLVEWIBWyhibSLNO0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 1/3] s390/init: add missing __init annotations
Date:   Mon, 21 Sep 2020 10:41:29 -0400
Message-Id: <20200921144132.2135971-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
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
index a559908d180ec..ce49c2b9db7ee 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -529,7 +529,7 @@ static struct notifier_block kdump_mem_nb = {
 /*
  * Make sure that the area behind memory_end is protected
  */
-static void reserve_memory_end(void)
+static void __init reserve_memory_end(void)
 {
 #ifdef CONFIG_CRASH_DUMP
 	if (ipl_info.type == IPL_TYPE_FCP_DUMP &&
@@ -547,7 +547,7 @@ static void reserve_memory_end(void)
 /*
  * Make sure that oldmem, where the dump is stored, is protected
  */
-static void reserve_oldmem(void)
+static void __init reserve_oldmem(void)
 {
 #ifdef CONFIG_CRASH_DUMP
 	if (OLDMEM_BASE)
@@ -559,7 +559,7 @@ static void reserve_oldmem(void)
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

