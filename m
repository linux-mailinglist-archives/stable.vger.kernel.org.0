Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6D3D176CE4
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 03:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgCCCrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 21:47:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:42634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728085AbgCCCrd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 21:47:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3E9E24677;
        Tue,  3 Mar 2020 02:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203653;
        bh=zC3Y1C8HwIOEPRo15lvjJ/967zThZkg6I7D9cZHzu88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vmIng55i4nSiV0BRh3USz4+20dN6gteW5hZ0Ns2ddmTjaanCiZgDVUpMLRaP6qAFW
         I7JcrqsKMj/z7yy+Rf7ltPg0+KvJ1bQAPMv++dgLO5OkLEMw36if+MsSFcDAIhTdh5
         n5qiOZpj5ZyvsnWevIGDqs2nBoLqFX/s/XFRQnIw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guo Ren <guoren@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>, linux-csky@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 63/66] csky: Fixup ftrace modify panic
Date:   Mon,  2 Mar 2020 21:46:12 -0500
Message-Id: <20200303024615.8889-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024615.8889-1-sashal@kernel.org>
References: <20200303024615.8889-1-sashal@kernel.org>
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

