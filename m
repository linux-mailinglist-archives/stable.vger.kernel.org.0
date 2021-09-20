Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF79541218C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350654AbhITSG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357043AbhITSCo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48FA761A02;
        Mon, 20 Sep 2021 17:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158197;
        bh=J4+o5I29TTRq+DEyELh/iNGt0uvSq8mNP+F5fEBxX7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xre9Tjperg8+MWvHVG8DeLFeTj3peJW0vSQ4VtCPO3ambXYTbu87aV6n4r48ZyXg9
         k/Ry5q0ljo26oGhDp/77FqvVPjZBwtcoLYhd4xkEzmcPLnJ7Oeg8kFR3NVY6vd9+2h
         1CgqMNca1ijf2QX8NLoyx00aCp4/Av1IcYLstna4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 044/260] powerpc/stacktrace: Include linux/delay.h
Date:   Mon, 20 Sep 2021 18:41:02 +0200
Message-Id: <20210920163932.611325193@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
index b13c6213b0d9..890f95151fb4 100644
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



