Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD2F12F116
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgABWPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:15:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:57260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728147AbgABWPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:15:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 459912253D;
        Thu,  2 Jan 2020 22:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003351;
        bh=ZMbrNIIoItAzyHQtsTUS7XyHOzTm8U/IXoFwb/X6Cp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4+5WaPPhIGd3pkaQvhG5WyVcEwzoUTPd5WWWOtV3+4VdDnbAQxtvFJbkT2JaOcz8
         3+J7bb/875fjOlxsFz++v9QJ4dEi4jxNueRs8FPtdr0qkG86F6QXZeNoe+PJ6bTypZ
         XAdXXS3kCJL6qqPU2U7b3ftz/+ovxMEjD2mQd1LI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 125/191] s390: disable preemption when switching to nodat stack with CALL_ON_STACK
Date:   Thu,  2 Jan 2020 23:06:47 +0100
Message-Id: <20200102215843.173677161@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 7f28dad395243c5026d649136823bbc40029a828 ]

Make sure preemption is disabled when temporary switching to nodat
stack with CALL_ON_STACK helper, because nodat stack is per cpu.

Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/machine_kexec.c |  2 ++
 arch/s390/mm/maccess.c           | 12 +++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/machine_kexec.c b/arch/s390/kernel/machine_kexec.c
index d402ced7f7c3..cb8b1cc285c9 100644
--- a/arch/s390/kernel/machine_kexec.c
+++ b/arch/s390/kernel/machine_kexec.c
@@ -164,7 +164,9 @@ static bool kdump_csum_valid(struct kimage *image)
 #ifdef CONFIG_CRASH_DUMP
 	int rc;
 
+	preempt_disable();
 	rc = CALL_ON_STACK(do_start_kdump, S390_lowcore.nodat_stack, 1, image);
+	preempt_enable();
 	return rc == 0;
 #else
 	return false;
diff --git a/arch/s390/mm/maccess.c b/arch/s390/mm/maccess.c
index 59ad7997fed1..de7ca4b6718f 100644
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -119,9 +119,15 @@ static unsigned long __no_sanitize_address _memcpy_real(unsigned long dest,
  */
 int memcpy_real(void *dest, void *src, size_t count)
 {
-	if (S390_lowcore.nodat_stack != 0)
-		return CALL_ON_STACK(_memcpy_real, S390_lowcore.nodat_stack,
-				     3, dest, src, count);
+	int rc;
+
+	if (S390_lowcore.nodat_stack != 0) {
+		preempt_disable();
+		rc = CALL_ON_STACK(_memcpy_real, S390_lowcore.nodat_stack, 3,
+				   dest, src, count);
+		preempt_enable();
+		return rc;
+	}
 	/*
 	 * This is a really early memcpy_real call, the stacks are
 	 * not set up yet. Just call _memcpy_real on the early boot
-- 
2.20.1



