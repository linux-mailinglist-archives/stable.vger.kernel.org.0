Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4995FFD65F
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfKOGVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:21:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:50346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727314AbfKOGVb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:21:31 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E1522073A;
        Fri, 15 Nov 2019 06:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798890;
        bh=C7dR1W8QurBtd1kqmPyg6aORotiBHvWUlW5+2Pa41rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YyHg3PaZKj17CYf1lIuYiKEGO/chpyUQrDn5eoDcSYK4EhnZ7RI4UoIE/x71WaALH
         2socNSfLSeTuxtV/pHc3acGK1dqjF+aVjomc64kWel3ISQrWnHKDYMOzZ9tQ1u8Jwl
         +2ONfXXSwQVbqF7YjHAirllgaqoH7WWx2tJ3Anr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tyler Hicks <tyhicks@canonical.com>,
        Borislav Petkov <bp@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 19/20] x86/speculation/taa: Fix printing of TAA_MSG_SMT on IBRS_ALL CPUs
Date:   Fri, 15 Nov 2019 14:20:48 +0800
Message-Id: <20191115062015.634529499@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062006.854443935@linuxfoundation.org>
References: <20191115062006.854443935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 012206a822a8b6ac09125bfaa210a95b9eb8f1c1 upstream.

For new IBRS_ALL CPUs, the Enhanced IBRS check at the beginning of
cpu_bugs_smt_update() causes the function to return early, unintentionally
skipping the MDS and TAA logic.

This is not a problem for MDS, because there appears to be no overlap
between IBRS_ALL and MDS-affected CPUs.  So the MDS mitigation would be
disabled and nothing would need to be done in this function anyway.

But for TAA, the TAA_MSG_SMT string will never get printed on Cascade
Lake and newer.

The check is superfluous anyway: when 'spectre_v2_enabled' is
SPECTRE_V2_IBRS_ENHANCED, 'spectre_v2_user' is always
SPECTRE_V2_USER_NONE, and so the 'spectre_v2_user' switch statement
handles it appropriately by doing nothing.  So just remove the check.

Fixes: 1b42f017415b ("x86/speculation/taa: Add mitigation for TSX Async Abort")
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -853,10 +853,6 @@ static void update_mds_branch_idle(void)
 
 void arch_smt_update(void)
 {
-	/* Enhanced IBRS implies STIBP. No update required. */
-	if (spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
-		return;
-
 	mutex_lock(&spec_ctrl_mutex);
 
 	switch (spectre_v2_user) {


