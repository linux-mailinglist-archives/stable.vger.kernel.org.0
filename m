Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF6C1F383
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbfEOLDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:03:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728248AbfEOLDo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:03:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E8F320881;
        Wed, 15 May 2019 11:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918224;
        bh=nQD2RP6IQV12KN5CGMPv+6Od8vaWpd0IIdQBglLgkkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EvunsdOCOY5vxwzNzpg86ZmXYdZxnQb4dzI17aSiOO68t+/Ay+65mh4pVOdPBBJT9
         /gQgCaEwwryliT5b1BIt3+MDeEpLF1V/E+O+xqWbbYoPP5jK1HOvY4s41Yi4OHUNPY
         HjK47AK8nb+sGtNzzJazsblYdDrcBvrP7/pqek7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 052/266] powerpc/64s: Add new security feature flags for count cache flush
Date:   Wed, 15 May 2019 12:52:39 +0200
Message-Id: <20190515090724.207045865@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit dc8c6cce9a26a51fc19961accb978217a3ba8c75 upstream.

Add security feature flags to indicate the need for software to flush
the count cache on context switch, and for the presence of a hardware
assisted count cache flush.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/security_features.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/powerpc/include/asm/security_features.h
+++ b/arch/powerpc/include/asm/security_features.h
@@ -59,6 +59,9 @@ static inline bool security_ftr_enabled(
 // Indirect branch prediction cache disabled
 #define SEC_FTR_COUNT_CACHE_DISABLED	0x0000000000000020ull
 
+// bcctr 2,0,0 triggers a hardware assisted count cache flush
+#define SEC_FTR_BCCTR_FLUSH_ASSIST	0x0000000000000800ull
+
 
 // Features indicating need for Spectre/Meltdown mitigations
 
@@ -74,6 +77,9 @@ static inline bool security_ftr_enabled(
 // Firmware configuration indicates user favours security over performance
 #define SEC_FTR_FAVOUR_SECURITY		0x0000000000000200ull
 
+// Software required to flush count cache on context switch
+#define SEC_FTR_FLUSH_COUNT_CACHE	0x0000000000000400ull
+
 
 // Features enabled by default
 #define SEC_FTR_DEFAULT \


