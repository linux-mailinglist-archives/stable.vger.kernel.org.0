Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D46F21FB4F
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731384AbgGNTAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731381AbgGNTAm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 15:00:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87FA6229CA;
        Tue, 14 Jul 2020 19:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753242;
        bh=6B5jIb/26lBpWGpB9rpxmceMVon6BoW1xkEz+8P/Sws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MKPGbDgGUFBdP4YECgR3y4qD/2vOUrW5gPf1TDGNm4GYXmQwDKHaWlY0/gkZN0Pvz
         psPFAfwTD7/Y5IgLDu0wZYSx+cSsazfgJzuyKDMlhLrcY+tTm8RUfM16rXWJHsTPx5
         pIsHLOFEU0zNWsesuOg36hwKOvupuuDP9JjdmYL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.7 155/166] s390/setup: init jump labels before command line parsing
Date:   Tue, 14 Jul 2020 20:45:20 +0200
Message-Id: <20200714184123.245732554@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

commit 95e61b1b5d6394b53d147c0fcbe2ae70fbe09446 upstream.

Command line parameters might set static keys. This is true for s390 at
least since commit 6471384af2a6 ("mm: security: introduce init_on_alloc=1
and init_on_free=1 boot options"). To avoid the following WARN:

static_key_enable_cpuslocked(): static key 'init_on_alloc+0x0/0x40' used
before call to jump_label_init()

call jump_label_init() just before parse_early_param().
jump_label_init() is safe to call multiple times (x86 does that), doesn't
do any memory allocations and hence should be safe to call that early.

Fixes: 6471384af2a6 ("mm: security: introduce init_on_alloc=1 and init_on_free=1 boot options")
Cc: <stable@vger.kernel.org> # 5.3: d6df52e9996d: s390/maccess: add no DAT mode to kernel_write
Cc: <stable@vger.kernel.org> # 5.3
Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/setup.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -1107,6 +1107,7 @@ void __init setup_arch(char **cmdline_p)
 	if (IS_ENABLED(CONFIG_EXPOLINE_AUTO))
 		nospec_auto_detect();
 
+	jump_label_init();
 	parse_early_param();
 #ifdef CONFIG_CRASH_DUMP
 	/* Deactivate elfcorehdr= kernel parameter */


