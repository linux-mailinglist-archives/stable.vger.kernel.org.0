Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92D501F366
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbfEOLEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:04:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728465AbfEOLEj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:04:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB62620644;
        Wed, 15 May 2019 11:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918279;
        bh=ZHNIu92D+duYIu+4ZKulnTwetCt46wMcwo4U9uxghu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ktRMxApBAYJ9cdeUFWi2XReWU8j67cVxZ3eMxBdzdW7swYHMCgB4XLHUo/0/ww/Aj
         9D18QPHkZwoYW6hK7xNC7/zZWvSgj4O2K5PQLZ5krC6NpIiykfwptv+Sdz20+Go3XJ
         cirHwRYaHJIwMURa75jDZjXQpy/EqccIGO2H1nDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 032/266] powerpc/pseries: Fix clearing of security feature flags
Date:   Wed, 15 May 2019 12:52:19 +0200
Message-Id: <20190515090723.625034881@linuxfoundation.org>
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

From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>

commit 0f9bdfe3c77091e8704d2e510eb7c2c2c6cde524 upstream.

The H_CPU_BEHAV_* flags should be checked for in the 'behaviour' field
of 'struct h_cpu_char_result' -- 'character' is for H_CPU_CHAR_*
flags.

Found by playing around with QEMU's implementation of the hypercall:

  H_CPU_CHAR=0xf000000000000000
  H_CPU_BEHAV=0x0000000000000000

  This clears H_CPU_BEHAV_FAVOUR_SECURITY and H_CPU_BEHAV_L1D_FLUSH_PR
  so pseries_setup_rfi_flush() disables 'rfi_flush'; and it also
  clears H_CPU_CHAR_L1D_THREAD_PRIV flag. So there is no RFI flush
  mitigation at all for cpu_show_meltdown() to report; but currently
  it does:

  Original kernel:

    # cat /sys/devices/system/cpu/vulnerabilities/meltdown
    Mitigation: RFI Flush

  Patched kernel:

    # cat /sys/devices/system/cpu/vulnerabilities/meltdown
    Not affected

  H_CPU_CHAR=0x0000000000000000
  H_CPU_BEHAV=0xf000000000000000

  This sets H_CPU_BEHAV_BNDS_CHK_SPEC_BAR so cpu_show_spectre_v1() should
  report vulnerable; but currently it doesn't:

  Original kernel:

    # cat /sys/devices/system/cpu/vulnerabilities/spectre_v1
    Not affected

  Patched kernel:

    # cat /sys/devices/system/cpu/vulnerabilities/spectre_v1
    Vulnerable

Brown-paper-bag-by: Michael Ellerman <mpe@ellerman.id.au>
Fixes: f636c14790ea ("powerpc/pseries: Set or clear security feature flags")
Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -524,13 +524,13 @@ static void init_cpu_char_feature_flags(
 	 * The features below are enabled by default, so we instead look to see
 	 * if firmware has *disabled* them, and clear them if so.
 	 */
-	if (!(result->character & H_CPU_BEHAV_FAVOUR_SECURITY))
+	if (!(result->behaviour & H_CPU_BEHAV_FAVOUR_SECURITY))
 		security_ftr_clear(SEC_FTR_FAVOUR_SECURITY);
 
-	if (!(result->character & H_CPU_BEHAV_L1D_FLUSH_PR))
+	if (!(result->behaviour & H_CPU_BEHAV_L1D_FLUSH_PR))
 		security_ftr_clear(SEC_FTR_L1D_FLUSH_PR);
 
-	if (!(result->character & H_CPU_BEHAV_BNDS_CHK_SPEC_BAR))
+	if (!(result->behaviour & H_CPU_BEHAV_BNDS_CHK_SPEC_BAR))
 		security_ftr_clear(SEC_FTR_BNDS_CHK_SPEC_BAR);
 }
 


