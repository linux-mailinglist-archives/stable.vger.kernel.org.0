Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1EA56FC87
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbiGKJpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbiGKJoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:44:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67FB357235;
        Mon, 11 Jul 2022 02:21:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 944F8612F3;
        Mon, 11 Jul 2022 09:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788EFC34115;
        Mon, 11 Jul 2022 09:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531311;
        bh=csSJNhzYcJsSPAsuW+YFrLOiXri0TwGOGs5YubKA7kU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/WJ1ClGFocTusqlbql0II1u/yVkAX7eF1Xf+Aza+rWYroqRoJNcwG9PtYnDI4Y/U
         DjFjZjMlf0GO8djgaIc61Syv6wOE0g6B2Z4Ky6rf4/yLmXQzW1OUcQnOHMkrspvz/p
         +c5qWyJbXN9ArwvTpoLZdkiVotPbZsoWUPVqPjHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/230] s390/setup: use physical pointers for memblock_reserve()
Date:   Mon, 11 Jul 2022 11:05:16 +0200
Message-Id: <20220711090605.780037799@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 04f11ed7d8e018e1f01ebda5814ddfeb3a1e6ae1 ]

memblock_reserve() function accepts physcal address of a memory
block to be reserved, but provided with virtual memory pointers.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/setup.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index e38de9e8ee13..2ebde341d057 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -797,13 +797,10 @@ static void __init check_initrd(void)
  */
 static void __init reserve_kernel(void)
 {
-	unsigned long start_pfn = PFN_UP(__pa(_end));
-
 	memblock_reserve(0, STARTUP_NORMAL_OFFSET);
-	memblock_reserve((unsigned long)sclp_early_sccb, EXT_SCCB_READ_SCP);
 	memblock_reserve(__amode31_base, __eamode31 - __samode31);
-	memblock_reserve((unsigned long)_stext, PFN_PHYS(start_pfn)
-			 - (unsigned long)_stext);
+	memblock_reserve(__pa(sclp_early_sccb), EXT_SCCB_READ_SCP);
+	memblock_reserve(__pa(_stext), _end - _stext);
 }
 
 static void __init setup_memory(void)
-- 
2.35.1



