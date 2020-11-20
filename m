Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A47E2BA7E3
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgKTLDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:03:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:50406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgKTLDS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:03:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07873206E3;
        Fri, 20 Nov 2020 11:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870197;
        bh=0EsFzMPlE7QYZEXC0g7nJiQj2RAXnKHftBXQd3UrBvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQ/EaZvRPoEmVBn2y4cLuiQOTpeFZJGN0xpenxMx+yAh7ScUpBaumCLkZOe+N97jv
         xsUHzvvPKj0oOtBZOElD/cptEqNFHZCAcSdEQf8H3H+NDN+POB2avs+TmJJhZx4Fgr
         KT1IEYJtnWSLtjvjFa0RKdFLoPGKNgyGxPOx29vA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dja@axtens.net
Subject: [PATCH 4.4 01/15] powerpc/64s: Define MASKABLE_RELON_EXCEPTION_PSERIES_OOL
Date:   Fri, 20 Nov 2020 12:02:59 +0100
Message-Id: <20201120104539.610547074@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104539.534424264@linuxfoundation.org>
References: <20201120104539.534424264@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Axtens <dja@axtens.net>

Add a definition provided by mpe and fixed up for 4.4. It doesn't exist
for 4.4 and we'd quite like to use it.

Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/exception-64s.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -597,6 +597,12 @@ label##_relon_hv:							\
 	EXCEPTION_PROLOG_1(PACA_EXGEN, SOFTEN_NOTEST_HV, vec);		\
 	EXCEPTION_PROLOG_PSERIES_1(label##_common, EXC_HV);
 
+#define MASKABLE_RELON_EXCEPTION_PSERIES_OOL(vec, label)               \
+       .globl label##_relon_pSeries;                                   \
+label##_relon_pSeries:                                                 \
+       EXCEPTION_PROLOG_1(PACA_EXGEN, SOFTEN_NOTEST_PR, vec);          \
+       EXCEPTION_PROLOG_PSERIES_1(label##_common, EXC_STD)
+
 /*
  * Our exception common code can be passed various "additions"
  * to specify the behaviour of interrupts, whether to kick the


