Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2709E1F0E4
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbfEOLXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731146AbfEOLXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:23:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7425F206BF;
        Wed, 15 May 2019 11:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919412;
        bh=PYIIpr7KD2zbGK2TlpSGFy1YdRRiZrztl0urGCeOIv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qiog7j0oBpXL0jheCEGXzyPfTFxHjlGvsbAov46tktgQ6nnkFl6v3IljgF9sXXmdV
         qr9sJYM4i3XUfR8Zs1gAeujkMUuZelgR2cbp0Ovd/6UzYZZ97ez80N5dgiiMxf7Bzg
         sBDPB7F6Sov5iv3539el7YtHoDkDFX5Zvh/jFzrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.19 065/113] powerpc/smp: Fix NMI IPI timeout
Date:   Wed, 15 May 2019 12:55:56 +0200
Message-Id: <20190515090658.482728040@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1b5fc84aba170bdfe3533396ca9662ceea1609b7 ]

The NMI IPI timeout logic is broken, if __smp_send_nmi_ipi() times out
on the first condition, delay_us will be zero which will send it into
the second spin loop with no timeout so it will spin forever.

Fixes: 5b73151fff63 ("powerpc: NMI IPI make NMI IPIs fully sychronous")
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 arch/powerpc/kernel/smp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 61c1fadbc6444..22abba5f4cf0e 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -499,7 +499,7 @@ int __smp_send_nmi_ipi(int cpu, void (*fn)(struct pt_regs *), u64 delay_us, bool
 		if (delay_us) {
 			delay_us--;
 			if (!delay_us)
-				break;
+				goto timeout;
 		}
 	}
 
@@ -510,10 +510,11 @@ int __smp_send_nmi_ipi(int cpu, void (*fn)(struct pt_regs *), u64 delay_us, bool
 		if (delay_us) {
 			delay_us--;
 			if (!delay_us)
-				break;
+				goto timeout;
 		}
 	}
 
+timeout:
 	if (!cpumask_empty(&nmi_ipi_pending_mask)) {
 		/* Timeout waiting for CPUs to call smp_handle_nmi_ipi */
 		ret = 0;
-- 
2.20.1



