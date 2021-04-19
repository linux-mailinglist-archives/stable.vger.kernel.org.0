Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7AE9364314
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240016AbhDSNOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:14:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239748AbhDSNMY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:12:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F1816135F;
        Mon, 19 Apr 2021 13:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837903;
        bh=leqG8GbQuhMa9j6H4hSSbKVNAD3Hc3zXvwkMRXRfJXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npBgBN9aYGiz7Etp4/hUuuuar7QW/xuRpuyZzK7NV0dyXQ1llgeYm2hLP2SjGdh0d
         +seR5kul0jjacYSaGtswU7ND3S6L0IohXRe+rti95SP2PwHiEBBx/doYwVqUQTFXhX
         2bDtdbb0JQ0VmyXCaYqcZ4vvV1vYrM5yzGsTIPsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 094/122] ia64: tools: remove inclusion of ia64-specific version of errno.h header
Date:   Mon, 19 Apr 2021 15:06:14 +0200
Message-Id: <20210419130533.344539878@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Paul Adrian Glaubitz <glaubitz () physik ! fu-berlin ! de>

commit 17786fea414393813b56e33a1a01b2dfa03c0915 upstream.

There is no longer an ia64-specific version of the errno.h header below
arch/ia64/include/uapi/asm/, so trying to build tools/bpf fails with:

    CC       /usr/src/linux/tools/bpf/bpftool/btf_dumper.o
  In file included from /usr/src/linux/tools/include/linux/err.h:8,
                   from btf_dumper.c:11:
  /usr/src/linux/tools/include/uapi/asm/errno.h:13:10: fatal error: ../../../arch/ia64/include/uapi/asm/errno.h: No such file or directory
     13 | #include "../../../arch/ia64/include/uapi/asm/errno.h"
        |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  compilation terminated.

Thus, just remove the inclusion of the ia64-specific errno.h so that the
build will use the generic errno.h header on this target which was used
there anyway as the ia64-specific errno.h was just a wrapper for the
generic header.

Fixes: c25f867ddd00 ("ia64: remove unneeded uapi asm-generic wrappers")
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/uapi/asm/errno.h |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/include/uapi/asm/errno.h
+++ b/tools/include/uapi/asm/errno.h
@@ -9,8 +9,6 @@
 #include "../../../arch/alpha/include/uapi/asm/errno.h"
 #elif defined(__mips__)
 #include "../../../arch/mips/include/uapi/asm/errno.h"
-#elif defined(__ia64__)
-#include "../../../arch/ia64/include/uapi/asm/errno.h"
 #elif defined(__xtensa__)
 #include "../../../arch/xtensa/include/uapi/asm/errno.h"
 #else


