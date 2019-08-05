Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5B9C81C09
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbfHENTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:19:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728865AbfHENTh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:19:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFF1F2147A;
        Mon,  5 Aug 2019 13:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011176;
        bh=kET/XI/yGE7hnw4dQZUVxgjobkG7KvceWR0d2hddSUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qKBwO2C53RjFII28Zm3kPJUxw4eUzj+wwTzlCLxFJ8SdE15u8Gyr8uAEjZvCicmMu
         i0POSwb98YaGC5rFUilhSFBqaB+CeoVX+3qWJR/8aplhhXM30NvMEBzKEq301avBJD
         K7SZrHMksMBXnoS6zbTaBtnJIH+y4P+1FnocmB98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 72/74] gcc-9: properly declare the {pv,hv}clock_page storage
Date:   Mon,  5 Aug 2019 15:03:25 +0200
Message-Id: <20190805124941.618238077@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 459e3a21535ae3c7a9a123650e54f5c882b8fcbf upstream.

The pvlock_page and hvclock_page variables are (as the name implies)
addresses to pages, created by the linker script.

But we declared them as just "extern u8" variables, which _works_, but
now that gcc does some more bounds checking, it causes warnings like

    warning: array subscript 1 is outside array bounds of ‘u8[1]’

when we then access more than one byte from those variables.

Fix this by simply making the declaration of the variables match
reality, which makes the compiler happy too.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/vdso/vclock_gettime.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/entry/vdso/vclock_gettime.c
+++ b/arch/x86/entry/vdso/vclock_gettime.c
@@ -29,12 +29,12 @@ extern int __vdso_gettimeofday(struct ti
 extern time_t __vdso_time(time_t *t);
 
 #ifdef CONFIG_PARAVIRT_CLOCK
-extern u8 pvclock_page
+extern u8 pvclock_page[PAGE_SIZE]
 	__attribute__((visibility("hidden")));
 #endif
 
 #ifdef CONFIG_HYPERV_TSCPAGE
-extern u8 hvclock_page
+extern u8 hvclock_page[PAGE_SIZE]
 	__attribute__((visibility("hidden")));
 #endif
 


