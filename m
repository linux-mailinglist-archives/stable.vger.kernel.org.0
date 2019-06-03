Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8765632C88
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbfFCJSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728141AbfFCJK2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:10:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D2EB27E21;
        Mon,  3 Jun 2019 09:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553028;
        bh=BDYnkPxTQQUimLxUM35ITG5CODWn8S31IuMErCxchns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ynd1KrS3020/YADfHCiwh9QNmeCu/HoZqA+D4Msa+30faHDC5bdE2fypb8VIM5R0
         iCJKRqD6xNg6KAMOKInWP1GhCcvhJeJ4hP1ITukJ7MuZxHMGoQ4la49iplBGcFhgPT
         dFHrj8Iy6g0LYhmJvRAmsiDMyEOs7Id76/25pzhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 4.19 27/32] include/linux/compiler*.h: define asm_volatile_goto
Date:   Mon,  3 Jun 2019 11:08:21 +0200
Message-Id: <20190603090315.366227169@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090308.472021390@linuxfoundation.org>
References: <20190603090308.472021390@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ndesaulniers@google.com <ndesaulniers@google.com>

commit 8bd66d147c88bd441178c7b4c774ae5a185f19b8 upstream.

asm_volatile_goto should also be defined for other compilers that support
asm goto.

Fixes commit 815f0ddb346c ("include/linux/compiler*.h: make compiler-*.h
mutually exclusive").

Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/compiler_types.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -151,6 +151,10 @@ struct ftrace_likely_data {
 #define __assume_aligned(a, ...)
 #endif
 
+#ifndef asm_volatile_goto
+#define asm_volatile_goto(x...) asm goto(x)
+#endif
+
 /* Are two types/vars the same type (ignoring qualifiers)? */
 #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
 


