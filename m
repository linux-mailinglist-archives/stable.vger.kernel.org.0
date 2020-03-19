Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9739F18B529
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbgCSNQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:16:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729483AbgCSNQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:16:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E6ED21556;
        Thu, 19 Mar 2020 13:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623769;
        bh=BHl61XVaYiiLrL3vc3daOyenv1prkPnf9dqKV9w6+nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a1AC4md+KPb57nEWofEr6ozcOiKT9mlae3dyIgskrlUR1IOgReognaGolAVw6cPYM
         SJnodjuY8mOIOhJiITY1Qc3Do8LdFAlrBAxAMaIhsvXw9Yvj3M6yu0caHZYqtT2ESv
         Z/UKFWvlDZnCDVAfapyKcF10cZFcIdN1TAf/IHKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>,
        Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
Subject: [PATCH 4.14 48/99] ARC: define __ALIGN_STR and __ALIGN symbols for ARC
Date:   Thu, 19 Mar 2020 14:03:26 +0100
Message-Id: <20200319123956.481702270@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>

commit 8d92e992a785f35d23f845206cf8c6cafbc264e0 upstream.

The default defintions use fill pattern 0x90 for padding which for ARC
generates unintended "ldh_s r12,[r0,0x20]" corresponding to opcode 0x9090

So use ".align 4" which insert a "nop_s" instruction instead.

Cc: stable@vger.kernel.org
Acked-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/include/asm/linkage.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arc/include/asm/linkage.h
+++ b/arch/arc/include/asm/linkage.h
@@ -14,6 +14,8 @@
 #ifdef __ASSEMBLY__
 
 #define ASM_NL		 `	/* use '`' to mark new line in macro */
+#define __ALIGN		.align 4
+#define __ALIGN_STR	__stringify(__ALIGN)
 
 /* annotation for data we want in DCCM - if enabled in .config */
 .macro ARCFP_DATA nm


