Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685FE417444
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345683AbhIXNEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345231AbhIXNCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:02:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73705613CF;
        Fri, 24 Sep 2021 12:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488078;
        bh=x97oscJf7LFjdx7SY2nu19MFFxu5Xkc7uWTtPvxBP78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/ei0d2me2wzRTpMfM8/KcYRRvaHD+4yR3SuvQ4ialdjjtDBdUpa7DviqOdZn60GZ
         lzEWUcFahcjcizESS3hUFX2czkeAVPP9L3Pmf7+i6pBUhhfHC423rndREXE+TQajtc
         wM83qSHyKBIoerKMvh/pFkXJdeiNxTO6hQA3qh1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 034/100] s390/entry: make oklabel within CHKSTG macro local
Date:   Fri, 24 Sep 2021 14:43:43 +0200
Message-Id: <20210924124342.607879488@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 15256194eff64f9a774b33b7817ea663e352394a ]

Make the oklabel within the CHKSTG macro local. This makes sure that
tools like objdump and the crash debugging tool still disassemble full
functions where the macro has been used instead of stopping half way
where such a global label is used and one has to guess how to
disassemble the rest of such a function:

E.g.:

0000000000cb0270 <mcck_int_handler>:
  cb0270:       b2 05 03 20             stck    800
  ...
  cb0354:       a7 74 00 97             jne     cb0482 <oklabel270+0xe2>

0000000000cb0358 <oklabel243>:
  cb0358:       c0 e0 00 22 4e 8f       larl    %r14,10fa076 <opcode+0x2558>
  ...

Fixes: d35925b34996 ("s390/mcck: move storage error checks to assembler")
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/entry.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index b9716a7e326d..4c9b967290ae 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -140,10 +140,10 @@ _LPP_OFFSET	= __LC_LPP
 	TSTMSK	__LC_MCCK_CODE,(MCCK_CODE_STG_ERROR|MCCK_CODE_STG_KEY_ERROR)
 	jnz	\errlabel
 	TSTMSK	__LC_MCCK_CODE,MCCK_CODE_STG_DEGRAD
-	jz	oklabel\@
+	jz	.Loklabel\@
 	TSTMSK	__LC_MCCK_CODE,MCCK_CODE_STG_FAIL_ADDR
 	jnz	\errlabel
-oklabel\@:
+.Loklabel\@:
 	.endm
 
 #if IS_ENABLED(CONFIG_KVM)
-- 
2.33.0



