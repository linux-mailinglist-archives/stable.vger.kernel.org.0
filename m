Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95F24FD757
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354791AbiDLH5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359219AbiDLHmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC1155750;
        Tue, 12 Apr 2022 00:20:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6359B81B58;
        Tue, 12 Apr 2022 07:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FFAC385A1;
        Tue, 12 Apr 2022 07:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748030;
        bh=X/kxAdyy8ubxvC4P7+q/VVC5pIvWgQr+bpFFx6PiJI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wXLOo8VTtBvD1ya6JytozOb4tASwdEh3mEJjsEZYXvvL0fwY/oIpgao1tQ6L7mc0K
         ggQfE+74wN1aEWWmaOUK0PDcn46qtZpcba60Kl9K0EHwf7qLzuZWuZHEbpA5nzX/oR
         MmAS/bLXHwLnujYm8cS5WdTuDdvk5ecPDnlRkvGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian-Ken Rueegsegger <ken@codelabs.ch>,
        Reto Buerki <reet@codelabs.ch>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.17 295/343] x86/msi: Fix msi message data shadow struct
Date:   Tue, 12 Apr 2022 08:31:53 +0200
Message-Id: <20220412062959.841038610@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reto Buerki <reet@codelabs.ch>

commit 59b18a1e65b7a2134814106d0860010e10babe18 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/msi.h |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/msi.h
+++ b/arch/x86/include/asm/msi.h
@@ -12,14 +12,17 @@ int pci_msi_prepare(struct irq_domain *d
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
 


