Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7DB08C8BE
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbfHNCOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:14:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728535AbfHNCOE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:14:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37D0320842;
        Wed, 14 Aug 2019 02:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748842;
        bh=Zb/R9B9DtprRRLG8MrK+xNGiFUOwbI6WNlDdYyaxKV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehEs2hNOXEyWvni2pPRtu2XZLV919VvnzqNp+yH20xRzwv8FltbYjxNuXOsnEc2rC
         bD3KqMOub0mWHxf6dwTVnQt+50j1TmWmAQzYlaP2lyWHzYS1fsHV19bjV9ZTW7TjAt
         fs5LZg750JlqV5gjRsj8LLXoF9DZb+PN22yAGFG4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 097/123] s390/protvirt: avoid memory sharing for diag 308 set/store
Date:   Tue, 13 Aug 2019 22:10:21 -0400
Message-Id: <20190814021047.14828-97-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit a287a49e672d9762bb85de117b477bdf3ef20bd5 ]

This reverts commit db9492cef45e ("s390/protvirt: add memory sharing for
diag 308 set/store") which due to ultravisor implementation change is
not needed after all.

Fixes: db9492cef45e ("s390/protvirt: add memory sharing for diag 308 set/store")
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/ipl_parm.c | 2 --
 arch/s390/kernel/ipl.c    | 9 ---------
 2 files changed, 11 deletions(-)

diff --git a/arch/s390/boot/ipl_parm.c b/arch/s390/boot/ipl_parm.c
index 3c49bde8aa5e3..b8aa6a9f937b2 100644
--- a/arch/s390/boot/ipl_parm.c
+++ b/arch/s390/boot/ipl_parm.c
@@ -48,9 +48,7 @@ void store_ipl_parmblock(void)
 {
 	int rc;
 
-	uv_set_shared(__pa(&ipl_block));
 	rc = __diag308(DIAG308_STORE, &ipl_block);
-	uv_remove_shared(__pa(&ipl_block));
 	if (rc == DIAG308_RC_OK &&
 	    ipl_block.hdr.version <= IPL_MAX_SUPPORTED_VERSION)
 		ipl_block_valid = 1;
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 2c0a515428d61..6837affc19e81 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -31,7 +31,6 @@
 #include <asm/os_info.h>
 #include <asm/sections.h>
 #include <asm/boot_data.h>
-#include <asm/uv.h>
 #include "entry.h"
 
 #define IPL_PARM_BLOCK_VERSION 0
@@ -892,21 +891,15 @@ static void __reipl_run(void *unused)
 {
 	switch (reipl_type) {
 	case IPL_TYPE_CCW:
-		uv_set_shared(__pa(reipl_block_ccw));
 		diag308(DIAG308_SET, reipl_block_ccw);
-		uv_remove_shared(__pa(reipl_block_ccw));
 		diag308(DIAG308_LOAD_CLEAR, NULL);
 		break;
 	case IPL_TYPE_FCP:
-		uv_set_shared(__pa(reipl_block_fcp));
 		diag308(DIAG308_SET, reipl_block_fcp);
-		uv_remove_shared(__pa(reipl_block_fcp));
 		diag308(DIAG308_LOAD_CLEAR, NULL);
 		break;
 	case IPL_TYPE_NSS:
-		uv_set_shared(__pa(reipl_block_nss));
 		diag308(DIAG308_SET, reipl_block_nss);
-		uv_remove_shared(__pa(reipl_block_nss));
 		diag308(DIAG308_LOAD_CLEAR, NULL);
 		break;
 	case IPL_TYPE_UNKNOWN:
@@ -1176,9 +1169,7 @@ static struct kset *dump_kset;
 
 static void diag308_dump(void *dump_block)
 {
-	uv_set_shared(__pa(dump_block));
 	diag308(DIAG308_SET, dump_block);
-	uv_remove_shared(__pa(dump_block));
 	while (1) {
 		if (diag308(DIAG308_LOAD_NORMAL_DUMP, NULL) != 0x302)
 			break;
-- 
2.20.1

