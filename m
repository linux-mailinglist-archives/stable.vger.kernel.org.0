Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B69001718E8
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgB0NkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:40:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729237AbgB0NkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:40:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C62202469F;
        Thu, 27 Feb 2020 13:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582810824;
        bh=Fdvfi4paN8M++frGGh3vppvLXjGVFgIWMTLg4XpW7nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UGw24q+8VDxikOdWepWwKAm2za6HH/Zyla4QYalixGG4yIW0u9Hl6IjpfDaZOnK8V
         rJtPjf/cCqHWNecrtV9i1b/+FdI/5SdpixTIwAbwlmbM/xAj5KfZkA/XL4zGeOC6FT
         ZR4KMREUEjQoh8i/ACldSbDwxsFBjw/OkzFK4fMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.4 012/113] s390/time: Fix clk type in get_tod_clock
Date:   Thu, 27 Feb 2020 14:35:28 +0100
Message-Id: <20200227132213.705359607@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
References: <20200227132211.791484803@linuxfoundation.org>
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
@@ -82,7 +82,7 @@ static inline void get_tod_clock_ext(cha
 
 static inline unsigned long long get_tod_clock(void)
 {
-	unsigned char clk[STORE_CLOCK_EXT_SIZE];
+	char clk[STORE_CLOCK_EXT_SIZE];
 
 	get_tod_clock_ext(clk);
 	return *((unsigned long long *)&clk[1]);


