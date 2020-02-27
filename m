Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFE14171F05
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732678AbgB0OCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:02:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:37328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733170AbgB0OCh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:02:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4543A20578;
        Thu, 27 Feb 2020 14:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812156;
        bh=4Q9zxIWr3nzH1lCkmXbXCZriRxQ09zVPUbdUTtpjbjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GCswms/94mMBOlbwFEGK7opSydTkzR1SfUiglRZ8CDCdKY+aNVLxnR+cj14HRmAMk
         rUXyRjon0ZkRe7Xle+cD9SSmRhZSLVd+nmvRsxwlfvHN67yxB84dcmTXDlmMCIan/O
         gEEDiSq8oGu1Ny3NQjvtZ4mEIKcCJoOOiO1//WQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.14 237/237] s390/mm: Explicitly compare PAGE_DEFAULT_KEY against zero in storage_key_init_range
Date:   Thu, 27 Feb 2020 14:37:31 +0100
Message-Id: <20200227132313.499491929@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit 380324734956c64cd060e1db4304f3117ac15809 upstream.

Clang warns:

 In file included from ../arch/s390/purgatory/purgatory.c:10:
 In file included from ../include/linux/kexec.h:18:
 In file included from ../include/linux/crash_core.h:6:
 In file included from ../include/linux/elfcore.h:5:
 In file included from ../include/linux/user.h:1:
 In file included from ../arch/s390/include/asm/user.h:11:
 ../arch/s390/include/asm/page.h:45:6: warning: converting the result of
 '<<' to a boolean always evaluates to false
 [-Wtautological-constant-compare]
         if (PAGE_DEFAULT_KEY)
            ^
 ../arch/s390/include/asm/page.h:23:44: note: expanded from macro
 'PAGE_DEFAULT_KEY'
 #define PAGE_DEFAULT_KEY        (PAGE_DEFAULT_ACC << 4)
                                                  ^
 1 warning generated.

Explicitly compare this against zero to silence the warning as it is
intended to be used in a boolean context.

Fixes: de3fa841e429 ("s390/mm: fix compile for PAGE_DEFAULT_KEY != 0")
Link: https://github.com/ClangBuiltLinux/linux/issues/860
Link: https://lkml.kernel.org/r/20200214064207.10381-1-natechancellor@gmail.com
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/page.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -42,7 +42,7 @@ void __storage_key_init_range(unsigned l
 
 static inline void storage_key_init_range(unsigned long start, unsigned long end)
 {
-	if (PAGE_DEFAULT_KEY)
+	if (PAGE_DEFAULT_KEY != 0)
 		__storage_key_init_range(start, end);
 }
 


