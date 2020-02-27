Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79309171E04
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388833AbgB0OMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:12:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388647AbgB0OMW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:12:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 610D720801;
        Thu, 27 Feb 2020 14:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812741;
        bh=wUCnyP0bx4+5EbaDjMSE4OQYAilE4U7QOmG4gmb9nWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=daTq1P/FgzCcDdG6hNozHsWIsHRt7dldWXtlMDo1BKvWTGrl86WPCL8wktAGVrIhn
         K5iqVjYM7w6au4OIhYuoazYcKS8JhySfRXOeG/v8lEZE93rVGa497FmiUXjIAJKV5t
         Phg12y2duL3bn35U6DiAZTiejM8/WYNEKj5KF+V4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.4 133/135] s390/kaslr: Fix casts in get_random
Date:   Thu, 27 Feb 2020 14:37:53 +0100
Message-Id: <20200227132249.036936083@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit 788d671517b5c81efbed9310ccbadb8cca86a08e upstream.

Clang warns:

../arch/s390/boot/kaslr.c:78:25: warning: passing 'char *' to parameter
of type 'const u8 *' (aka 'const unsigned char *') converts between
pointers to integer
types with different sign [-Wpointer-sign]
                                  (char *) entropy, (char *) entropy,
                                                    ^~~~~~~~~~~~~~~~
../arch/s390/include/asm/cpacf.h:280:28: note: passing argument to
parameter 'src' here
                            u8 *dest, const u8 *src, long src_len)
                                                ^
2 warnings generated.

Fix the cast to match what else is done in this function.

Fixes: b2d24b97b2a9 ("s390/kernel: add support for kernel address space layout randomization (KASLR)")
Link: https://github.com/ClangBuiltLinux/linux/issues/862
Link: https://lkml.kernel.org/r/20200208141052.48476-1-natechancellor@gmail.com
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/boot/kaslr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/boot/kaslr.c
+++ b/arch/s390/boot/kaslr.c
@@ -75,7 +75,7 @@ static unsigned long get_random(unsigned
 		*(unsigned long *) prng.parm_block ^= seed;
 		for (i = 0; i < 16; i++) {
 			cpacf_kmc(CPACF_KMC_PRNG, prng.parm_block,
-				  (char *) entropy, (char *) entropy,
+				  (u8 *) entropy, (u8 *) entropy,
 				  sizeof(entropy));
 			memcpy(prng.parm_block, entropy, sizeof(entropy));
 		}


