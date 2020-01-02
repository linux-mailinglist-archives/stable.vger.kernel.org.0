Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46D0012F024
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbgABWZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:25:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729312AbgABWZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:25:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D56120866;
        Thu,  2 Jan 2020 22:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003939;
        bh=yrMs1fk27v99sck8Q6Sw/5+jY1KWyCt2QXImWW8azOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UqA6s4u0vK/duDjCZVX+AsX6hAgSl+MO+M9bJQaPIP3RJY8y4v1cH+3znw0YfSgy+
         nwQgsnnxK7+XEqpurLB+lB+f/iQUz3pnSF+4gjNKh+rI0zJYi5U64XGFoC0ef6k1RY
         TMq2bBWWZ+QICeSmExi6SEWRTX254YaM+2183HAE=
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
Subject: [PATCH 4.14 55/91] x86/mce: Fix possibly incorrect severity calculation on AMD
Date:   Thu,  2 Jan 2020 23:07:37 +0100
Message-Id: <20200102220438.760274136@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
References: <20200102220356.856162165@linuxfoundation.org>
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
index c7bd2e549a6a..0b0e44f85393 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -802,8 +802,8 @@ static int mce_no_way_out(struct mce *m, char **msg, unsigned long *validp,
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



