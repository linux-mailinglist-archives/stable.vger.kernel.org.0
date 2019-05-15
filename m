Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 248611ECFD
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbfEOLDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:03:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728286AbfEOLDz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:03:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EB3C21773;
        Wed, 15 May 2019 11:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918234;
        bh=oiUT5ZS6U27FNqqPrSA9h65ukXY1C9Ch3R1ybQhtPHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Res+wUftU4HILrSmfm2i0q8RyNi0MOdxMcKr4nQQLocjkLoYcrQ4f3WKoN5GoSENO
         0MXF7b31reZg7ocyl5tV32i9Ek602BkYj4P+LlyJs66QXAm94oaWHJRToHrpNZk60h
         EREck41KHlCCyTgHqGnJx1kLEmBBjjLAQ8FAN/WU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 055/266] powerpc/powernv: Query firmware for count cache flush settings
Date:   Wed, 15 May 2019 12:52:42 +0200
Message-Id: <20190515090724.304702616@linuxfoundation.org>
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

commit 99d54754d3d5f896a8f616b0b6520662bc99d66b upstream.

Look for fw-features properties to determine the appropriate settings
for the count cache flush, and then call the generic powerpc code to
set it up based on the security feature flags.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/powernv/setup.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -77,6 +77,12 @@ static void init_fw_feat_flags(struct de
 	if (fw_feature_is("enabled", "fw-count-cache-disabled", np))
 		security_ftr_set(SEC_FTR_COUNT_CACHE_DISABLED);
 
+	if (fw_feature_is("enabled", "fw-count-cache-flush-bcctr2,0,0", np))
+		security_ftr_set(SEC_FTR_BCCTR_FLUSH_ASSIST);
+
+	if (fw_feature_is("enabled", "needs-count-cache-flush-on-context-switch", np))
+		security_ftr_set(SEC_FTR_FLUSH_COUNT_CACHE);
+
 	/*
 	 * The features below are enabled by default, so we instead look to see
 	 * if firmware has *disabled* them, and clear them if so.
@@ -123,6 +129,7 @@ static void pnv_setup_rfi_flush(void)
 		  security_ftr_enabled(SEC_FTR_L1D_FLUSH_HV));
 
 	setup_rfi_flush(type, enable);
+	setup_count_cache_flush();
 }
 
 static void __init pnv_setup_arch(void)


