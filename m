Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1943563E7
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 08:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345612AbhDGG2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 02:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345586AbhDGG2q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 02:28:46 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1139CC06174A;
        Tue,  6 Apr 2021 23:28:37 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 11so10461410pfn.9;
        Tue, 06 Apr 2021 23:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Np2o8KPS2ztKTn/RRgx0OmT92ImbyV11Hw/jIVQgjbc=;
        b=tEmzL0Dp4Dw0/5Y3IH4/k3QFSUmQpD4cZox9rkQpOMSkBS4D7BZ3/x0EIIfsq/4/NV
         BDggJ65GMdNvd+BEG1zSF9MIEWxeYurORogCRFjpwOaOaWKBIRCCGRSMCTrHK8kaskQx
         S+l4FcnuVKtfdFvjn1eqEp9uOfF+2kFeux22cprAi6jtEV/rcuBLZMwZAl+5VG6JfFpl
         noPh6E3ztjODbZmmI+03JnYo52YmieYsLWwMaQfM5MiGw/+6JY/3kp6rpUSDMzGkSsEr
         CaRLPzJVjElPJdVrmXIFtFyvt1x0D6GkSeIfSvAykpX3lSe0eDkmux+AkKl5FD4WC8PK
         71Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=Np2o8KPS2ztKTn/RRgx0OmT92ImbyV11Hw/jIVQgjbc=;
        b=JFy56WZqYyARwOtoWI2R38voxX0rt7tIk/zcFW5KC09lBvvdG+K1lR7W9Ecto9Wfn/
         xvc1oSpqxWvFQSJZuVfORC0k7oGhlqr6P5c9abIndSn0dvuz0sR+4BfSMUivujcsBrOJ
         RgYcIqQU6dcJkJBswfRkomp0/V+o3WvVkjBMqSedNmGntGoKQb6IGUCJ5SBOtkHa61sB
         Y8aiChIh5CnC08m96BlpUOkbL11ebVxQGQIk07WnWY6ZVZHvwy0ilaalmReO69v497ES
         Kz/wUgueoGZjd0sm3DrPYjJAxmUR3yQcol5cXVsMLwB43eW9/s7+EEZAqAl2RADxTpT4
         UAXg==
X-Gm-Message-State: AOAM531sEhvhntvzgNvziekx0SZ5GapmifM+/KAbXJY5eeKZvs30SKmM
        0WozzT5PhCzsj8awkeEBcK5qCnaYhwM=
X-Google-Smtp-Source: ABdhPJwiiAQTynMrt+J4JSvpndzCrQWLYdQymcCeDEgTpQIE6lwConaggnVm2mwrPBAzYbnUz42KpQ==
X-Received: by 2002:a62:aa0a:0:b029:1ef:fe5:b172 with SMTP id e10-20020a62aa0a0000b02901ef0fe5b172mr1548213pff.9.1617776916653;
        Tue, 06 Apr 2021 23:28:36 -0700 (PDT)
Received: from localhost.localdomain ([132.145.85.142])
        by smtp.gmail.com with ESMTPSA id h16sm19721045pfc.194.2021.04.06.23.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 23:28:36 -0700 (PDT)
Sender: Huacai Chen <chenhuacai@gmail.com>
From:   Huacai Chen <chenhuacai@kernel.org>
X-Google-Original-From: Huacai Chen <chenhuacai@loongson.cn>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     linux-mips@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>, stable@vger.kernel.org
Subject: [PATCH V2] MIPS: Fix longstanding errors in div64.h
Date:   Wed,  7 Apr 2021 14:29:16 +0800
Message-Id: <20210407062916.3465459-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are three errors in div64.h caused by commit c21004cd5b4cb7d479514
("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0."):

1, Only 32bit kernel need __div64_32(), but the above commit makes it
depend on 64bit kernel by mistake.

2, asm-generic/div64.h should be included after __div64_32() definition.

3, __n should be initialized as *n before use (and "*__n >> 32" should
be "__n >> 32") in __div64_32() definition.

Fixes: c21004cd5b4cb7d479514 ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0.")
Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
 arch/mips/include/asm/div64.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/mips/include/asm/div64.h b/arch/mips/include/asm/div64.h
index dc5ea5736440..3be2318f8e0e 100644
--- a/arch/mips/include/asm/div64.h
+++ b/arch/mips/include/asm/div64.h
@@ -9,9 +9,7 @@
 #ifndef __ASM_DIV64_H
 #define __ASM_DIV64_H
 
-#include <asm-generic/div64.h>
-
-#if BITS_PER_LONG == 64
+#if BITS_PER_LONG == 32
 
 #include <linux/types.h>
 
@@ -24,9 +22,9 @@
 	unsigned long __cf, __tmp, __tmp2, __i;				\
 	unsigned long __quot32, __mod32;				\
 	unsigned long __high, __low;					\
-	unsigned long long __n;						\
+	unsigned long long __n = *n;					\
 									\
-	__high = *__n >> 32;						\
+	__high = __n >> 32;						\
 	__low = __n;							\
 	__asm__(							\
 	"	.set	push					\n"	\
@@ -65,4 +63,6 @@
 
 #endif /* BITS_PER_LONG == 64 */
 
+#include <asm-generic/div64.h>
+
 #endif /* __ASM_DIV64_H */
-- 
2.27.0

