Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35156480078
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239752AbhL0Pqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:46:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41782 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239601AbhL0Pmh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:42:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEE8D610A2;
        Mon, 27 Dec 2021 15:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7EDEC36AE7;
        Mon, 27 Dec 2021 15:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619756;
        bh=t4MreKcNAOEP2Q9SeldSKUdLIm2bt8LnxmFTSNZxbro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QXpRYDqiftLZasjkZivAFyiVJfwMqyFeYffhOFwojuOBg3gpYj5WWiyBnoZuQaQb7
         VX43HC80/7bxESX0A6OJ3OmR2jTN+19TaptXjLS61dsV1/23wVZYaQMyST1ncbjbfH
         LnyUev2Zfa+9+xmAFz/OR/iKkcXaL/yvoE82VCWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ismael Luceno <ismael@iodev.co.uk>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/128] uapi: Fix undefined __always_inline on non-glibc systems
Date:   Mon, 27 Dec 2021 16:30:34 +0100
Message-Id: <20211227151333.477211158@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ismael Luceno <ismael@iodev.co.uk>

[ Upstream commit cb8747b7d2a9e3d687a19a007575071d4b71cd05 ]

This macro is defined by glibc itself, which makes the issue go unnoticed on
those systems.  On non-glibc systems it causes build failures on several
utilities and libraries, like bpftool and objtool.

Fixes: 1d509f2a6ebc ("x86/insn: Support big endian cross-compiles")
Fixes: 2d7ce0e8a704 ("tools/virtio: more stubs")
Fixes: 3fb321fde22d ("selftests/net: ipv6 flowlabel")
Fixes: 50b3ed57dee9 ("selftests/bpf: test bpf flow dissection")
Fixes: 9cacf81f8161 ("bpf: Remove extra lock_sock for TCP_ZEROCOPY_RECEIVE")
Fixes: a4b2061242ec ("tools include uapi: Grab a copy of linux/in.h")
Fixes: b12d6ec09730 ("bpf: btf: add btf print functionality")
Fixes: c0dd967818a2 ("tools, include: Grab a copy of linux/erspan.h")
Fixes: c4b6014e8bb0 ("tools: Add copy of perf_event.h to tools/include/linux/")

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20211115134647.1921-1-ismael@iodev.co.uk
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/byteorder/big_endian.h    | 1 +
 include/uapi/linux/byteorder/little_endian.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/uapi/linux/byteorder/big_endian.h b/include/uapi/linux/byteorder/big_endian.h
index 2199adc6a6c20..80aa5c41a7636 100644
--- a/include/uapi/linux/byteorder/big_endian.h
+++ b/include/uapi/linux/byteorder/big_endian.h
@@ -9,6 +9,7 @@
 #define __BIG_ENDIAN_BITFIELD
 #endif
 
+#include <linux/stddef.h>
 #include <linux/types.h>
 #include <linux/swab.h>
 
diff --git a/include/uapi/linux/byteorder/little_endian.h b/include/uapi/linux/byteorder/little_endian.h
index 601c904fd5cd9..cd98982e7523e 100644
--- a/include/uapi/linux/byteorder/little_endian.h
+++ b/include/uapi/linux/byteorder/little_endian.h
@@ -9,6 +9,7 @@
 #define __LITTLE_ENDIAN_BITFIELD
 #endif
 
+#include <linux/stddef.h>
 #include <linux/types.h>
 #include <linux/swab.h>
 
-- 
2.34.1



