Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E43621482
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbiKHOCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234873AbiKHOBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:01:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E88682AE
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:01:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9618061596
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A711AC433D7;
        Tue,  8 Nov 2022 14:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916110;
        bh=ra344XJaZ/mUXKVyI5FxJLmOKV6W4ZGOmET+VZR+9pY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SqK7BFwF5CToeiM5EOAjh1PxsT1HGF04M8pbjz/5zGyAs1ifT+AJQf+MFId0gnlSw
         FmOnDqEYqblJWv3rz2hXXjbZjmXCjAbRzCDkKTBJKJEyJb82m2Ba5Z8FMVjka3F4tH
         NZEcz1BnKzPqkBl8YWTWR/For6osa3SNpYH2+jCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/144] s390/uaccess: add missing EX_TABLE entries to __clear_user()
Date:   Tue,  8 Nov 2022 14:39:02 +0100
Message-Id: <20221108133348.021360716@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 4e1b5a86a5edfbefc9396d41b0fc1a2ebd0101b6 ]

For some exception types the instruction address points behind the
instruction that caused the exception. Take that into account and add
the missing exception table entries.

Cc: <stable@vger.kernel.org>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/lib/uaccess.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/lib/uaccess.c b/arch/s390/lib/uaccess.c
index a596e69d3c47..0b012ce0921c 100644
--- a/arch/s390/lib/uaccess.c
+++ b/arch/s390/lib/uaccess.c
@@ -212,7 +212,7 @@ static inline unsigned long clear_user_mvcos(void __user *to, unsigned long size
 	asm volatile(
 		"   llilh 0,%[spec]\n"
 		"0: .insn ss,0xc80000000000,0(%0,%1),0(%4),0\n"
-		"   jz	  4f\n"
+		"6: jz	  4f\n"
 		"1: algr  %0,%2\n"
 		"   slgr  %1,%2\n"
 		"   j	  0b\n"
@@ -222,11 +222,11 @@ static inline unsigned long clear_user_mvcos(void __user *to, unsigned long size
 		"   clgr  %0,%3\n"	/* copy crosses next page boundary? */
 		"   jnh	  5f\n"
 		"3: .insn ss,0xc80000000000,0(%3,%1),0(%4),0\n"
-		"   slgr  %0,%3\n"
+		"7: slgr  %0,%3\n"
 		"   j	  5f\n"
 		"4: slgr  %0,%0\n"
 		"5:\n"
-		EX_TABLE(0b,2b) EX_TABLE(3b,5b)
+		EX_TABLE(0b,2b) EX_TABLE(6b,2b) EX_TABLE(3b,5b) EX_TABLE(7b,5b)
 		: "+a" (size), "+a" (to), "+a" (tmp1), "=a" (tmp2)
 		: "a" (empty_zero_page), [spec] "K" (0x81UL)
 		: "cc", "memory", "0");
-- 
2.35.1



