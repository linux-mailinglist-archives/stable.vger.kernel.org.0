Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064A7492A3F
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346682AbiARQIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:08:37 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:40592 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346518AbiARQIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:08:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7538FCE1A32;
        Tue, 18 Jan 2022 16:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34005C00446;
        Tue, 18 Jan 2022 16:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522092;
        bh=/U1aim2WxlLlQlJMDj2E0NDyZcfwgDtItqvGFKtbJVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GVfI1XaNTgON6doQh3O9Xt4FDQejJmWfQF4WmIctfUFh8qzIJTE6HKq6CZGcTJWjY
         JRvrrTaufWAfvSad/Bv9ko/rH0X9Ii4nZ0bIMdfsLuM8yi77KZO83cMEkQDbQ6HB12
         iBLRbMUl+6F7YVvOAn7Tk81D3a0JvSyJOw3l50PE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 22/23] powerpc/pseries: Get entry and uaccess flush required bits from H_GET_CPU_CHARACTERISTICS
Date:   Tue, 18 Jan 2022 17:06:02 +0100
Message-Id: <20220118160451.981719590@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160451.233828401@linuxfoundation.org>
References: <20220118160451.233828401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit 65c7d070850e109a8a75a431f5a7f6eb4c007b77 upstream.

This allows the hypervisor / firmware to describe these workarounds to
the guest.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210503130243.891868-2-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/hvcall.h      |    2 ++
 arch/powerpc/platforms/pseries/setup.c |    6 ++++++
 2 files changed, 8 insertions(+)

--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -382,6 +382,8 @@
 #define H_CPU_BEHAV_BNDS_CHK_SPEC_BAR	(1ull << 61) // IBM bit 2
 #define H_CPU_BEHAV_FLUSH_COUNT_CACHE	(1ull << 58) // IBM bit 5
 #define H_CPU_BEHAV_FLUSH_LINK_STACK	(1ull << 57) // IBM bit 6
+#define H_CPU_BEHAV_NO_L1D_FLUSH_ENTRY	(1ull << 56) // IBM bit 7
+#define H_CPU_BEHAV_NO_L1D_FLUSH_UACCESS (1ull << 55) // IBM bit 8
 
 /* Flag values used in H_REGISTER_PROC_TBL hcall */
 #define PROC_TABLE_OP_MASK	0x18
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -538,6 +538,12 @@ static void init_cpu_char_feature_flags(
 	if (!(result->behaviour & H_CPU_BEHAV_L1D_FLUSH_PR))
 		security_ftr_clear(SEC_FTR_L1D_FLUSH_PR);
 
+	if (result->behaviour & H_CPU_BEHAV_NO_L1D_FLUSH_ENTRY)
+		security_ftr_clear(SEC_FTR_L1D_FLUSH_ENTRY);
+
+	if (result->behaviour & H_CPU_BEHAV_NO_L1D_FLUSH_UACCESS)
+		security_ftr_clear(SEC_FTR_L1D_FLUSH_UACCESS);
+
 	if (!(result->behaviour & H_CPU_BEHAV_BNDS_CHK_SPEC_BAR))
 		security_ftr_clear(SEC_FTR_BNDS_CHK_SPEC_BAR);
 }


