Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC9E1CB039
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgEHMg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:36:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbgEHMg1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:36:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9607021974;
        Fri,  8 May 2020 12:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941387;
        bh=4461rff/8b/jph4vSDZqmbqZ71AQJeIrJYUJcwal6GM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9qxWbxl+AMW3Ep5DwYbzeQPoVCiOOBNglpdZfO2H9H+H9L68vLLJ5pLiDqoaHXuj
         DyaeYdIH83r7UazFja34TW0yX6Z0qtof53wPeBhtAUTltBArLJWwO4DfesohgT/NH9
         ApIvFxEPFPgw2DWUDcGUx2sp8LNx+eqObiOVWdBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paul.burton@imgtec.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 4.4 012/312] MIPS: smp-cps: Stop printing EJTAG exceptions to UART
Date:   Fri,  8 May 2020 14:30:03 +0200
Message-Id: <20200508123125.369792501@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paul.burton@imgtec.com>

commit 6609ccdc852f7bfbfa54300dd5b3cd89eb4ced6f upstream.

When CONFIG_MIPS_CPS_NS16550 is enabled, some register state is dumped
to the UART when an exception is taken via the BEV on secondary cores.
EJTAG exceptions are architecturally expected to be handled by the BEV
even when Status.BEV is 0. This effectively means that if userland
executes an sdbbp instruction on a secondary core then the kernel dumps
register state to the UART even though the exception is perfectly normal
& expected. Prevent this by simply not dumping information to the UART
for EJTAG exceptions.

Fixes: 609cf6f2291a ("MIPS: CPS: Early debug using an ns16550-compatible UART")
Signed-off-by: Paul Burton <paul.burton@imgtec.com>
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Patchwork: https://patchwork.linux-mips.org/patch/12341/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/cps-vec.S |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/mips/kernel/cps-vec.S
+++ b/arch/mips/kernel/cps-vec.S
@@ -245,7 +245,6 @@ LEAF(excep_intex)
 
 .org 0x480
 LEAF(excep_ejtag)
-	DUMP_EXCEP("EJTAG")
 	PTR_LA	k0, ejtag_debug_handler
 	jr	k0
 	 nop


