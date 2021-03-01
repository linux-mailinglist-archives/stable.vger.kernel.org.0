Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C8F32903F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242778AbhCAUDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:03:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:59056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242535AbhCATx6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:53:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96BCC65366;
        Mon,  1 Mar 2021 17:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621249;
        bh=vmBJfQov9r+kOBWsOrfukGcLZjgVtA6JQZx4OWgTqvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YR6I3FEw7LU2fHM9LIeEZpZfTTm35rUrI+r8rZsfDZLSjpuPTJDNoIyGy1TNSwgWu
         M/dbLuebD9qOKSVvEMxvSSLOKt5SRth6v4rKBJ2VmHrumRg1CRVhLSSQ4/mLt4de01
         eSV4Wn3yIZXvILWhDZeI8+y4GY7iml5pB2L4fcXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Brian Starkey <brian.starkey@arm.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Laura Abbott <labbott@kernel.org>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sandeep Patil <sspatil@google.com>,
        Daniel Mentz <danielmentz@google.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kselftest@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 430/775] kselftests: dmabuf-heaps: Fix Makefiles inclusion of the kernels usr/include dir
Date:   Mon,  1 Mar 2021 17:09:58 +0100
Message-Id: <20210301161222.820380302@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

[ Upstream commit 64ba3d591c9d2be2a9c09e99b00732afe002ad0d ]

Copied in from somewhere else, the makefile was including
the kerne's usr/include dir, which caused the asm/ioctl.h file
to be used.

Unfortunately, that file has different values for _IOC_SIZEBITS
and _IOC_WRITE than include/uapi/asm-generic/ioctl.h which then
causes the _IOCW macros to give the wrong ioctl numbers,
specifically for DMA_BUF_IOCTL_SYNC.

This patch simply removes the extra include from the Makefile

Cc: Shuah Khan <shuah@kernel.org>
Cc: Brian Starkey <brian.starkey@arm.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Laura Abbott <labbott@kernel.org>
Cc: Hridya Valsaraju <hridya@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sandeep Patil <sspatil@google.com>
Cc: Daniel Mentz <danielmentz@google.com>
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kselftest@vger.kernel.org
Fixes: a8779927fd86c ("kselftests: Add dma-heap test")
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/dmabuf-heaps/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/dmabuf-heaps/Makefile b/tools/testing/selftests/dmabuf-heaps/Makefile
index 607c2acd20829..604b43ece15f5 100644
--- a/tools/testing/selftests/dmabuf-heaps/Makefile
+++ b/tools/testing/selftests/dmabuf-heaps/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -static -O3 -Wl,-no-as-needed -Wall -I../../../../usr/include
+CFLAGS += -static -O3 -Wl,-no-as-needed -Wall
 
 TEST_GEN_PROGS = dmabuf-heap
 
-- 
2.27.0



