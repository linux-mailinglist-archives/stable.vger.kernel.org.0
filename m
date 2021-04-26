Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41BB236AD30
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbhDZHc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:32:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232516AbhDZHct (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:32:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D400161077;
        Mon, 26 Apr 2021 07:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422328;
        bh=zDxJXd2qXq1dSCjtYIk8HjNfAOGtRtdfoj7hOk/H7d8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CwUYrLvluErEJBEO6uDrm5zSs/GqaaMnh248fp8gwOwhYiN7T7EWQX2f3UVHJ5Nz6
         Kn9Xzwaxm5Mzc8NT+wNfGuWNHuHOQkvi27RkRgTnJ0M6kEkkiUbmQ8Rw/dXnLGvCUN
         dC2+BR2q1hDUy2WIDjJNSepiTJWvJDAA+LQphEZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 29/32] ia64: tools: remove duplicate definition of ia64_mf() on ia64
Date:   Mon, 26 Apr 2021 09:29:27 +0200
Message-Id: <20210426072817.542932085@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072816.574319312@linuxfoundation.org>
References: <20210426072816.574319312@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>

[ Upstream commit f4bf09dc3aaa4b07cd15630f2023f68cb2668809 ]

The ia64_mf() macro defined in tools/arch/ia64/include/asm/barrier.h is
already defined in <asm/gcc_intrin.h> on ia64 which causes libbpf
failing to build:

    CC       /usr/src/linux/tools/bpf/bpftool//libbpf/staticobjs/libbpf.o
  In file included from /usr/src/linux/tools/include/asm/barrier.h:24,
                   from /usr/src/linux/tools/include/linux/ring_buffer.h:4,
                   from libbpf.c:37:
  /usr/src/linux/tools/include/asm/../../arch/ia64/include/asm/barrier.h:43: error: "ia64_mf" redefined [-Werror]
     43 | #define ia64_mf()       asm volatile ("mf" ::: "memory")
        |
  In file included from /usr/include/ia64-linux-gnu/asm/intrinsics.h:20,
                   from /usr/include/ia64-linux-gnu/asm/swab.h:11,
                   from /usr/include/linux/swab.h:8,
                   from /usr/include/linux/byteorder/little_endian.h:13,
                   from /usr/include/ia64-linux-gnu/asm/byteorder.h:5,
                   from /usr/src/linux/tools/include/uapi/linux/perf_event.h:20,
                   from libbpf.c:36:
  /usr/include/ia64-linux-gnu/asm/gcc_intrin.h:382: note: this is the location of the previous definition
    382 | #define ia64_mf() __asm__ volatile ("mf" ::: "memory")
        |
  cc1: all warnings being treated as errors

Thus, remove the definition from tools/arch/ia64/include/asm/barrier.h.

Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/arch/ia64/include/asm/barrier.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/tools/arch/ia64/include/asm/barrier.h
+++ b/tools/arch/ia64/include/asm/barrier.h
@@ -38,9 +38,6 @@
  * sequential memory pages only.
  */
 
-/* XXX From arch/ia64/include/uapi/asm/gcc_intrin.h */
-#define ia64_mf()       asm volatile ("mf" ::: "memory")
-
 #define mb()		ia64_mf()
 #define rmb()		mb()
 #define wmb()		mb()


