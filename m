Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7CCA3643E8
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241064AbhDSNXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:23:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241569AbhDSNU5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:20:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3A2D6127C;
        Mon, 19 Apr 2021 13:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838243;
        bh=leqG8GbQuhMa9j6H4hSSbKVNAD3Hc3zXvwkMRXRfJXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPIcbZ2vMB9yHUr/+A5GCSxmljBM7gxr7jfSk+wupUqR4GMx/Y2mF5UnqaCSmWAfJ
         JUA4uZIwEO2mQzpDiF9QFYgBTXlQj1b5MhHSivXVnUs9ZOxKEimWzIqwBmdCEsb5My
         0mL7cowyCDTaHvErKYqBHBGc6aHZYLAhVW/KPAuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 077/103] ia64: tools: remove inclusion of ia64-specific version of errno.h header
Date:   Mon, 19 Apr 2021 15:06:28 +0200
Message-Id: <20210419130530.452782764@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
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


