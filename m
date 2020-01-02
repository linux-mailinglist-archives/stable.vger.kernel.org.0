Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E207512F05E
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgABWWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:22:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:42404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729102AbgABWWN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:22:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 501D3227BF;
        Thu,  2 Jan 2020 22:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003732;
        bh=SMEJehBrbJjrA45F280FcI6aUeAE4KdjaoDeYzWp3+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YumHkAEo0smUq3IAGrV2tITj/44sV/lRKNnJaRCYG50mJ3QRYI1J/80fEhYQMLef1
         C5NL6E5r7OSPz4sM15HedZbz4hVlXK1S9Sd9SVYpnpesBXH0s7pNAPA0qb6PF3oe++
         iu5EEisWVcVOxLEtgjqN5BLW2M8wXi9b4kbjlkbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?Jan=20H . =20Sch=C3=B6nherr?=" <jschoenh@amazon.de>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        linux-edac <linux-edac@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        Yazen Ghannam <Yazen.Ghannam@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 074/114] x86/mce: Fix possibly incorrect severity calculation on AMD
Date:   Thu,  2 Jan 2020 23:07:26 +0100
Message-Id: <20200102220036.554952288@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan H. Schönherr <jschoenh@amazon.de>

[ Upstream commit a3a57ddad061acc90bef39635caf2b2330ce8f21 ]

The function mce_severity_amd_smca() requires m->bank to be initialized
for correct operation. Fix the one case, where mce_severity() is called
without doing so.

Fixes: 6bda529ec42e ("x86/mce: Grade uncorrected errors for SMCA-enabled systems")
Fixes: d28af26faa0b ("x86/MCE: Initialize mce.bank in the case of a fatal error in mce_no_way_out()")
Signed-off-by: Jan H. Schönherr <jschoenh@amazon.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: linux-edac <linux-edac@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Cc: Yazen Ghannam <Yazen.Ghannam@amd.com>
Link: https://lkml.kernel.org/r/20191210000733.17979-4-jschoenh@amazon.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 87ed8462a5c7..1f69b12d5bb8 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -812,8 +812,8 @@ static int mce_no_way_out(struct mce *m, char **msg, unsigned long *validp,
 		if (quirk_no_way_out)
 			quirk_no_way_out(i, m, regs);
 
+		m->bank = i;
 		if (mce_severity(m, mca_cfg.tolerant, &tmp, true) >= MCE_PANIC_SEVERITY) {
-			m->bank = i;
 			mce_read_aux(m, i);
 			*msg = tmp;
 			return 1;
-- 
2.20.1



