Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7E168DA16
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731175AbfHNRPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:15:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728775AbfHNRPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:15:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8124D2063F;
        Wed, 14 Aug 2019 17:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802903;
        bh=xgE+15QcMdwoAnFrAPREzcsQF9PufS+fugmS0e/+Dtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iNrSlFC5F29NUg8XXNo8fWfMj8BN8o/cbkGCCBAgncEwViGfSaSXHobAlI9Txvg/f
         JYlIniiXPSSeiVTta8vyh6Sniicbs+lyiBPSyPHhc3KdK31tlCVsssoYOHMwtwcufT
         Fmu+6gEpGFIgHk+/joaBG4oOrmQq/VR+5Pj85bnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 44/69] ARM: davinci: fix sleep.S build error on ARMv4
Date:   Wed, 14 Aug 2019 19:01:42 +0200
Message-Id: <20190814165748.481664366@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



