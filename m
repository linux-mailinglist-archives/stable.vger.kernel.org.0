Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E31593B16
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343962AbiHOTkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343953AbiHOTiQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:38:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1587331357;
        Mon, 15 Aug 2022 11:46:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BEBCB8105D;
        Mon, 15 Aug 2022 18:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DACC433D6;
        Mon, 15 Aug 2022 18:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589186;
        bh=OiLI/r7+B3K8dB10cvzdDcNRahAya9DTiPCTuRpfaaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNgTd/CtRuDd0G+HVBLBSuyFObninhKDZhnwtP/5pqaT8tl358Uvyzi4wlL6qkl6W
         /otFFrek0FXReD2z+QNHSMIkQKnGYI0aIOwlM/70y+wVUNxkG+1AjXcYwUmQcl58+S
         LwcMHnlk2JUMBC+y0bGInNecQbBfzJ8beNsKSs5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 640/779] s390/dump: fix os_info virtual vs physical address confusion
Date:   Mon, 15 Aug 2022 20:04:44 +0200
Message-Id: <20220815180404.705724643@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 9de209c7d584d6e06ad92f120d83d4f27c200497 ]

Due to historical reasons os_info handling functions misuse
the notion of physical vs virtual addresses difference.

Note: this does not fix a bug currently, since virtual
and physical addresses are identical.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/os_info.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/os_info.c b/arch/s390/kernel/os_info.c
index e548844dde28..6b5b64e67eee 100644
--- a/arch/s390/kernel/os_info.c
+++ b/arch/s390/kernel/os_info.c
@@ -46,7 +46,7 @@ void os_info_crashkernel_add(unsigned long base, unsigned long size)
  */
 void os_info_entry_add(int nr, void *ptr, u64 size)
 {
-	os_info.entry[nr].addr = (u64)(unsigned long)ptr;
+	os_info.entry[nr].addr = __pa(ptr);
 	os_info.entry[nr].size = size;
 	os_info.entry[nr].csum = (__force u32)csum_partial(ptr, size, 0);
 	os_info.csum = os_info_csum(&os_info);
@@ -63,7 +63,7 @@ void __init os_info_init(void)
 	os_info.version_minor = OS_INFO_VERSION_MINOR;
 	os_info.magic = OS_INFO_MAGIC;
 	os_info.csum = os_info_csum(&os_info);
-	mem_assign_absolute(S390_lowcore.os_info, (unsigned long) ptr);
+	mem_assign_absolute(S390_lowcore.os_info, __pa(ptr));
 }
 
 #ifdef CONFIG_CRASH_DUMP
-- 
2.35.1



