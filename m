Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B2C24E8EF
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 18:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgHVQyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 12:54:46 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:39660 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727856AbgHVQyq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Aug 2020 12:54:46 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3EC1FE4389AFD1442589;
        Sun, 23 Aug 2020 00:54:43 +0800 (CST)
Received: from DESKTOP-8N3QUD5.china.huawei.com (10.67.102.173) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Sun, 23 Aug 2020 00:54:35 +0800
From:   Guohua Zhong <zhongguohua1@huawei.com>
To:     <christophe.leroy@csgroup.eu>
CC:     <benh@kernel.crashing.org>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <mpe@ellerman.id.au>, <nixiaoming@huawei.com>, <paulus@samba.org>,
        <stable@vger.kernel.org>, <wangle6@huawei.com>,
        <zhongguohua1@huawei.com>
Subject: =?UTF-8?q?Re=EF=BC=9ARe=3A=20=5BPATCH=5D=20powerpc=3A=20Fix=20a=20bug=20in=20=5F=5Fdiv64=5F32=20if=20divisor=20is=20zero?=
Date:   Sun, 23 Aug 2020 00:54:33 +0800
Message-ID: <20200822165433.58228-1-zhongguohua1@huawei.com>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <8dedfcce-04e0-ec7d-6af5-ec1d6d8602b0@csgroup.eu>
References: <8dedfcce-04e0-ec7d-6af5-ec1d6d8602b0@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.102.173]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>In generic version in lib/math/div64.c, there is no checking of 'base' 
>either.
>Do we really want to add this check in the powerpc version only ?

>The only user of __div64_32() is do_div() in 
>include/asm-generic/div64.h. Wouldn't it be better to do the check there ?

>Christophe

Yet, I have noticed that there is no checking of 'base' in these functions.
But I am not sure how to check is better.As we know that the result is 
undefined when divisor is zero. It maybe good to print error and dump stack.
 Let the process to know that the divisor is zero by sending SIGFPE. 

diff --git a/include/asm-generic/div64.h b/include/asm-generic/div64.h
index a3b98c86f077..161c656ee3ee 100644
--- a/include/asm-generic/div64.h
+++ b/include/asm-generic/div64.h
@@ -43,6 +43,11 @@
 # define do_div(n,base) ({                                     \
        uint32_t __base = (base);                               \
        uint32_t __rem;                                         \
+ if (unlikely(base == 0)) {                          \
+         pr_err("do_div base=%d\n",base);            \
+         dump_stack();                               \
+         force_sig(SIGFPE);                          \
+ }      


Then it also needto add this checking in functions of
div64_s64(), div64_u64(), div64_u64_rem(), div_s64_rem and div_u64_rem () 
in include/linux/math64.h

+ if (unlikely(divisor == 0)) {
+         pr_err("%s divisor=0\n",__func__);
+         dump_stack();
+         force_sig(SIGFPE);
+ }

Guohua

>>  	lwz	r5,0(r3)	# get the dividend into r5/r6
>>  	lwz	r6,4(r3)
>>  	cmplw	r5,r4
>>@@ -52,6 +55,7 @@ __div64_32:
>>  4:	stw	r7,0(r3)	# return the quotient in *r3
>>  	stw	r8,4(r3)
>>  	mr	r3,r6		# return the remainder in r3
>>+5:					# return if divisor r4 is zero
>>  	blr
>>  
>>  /*
>>diff --git a/arch/powerpc/lib/div64.S b/arch/powerpc/lib/div64.S
>>index 3d5426e7dcc4..1cc9bcabf678 100644
>>--- a/arch/powerpc/lib/div64.S
>>+++ b/arch/powerpc/lib/div64.S
>>@@ -13,6 +13,9 @@
>>  #include <asm/processor.h>
>>  
>>  _GLOBAL(__div64_32)
>>+	li	r9,0
>>+	cmplw	r4,r9	# check if divisor r4 is zero
>>+	beq	5f			# jump to label 5 if r4(divisor) is zero
>>  	lwz	r5,0(r3)	# get the dividend into r5/r6
>>  	lwz	r6,4(r3)
>>  	cmplw	r5,r4
>>@@ -52,4 +55,5 @@ _GLOBAL(__div64_32)
>>  4:	stw	r7,0(r3)	# return the quotient in *r3
>>  	stw	r8,4(r3)
>>  	mr	r3,r6		# return the remainder in r3
>>+5:					# return if divisor r4 is zero
>>  	blr
>>

