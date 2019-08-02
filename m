Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9D9A7FA4D
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405028AbfHBNcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389897AbfHBNYC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:24:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6508E2182B;
        Fri,  2 Aug 2019 13:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752241;
        bh=2NQfbXr/2flf+VnmDxlQVHz2x3lgkRrjGYvopR5En44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jI8axtLi83/CIXPe3FGhlsHlgJ+frewfL4EsNLoAMtTsQ0Cm19+1GDnQa4eXQ9+s8
         GW/1tvEQQn8EYpd7Ka/wY4w/RGmSlTKSLgqawwQZr3AwAX52i85xMvmT4pCt+RDL1i
         4vJJDp4zg0dP2qpWdcUI5qciT1B9zni1xuze/SPE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Sekhar Nori <nsekhar@ti.com>,
        Olof Johansson <olof@lixom.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 32/42] ARM: davinci: fix sleep.S build error on ARMv4
Date:   Fri,  2 Aug 2019 09:22:52 -0400
Message-Id: <20190802132302.13537-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802132302.13537-1-sashal@kernel.org>
References: <20190802132302.13537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d64b212ea960db4276a1d8372bd98cb861dfcbb0 ]

When building a multiplatform kernel that includes armv4 support,
the default target CPU does not support the blx instruction,
which leads to a build failure:

arch/arm/mach-davinci/sleep.S: Assembler messages:
arch/arm/mach-davinci/sleep.S:56: Error: selected processor does not support `blx ip' in ARM mode

Add a .arch statement in the sources to make this file build.

Link: https://lore.kernel.org/r/20190722145211.1154785-1-arnd@arndb.de
Acked-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-davinci/sleep.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-davinci/sleep.S b/arch/arm/mach-davinci/sleep.S
index cd350dee4df37..efcd400b2abb3 100644
--- a/arch/arm/mach-davinci/sleep.S
+++ b/arch/arm/mach-davinci/sleep.S
@@ -37,6 +37,7 @@
 #define DEEPSLEEP_SLEEPENABLE_BIT	BIT(31)
 
 	.text
+	.arch	armv5te
 /*
  * Move DaVinci into deep sleep state
  *
-- 
2.20.1

