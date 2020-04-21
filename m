Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEAD91B1B28
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 03:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgDUBOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 21:14:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgDUBOV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 21:14:21 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A8142070B;
        Tue, 21 Apr 2020 01:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587431661;
        bh=POEvJdt69gGHvAgZYMOBFNyiIXP6vxMXEMUcWRPFzFY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LpftIEp+Tyvxyzzzs0DUvlX2i5LW9MKTICmE6CaFccckP/BjS30QmSGpdJh9l3aBw
         cAbgHMNsmdN6GEfAxkgTV/vc3mGlrtOFxQ5go86h5DCHxXh+kMxJ0E/LItA2rbzuNp
         QV30MFGmvLRBVMEibvfk/EsMZ2ExXmT8y9VuATxA=
Date:   Mon, 20 Apr 2020 18:14:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        matthew.ruffell@canonical.com, mm-commits@vger.kernel.org,
        nhorman@tuxdriver.com, pabs3@bonedaddy.net, stable@vger.kernel.org,
        sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 14/15] coredump: fix null pointer dereference on
 coredump
Message-ID: <20200421011420.GnVj8rZfk%akpm@linux-foundation.org>
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: coredump: fix null pointer dereference on coredump

If the core_pattern is set to "|" and any process segfaults then we get
a null pointer derefernce while trying to coredump. The call stack shows:
[  108.212680] RIP: 0010:do_coredump+0x628/0x11c0

When the core_pattern has only "|" there is no use of trying the coredump
and we can check that while formating the corename and exit with an error.

After this change I get:
[   48.453756] format_corename failed
[   48.453758] Aborting core

Link: http://lkml.kernel.org/r/20200416194612.21418-1-sudipm.mukherjee@gmail.com
Fixes: 315c69261dd3 ("coredump: split pipe command whitespace before expanding template")
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Reported-by: Matthew Ruffell <matthew.ruffell@canonical.com>
Cc: Paul Wise <pabs3@bonedaddy.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/coredump.c~coredump-fix-null-pointer-dereference-on-coredump
+++ a/fs/coredump.c
@@ -211,6 +211,8 @@ static int format_corename(struct core_n
 			return -ENOMEM;
 		(*argv)[(*argc)++] = 0;
 		++pat_ptr;
+		if (!(*pat_ptr))
+			return -ENOMEM;
 	}
 
 	/* Repeat as long as we have more pattern to process and more output
_
