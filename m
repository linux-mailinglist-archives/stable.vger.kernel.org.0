Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F203C172100
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbgB0Npa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:45:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:41366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729995AbgB0Np2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:45:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0ECE222C2;
        Thu, 27 Feb 2020 13:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811128;
        bh=3nMLF0GMDZJEzkEI901OXR0IIqz5LdAt9sSZZ8ML21I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sjdv6cF/ouXfAkTh0H+0d/875aUH+8GyUQ6rEuybbk/25bCt2YJjhLIESz/PaC9DO
         8PugZ5DyHBwVCxsUuph1kFDDNAwiXgVKRN/A8v4RHRBPuLxsxJk5CO/shiHe7Wmau6
         x3oL6klLWlavGxvwAUI6+69LVpm41Cg5qILLd66Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.9 014/165] s390/time: Fix clk type in get_tod_clock
Date:   Thu, 27 Feb 2020 14:34:48 +0100
Message-Id: <20200227132233.107298611@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit 0f8a206df7c920150d2aa45574fba0ab7ff6be4f upstream.

Clang warns:

In file included from ../arch/s390/boot/startup.c:3:
In file included from ../include/linux/elf.h:5:
In file included from ../arch/s390/include/asm/elf.h:132:
In file included from ../include/linux/compat.h:10:
In file included from ../include/linux/time.h:74:
In file included from ../include/linux/time32.h:13:
In file included from ../include/linux/timex.h:65:
../arch/s390/include/asm/timex.h:160:20: warning: passing 'unsigned char
[16]' to parameter of type 'char *' converts between pointers to integer
types with different sign [-Wpointer-sign]
        get_tod_clock_ext(clk);
                          ^~~
../arch/s390/include/asm/timex.h:149:44: note: passing argument to
parameter 'clk' here
static inline void get_tod_clock_ext(char *clk)
                                           ^

Change clk's type to just be char so that it matches what happens in
get_tod_clock_ext.

Fixes: 57b28f66316d ("[S390] s390_hypfs: Add new attributes")
Link: https://github.com/ClangBuiltLinux/linux/issues/861
Link: http://lkml.kernel.org/r/20200208140858.47970-1-natechancellor@gmail.com
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/timex.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -146,7 +146,7 @@ static inline void get_tod_clock_ext(cha
 
 static inline unsigned long long get_tod_clock(void)
 {
-	unsigned char clk[STORE_CLOCK_EXT_SIZE];
+	char clk[STORE_CLOCK_EXT_SIZE];
 
 	get_tod_clock_ext(clk);
 	return *((unsigned long long *)&clk[1]);


