Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29EC3176C55
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 03:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgCCCsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 21:48:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728550AbgCCCsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 21:48:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3F0A24686;
        Tue,  3 Mar 2020 02:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203726;
        bh=zC3Y1C8HwIOEPRo15lvjJ/967zThZkg6I7D9cZHzu88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1zbFgYjs4W2jaCD1YD5kY3SWfNWstEpJ4sGREf81VfHbr2IvSppemdeGjfGT5BNqr
         Sa7s31fdI6Qkfn6J3kkxpLlt3oJah+f8ESi/fsZD/8A7mG0dP4V76V9tyFvn5MbHLr
         de5BEBQm7JFAWr8t8aCGznZJO8yA8+rK6eDBfogQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guo Ren <guoren@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>, linux-csky@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 55/58] csky: Fixup ftrace modify panic
Date:   Mon,  2 Mar 2020 21:47:37 -0500
Message-Id: <20200303024740.9511-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024740.9511-1-sashal@kernel.org>
References: <20200303024740.9511-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

[ Upstream commit 359ae00d12589c31cf103894d0f32588d523ca83 ]

During ftrace init, linux will replace all function prologues
(call_mcout) with nops, but it need flush_dcache and
invalidate_icache to make it work. So flush_cache functions
couldn't be nested called by ftrace framework.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/mm/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/csky/mm/Makefile b/arch/csky/mm/Makefile
index c94ef64810986..efb7ebab342b3 100644
--- a/arch/csky/mm/Makefile
+++ b/arch/csky/mm/Makefile
@@ -1,8 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
 ifeq ($(CONFIG_CPU_HAS_CACHEV2),y)
 obj-y +=			cachev2.o
+CFLAGS_REMOVE_cachev2.o = $(CC_FLAGS_FTRACE)
 else
 obj-y +=			cachev1.o
+CFLAGS_REMOVE_cachev1.o = $(CC_FLAGS_FTRACE)
 endif
 
 obj-y +=			dma-mapping.o
-- 
2.20.1

