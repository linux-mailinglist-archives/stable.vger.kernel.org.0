Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7437640DFA7
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbhIPQMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234513AbhIPQJl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:09:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DDA46124D;
        Thu, 16 Sep 2021 16:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808490;
        bh=Y8qnr/pXbBwIp7Qc9BW2t+XD/83l1eW/qiigdu7es3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J9gR9q6Mspr3npvSjO00DIqVxJOGFlpoN3VXWGBII+saG26oMh6MkOO4ZoIIZyceg
         l0g7PptHLESb6BsDvpltWC0naXOehlVpSNVizXYPzoApUYWomliRY9A8iOsxCW42n1
         U/ut1DXeKf8VRlXsKUdX3aW00Wii0AGtBGq1I/0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/306] powerpc/stacktrace: Include linux/delay.h
Date:   Thu, 16 Sep 2021 17:56:53 +0200
Message-Id: <20210916155756.376221967@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
index 2f926ea9b7b9..d4a66ce93f52 100644
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



