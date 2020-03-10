Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A713F17FDE9
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgCJMuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728549AbgCJMuI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:50:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73E222468E;
        Tue, 10 Mar 2020 12:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844607;
        bh=zC3Y1C8HwIOEPRo15lvjJ/967zThZkg6I7D9cZHzu88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sh/BYcvi5f+LWoMzXm3z1lAkkghh6YUmZ9oJEykInhEc5PxJkhYr7gkA7vTO9nhD9
         eZv6J+EQ8oekxvRDwX52FsXtQJfPzUecm55gfd2zvj1wxDuEASBEWFqEn7kZSNPFVj
         g4uykD5OiiHVkJ0awVD07/9RfjMuWw4IOdH6W/tE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/168] csky: Fixup ftrace modify panic
Date:   Tue, 10 Mar 2020 13:38:19 +0100
Message-Id: <20200310123640.710173049@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



