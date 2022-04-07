Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8BA4F8075
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 15:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237910AbiDGN03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 09:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242932AbiDGN02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 09:26:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36AE7E0AD;
        Thu,  7 Apr 2022 06:24:26 -0700 (PDT)
Date:   Thu, 07 Apr 2022 13:24:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649337864;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1gZ4m2zNzDyVcoPXjOKdtQUGnrDRHFfhbm516qp77oQ=;
        b=3Q0XR3s+3mjWH+hP3ZbXv7r7BKi6PkFiPhgUWN9qPZOT3egzzVOJzHWuQLbVeS/kggWKeo
        kEoUDKdX/tsOPzkFmHALBVUaBfHNlJO3MgAtJsXGuEzSshsOfFKaW1YGE8f/0Tw/Dq4TAh
        7F9SMnfq8j++MTgWi5/odSqPkr0Pk0ayCJMzlIzb5Pl8E7lQuvorw18iym/deTTNxD9ADQ
        uU3O9B+3z2Q3vFFgsvCA1xZHLHznHsNq0veblNl1BZRhflndTgPWlyoNquM9GpcuTFY5Nm
        pwrDE0O6CEJk4czSGmF8LVprcWQJAWGlhpEuWTOo21gVlao7cJ97BW8Q6dfl7Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649337864;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1gZ4m2zNzDyVcoPXjOKdtQUGnrDRHFfhbm516qp77oQ=;
        b=hubg/0plHzphf01UH/D3BKoOoGNGAT3LC+Pdo4FJ/rXCLSUpeGBy7dv9CyAYOd/qVFd+/t
        XtD/TBGQv71jVsAw==
From:   "tip-bot2 for Reto Buerki" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/msi: Fix msi message data shadow struct
Cc:     "Adrian-Ken Rueegsegger" <ken@codelabs.ch>,
        Reto Buerki <reet@codelabs.ch>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220407110647.67372-1-reet@codelabs.ch>
References: <20220407110647.67372-1-reet@codelabs.ch>
MIME-Version: 1.0
Message-ID: <164933786279.389.13684586731676061391.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     59b18a1e65b7a2134814106d0860010e10babe18
Gitweb:        https://git.kernel.org/tip/59b18a1e65b7a2134814106d0860010e10babe18
Author:        Reto Buerki <reet@codelabs.ch>
AuthorDate:    Thu, 07 Apr 2022 13:06:47 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 07 Apr 2022 15:19:32 +02:00

x86/msi: Fix msi message data shadow struct

The x86 MSI message data is 32 bits in total and is either in
compatibility or remappable format, see Intel Virtualization Technology
for Directed I/O, section 5.1.2.

Fixes: 6285aa50736 ("x86/msi: Provide msi message shadow structs")
Co-developed-by: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Signed-off-by: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Signed-off-by: Reto Buerki <reet@codelabs.ch>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220407110647.67372-1-reet@codelabs.ch
---
 arch/x86/include/asm/msi.h | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/msi.h b/arch/x86/include/asm/msi.h
index b85147d..d71c7e8 100644
--- a/arch/x86/include/asm/msi.h
+++ b/arch/x86/include/asm/msi.h
@@ -12,14 +12,17 @@ int pci_msi_prepare(struct irq_domain *domain, struct device *dev, int nvec,
 /* Structs and defines for the X86 specific MSI message format */
 
 typedef struct x86_msi_data {
-	u32	vector			:  8,
-		delivery_mode		:  3,
-		dest_mode_logical	:  1,
-		reserved		:  2,
-		active_low		:  1,
-		is_level		:  1;
-
-	u32	dmar_subhandle;
+	union {
+		struct {
+			u32	vector			:  8,
+				delivery_mode		:  3,
+				dest_mode_logical	:  1,
+				reserved		:  2,
+				active_low		:  1,
+				is_level		:  1;
+		};
+		u32	dmar_subhandle;
+	};
 } __attribute__ ((packed)) arch_msi_msg_data_t;
 #define arch_msi_msg_data	x86_msi_data
 
