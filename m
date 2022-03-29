Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93684EAB97
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 12:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234892AbiC2KtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 06:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234675AbiC2KtB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 06:49:01 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DB32487B8;
        Tue, 29 Mar 2022 03:47:19 -0700 (PDT)
Received: from integral2.. (unknown [182.2.70.161])
        by gnuweeb.org (Postfix) with ESMTPSA id 640277E723;
        Tue, 29 Mar 2022 10:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1648550838;
        bh=mgU2darmCFoLaZ5GAG6W8b9ruZ6543VExVSpSw3Vi1o=;
        h=From:To:Cc:Subject:Date:From;
        b=YuEPtaLIaHFLRGRdg0RjlpgjRyDSErHAC4+vwsGam7QMa8fKdTVk/ePxn4c5RPz5G
         ZZQ8cDhBqkAOzu8bH54ZZ33QM6spgIDztifayZ5t0Pxfb1TcrBXjQVe2QLtSfkP9a2
         aHgAod/qK74kdQ2wek5zteu6Yv59mG+RFoa1XNGO2rDSxOOCs2Qj2T4UbNVlSTVsMa
         jNRqkXD8h2dFDFRXxVTEpWkXL7Ut9k7sHdgz+o3qrkvgflfERn+vFB2hiZci9kWxK0
         /RJOlXLnNYbor6ch5eguP45FacOyrsnV4wHOSJPbBc3aUJfwvYn41c3xTE9/XHeY5N
         Jxw7+cG8PDBVw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable Kernel <stable@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        x86 Mailing List <x86@kernel.org>
Subject: [PATCH v6 0/2] Two x86 fixes
Date:   Tue, 29 Mar 2022 17:47:03 +0700
Message-Id: <20220329104705.65256-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

This is the v6 of two x86 fixes.

1) x86/delay: Fix the wrong Assembly constraint in delay_loop() function.
2) x86/MCE/AMD: Fix memory leak when `threshold_create_bank()` fails.

## Changelog

v6:
  - Remove unnecessary Cc tags.
  - Undo the stable mark for patch 1.
  - Update commit message, emphasize the danger when the compiler
    decides to inline the function.
  - Fix the Fixes tag sha1 in patch 1.
  - Change the helper function name to __threshold_remove_device().

v5:
  - Mark patch #1 for stable.
  - Commit message improvement for patch #1 and #2.
  - Fold in changes from Yazen and Alviro (for patch #2).

v4:
  - Address comment from Greg, sha1 commit Fixes only needs
    to be 12 chars.
  - Add the author of the fixed commit to the CC list.

v3:
  - Fold in changes from Alviro, the previous version is still
    leaking @bank[n].

v2:
  - Fix wrong copy/paste.

Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
Ammar Faizi (2):
  x86/delay: Fix the wrong asm constraint in `delay_loop()`
  x86/MCE/AMD: Fix memory leak when `threshold_create_bank()` fails

 arch/x86/kernel/cpu/mce/amd.c | 32 +++++++++++++++++++-------------
 arch/x86/lib/delay.c          |  4 ++--
 2 files changed, 21 insertions(+), 15 deletions(-)


base-commit: 1930a6e739c4b4a654a69164dbe39e554d228915
-- 
Ammar Faizi

