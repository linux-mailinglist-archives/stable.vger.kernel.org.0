Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6128F40E25B
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242711AbhIPQhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243014AbhIPQeE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:34:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 581B0613DB;
        Thu, 16 Sep 2021 16:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809246;
        bh=za6ile4qkmsiyzDQMiZW3J2ImeUqrt4Ky4TfIov3Emk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+zlI0pr0xNfZRubV3PjxkzSUr47uQNYHt/0+9kHyGOUN5lYFkZSdeWLpyhhsjbJT
         U4mDTZs+10rWTfyWcBRatoIEmS64izu/Tg8Iva25oD5lIb3NbIAZrixfSxJ4bDeKXf
         cpqMUYASCnD/PaIxM7zasMpPFJAYXThIumNlcUvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 085/380] powerpc/stacktrace: Include linux/delay.h
Date:   Thu, 16 Sep 2021 17:57:22 +0200
Message-Id: <20210916155806.934030486@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Suchanek <msuchanek@suse.de>

[ Upstream commit a6cae77f1bc89368a4e2822afcddc45c3062d499 ]

commit 7c6986ade69e ("powerpc/stacktrace: Fix spurious "stale" traces in raise_backtrace_ipi()")
introduces udelay() call without including the linux/delay.h header.
This may happen to work on master but the header that declares the
functionshould be included nonetheless.

Fixes: 7c6986ade69e ("powerpc/stacktrace: Fix spurious "stale" traces in raise_backtrace_ipi()")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210729180103.15578-1-msuchanek@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/stacktrace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/stacktrace.c b/arch/powerpc/kernel/stacktrace.c
index ea0d9c36e177..b64b734a5030 100644
--- a/arch/powerpc/kernel/stacktrace.c
+++ b/arch/powerpc/kernel/stacktrace.c
@@ -8,6 +8,7 @@
  * Copyright 2018 Nick Piggin, Michael Ellerman, IBM Corp.
  */
 
+#include <linux/delay.h>
 #include <linux/export.h>
 #include <linux/kallsyms.h>
 #include <linux/module.h>
-- 
2.30.2



