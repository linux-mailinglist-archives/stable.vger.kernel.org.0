Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C810CEEC60
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388419AbfKDV4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:56:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:52232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388407AbfKDV4h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:56:37 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2012D217F4;
        Mon,  4 Nov 2019 21:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904596;
        bh=vo9KI/6ReG4GAX0/NrUSIFMAlhImi0q1vwrXi1egK4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zwx0t1wLZozDkXRi+/5No8M9r94UTLz91pjNIbiN2trp3LTxZ8llkpsWj8WsLQCX9
         Jl2o8fAFKJEfEXb2DKFpYygu1tv34Ut1tnstx2WLCr99XYusPYnL88GXCiCgSAUdMC
         +5obBxqUECzTGRHvwNoSiYe11eNBq0w3v/AxuXGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 55/95] s390/uaccess: avoid (false positive) compiler warnings
Date:   Mon,  4 Nov 2019 22:44:53 +0100
Message-Id: <20191104212105.778612650@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

[ Upstream commit 062795fcdcb2d22822fb42644b1d76a8ad8439b3 ]

Depending on inlining decisions by the compiler, __get/put_user_fn
might become out of line. Then the compiler is no longer able to tell
that size can only be 1,2,4 or 8 due to the check in __get/put_user
resulting in false positives like

./arch/s390/include/asm/uaccess.h: In function ‘__put_user_fn’:
./arch/s390/include/asm/uaccess.h:113:9: warning: ‘rc’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  113 |  return rc;
      |         ^~
./arch/s390/include/asm/uaccess.h: In function ‘__get_user_fn’:
./arch/s390/include/asm/uaccess.h:143:9: warning: ‘rc’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  143 |  return rc;
      |         ^~

These functions are supposed to be always inlined. Mark it as such.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/uaccess.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/uaccess.h b/arch/s390/include/asm/uaccess.h
index 689eae8d38591..bd7a19a0aecf7 100644
--- a/arch/s390/include/asm/uaccess.h
+++ b/arch/s390/include/asm/uaccess.h
@@ -95,7 +95,7 @@ raw_copy_to_user(void __user *to, const void *from, unsigned long n);
 	__rc;							\
 })
 
-static inline int __put_user_fn(void *x, void __user *ptr, unsigned long size)
+static __always_inline int __put_user_fn(void *x, void __user *ptr, unsigned long size)
 {
 	unsigned long spec = 0x810000UL;
 	int rc;
@@ -125,7 +125,7 @@ static inline int __put_user_fn(void *x, void __user *ptr, unsigned long size)
 	return rc;
 }
 
-static inline int __get_user_fn(void *x, const void __user *ptr, unsigned long size)
+static __always_inline int __get_user_fn(void *x, const void __user *ptr, unsigned long size)
 {
 	unsigned long spec = 0x81UL;
 	int rc;
-- 
2.20.1



