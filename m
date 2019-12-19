Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE529126B6B
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730488AbfLSS4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:56:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:52958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730809AbfLSS4Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:56:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47575206EC;
        Thu, 19 Dec 2019 18:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781783;
        bh=jk0VuUMvYHyoH4GIwFD9bkaY87rYKm6vgjLVmpGwtis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=er5lXTOcIaL4Dwh3TAVqLwNPLN5dzdW0WLuTSnIZ9+b4Oc6H6n0YdmB/fgwcRpIWC
         B/QNLvRY0nWUvykPJeFVQc2BPr0ZaaniP6XdDJp7roQo2UYw0NerwbOpJRUQ8dl/sF
         TkUx6wQDvhMvWG9xXK9lFrguaQ175bDMd0vX4MtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.4 40/80] ARM: tegra: Fix FLOW_CTLR_HALT register clobbering by tegra_resume()
Date:   Thu, 19 Dec 2019 19:34:32 +0100
Message-Id: <20191219183108.704774605@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit d70f7d31a9e2088e8a507194354d41ea10062994 upstream.

There is an unfortunate typo in the code that results in writing to
FLOW_CTLR_HALT instead of FLOW_CTLR_CSR.

Cc: <stable@vger.kernel.org>
Acked-by: Peter De Schrijver <pdeschrijver@nvidia.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-tegra/reset-handler.S |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/mach-tegra/reset-handler.S
+++ b/arch/arm/mach-tegra/reset-handler.S
@@ -44,16 +44,16 @@ ENTRY(tegra_resume)
 	cmp	r6, #TEGRA20
 	beq	1f				@ Yes
 	/* Clear the flow controller flags for this CPU. */
-	cpu_to_csr_reg r1, r0
+	cpu_to_csr_reg r3, r0
 	mov32	r2, TEGRA_FLOW_CTRL_BASE
-	ldr	r1, [r2, r1]
+	ldr	r1, [r2, r3]
 	/* Clear event & intr flag */
 	orr	r1, r1, \
 		#FLOW_CTRL_CSR_INTR_FLAG | FLOW_CTRL_CSR_EVENT_FLAG
 	movw	r0, #0x3FFD	@ enable, cluster_switch, immed, bitmaps
 				@ & ext flags for CPU power mgnt
 	bic	r1, r1, r0
-	str	r1, [r2]
+	str	r1, [r2, r3]
 1:
 
 	mov32	r9, 0xc09


