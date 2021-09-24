Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61841417254
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343783AbhIXMrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:47:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343884AbhIXMqu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:46:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D403C61107;
        Fri, 24 Sep 2021 12:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487517;
        bh=K/MHxVjz3gOqMQyd2AGiJFitdA8BkTxuQse7yV5UCwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yycqwn3l79t6b47pbAMl6tQzIPV43+4oKvSncYmO1nINX0rI/ieG1G9Yh9myUN6D2
         EQZutmTgswZ/n9BhpwbHTG/vtGX9OxyAoJdhdFnWSMPmuTD3UFQR0KNqpDqbcvmdPX
         f8roxOwVy7FKP6RcCR4xQA2L6IqN/FsSC2kwXPcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
        Keno Fischer <keno@juliacomputing.com>,
        Andrey Vagin <avagin@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 10/26] prctl: allow to setup brk for et_dyn executables
Date:   Fri, 24 Sep 2021 14:43:58 +0200
Message-Id: <20210924124328.686047911@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124328.336953942@linuxfoundation.org>
References: <20210924124328.336953942@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

commit e1fbbd073137a9d63279f6bf363151a938347640 upstream.

Keno Fischer reported that when a binray loaded via ld-linux-x the
prctl(PR_SET_MM_MAP) doesn't allow to setup brk value because it lays
before mm:end_data.

For example a test program shows

 | # ~/t
 |
 | start_code      401000
 | end_code        401a15
 | start_stack     7ffce4577dd0
 | start_data	   403e10
 | end_data        40408c
 | start_brk	   b5b000
 | sbrk(0)         b5b000

and when executed via ld-linux

 | # /lib64/ld-linux-x86-64.so.2 ~/t
 |
 | start_code      7fc25b0a4000
 | end_code        7fc25b0c4524
 | start_stack     7fffcc6b2400
 | start_data	   7fc25b0ce4c0
 | end_data        7fc25b0cff98
 | start_brk	   55555710c000
 | sbrk(0)         55555710c000

This of course prevent criu from restoring such programs.  Looking into
how kernel operates with brk/start_brk inside brk() syscall I don't see
any problem if we allow to setup brk/start_brk without checking for
end_data.  Even if someone pass some weird address here on a purpose then
the worst possible result will be an unexpected unmapping of existing vma
(own vma, since prctl works with the callers memory) but test for
RLIMIT_DATA is still valid and a user won't be able to gain more memory in
case of expanding VMAs via new values shipped with prctl call.

Link: https://lkml.kernel.org/r/20210121221207.GB2174@grain
Fixes: bbdc6076d2e5 ("binfmt_elf: move brk out of mmap when doing direct loader exec")
Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reported-by: Keno Fischer <keno@juliacomputing.com>
Acked-by: Andrey Vagin <avagin@gmail.com>
Tested-by: Andrey Vagin <avagin@gmail.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sys.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1775,13 +1775,6 @@ static int validate_prctl_map(struct prc
 	error = -EINVAL;
 
 	/*
-	 * @brk should be after @end_data in traditional maps.
-	 */
-	if (prctl_map->start_brk <= prctl_map->end_data ||
-	    prctl_map->brk <= prctl_map->end_data)
-		goto out;
-
-	/*
 	 * Neither we should allow to override limits if they set.
 	 */
 	if (check_data_rlimit(rlimit(RLIMIT_DATA), prctl_map->brk,


