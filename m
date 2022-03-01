Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B746A4C8871
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 10:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbiCAJrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 04:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiCAJrU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 04:47:20 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1258BF1E;
        Tue,  1 Mar 2022 01:46:39 -0800 (PST)
Received: from integral2.. (unknown [182.2.70.248])
        by gnuweeb.org (Postfix) with ESMTPSA id DCEF67E29A;
        Tue,  1 Mar 2022 09:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646127999;
        bh=EE5DP0GDqFtOfX+H7OLLGFhvfQJHlaG47oj4cg5rTtw=;
        h=From:To:Cc:Subject:Date:From;
        b=crDMRYNTpvi6VZm7lYQh4zWjwuOC5lq9P4uhv/XaP3PzJZZY3DEidTBrc6y0T29yj
         elNngVVSIUPxaNuijiVUMJ2bGCHdMbwNVoN4fVhVZt9BF6XuSf3k5ZTECNtl9eDrrM
         P/CXkLZbd9u8vGZ4AcKrE0bmYIVVgWj2FUchq9rKVqKGD0p05/XbtsTxEudCCLMIhw
         X2QPMwbet5u5U+Gi518/WrA8sNo5jOR2G224aXcmcNvkVTpZx6NYvAUoAg/R+rEu2B
         WlyP3C4/hbCyfK16kGEM/NRYN+/5kPdXfPF4gPC99yfKLdn4+HTXi4hh3zrUSm7ftW
         5aJrVH2730Pgg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, gwml@vger.gnuweeb.org,
        x86@kernel.org, stable@vger.kernel.org,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Jiri Hladky <hladky.jiri@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v4 0/2] Two x86 fixes
Date:   Tue,  1 Mar 2022 16:46:06 +0700
Message-Id: <20220301094608.118879-1-ammarfaizi2@gnuweeb.org>
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

Two fixes for x86 arch.

## Changelog

v4:
  - Address comment from Greg, sha1 commit Fixes only needs to be 12 chars.
  - Add the author of the fixed commit to the CC list.

v3:
  - Fold in changes from Alviro, the previous version is still
    leaking @bank[n].

v2:
  - Fix wrong copy/paste.

## Short Summary

Patch 1, fixes the wrong asm constraint in delay_loop function.

Fortunately, the constraint violation that's fixed by patch 1 doesn't
yield any bug due to the nature of System V ABI. Should we backport
this?

Patch 2, fixes memory leak in mce/amd code.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
Ammar Faizi (2):
  x86/delay: Fix the wrong asm constraint in `delay_loop()`
  x86/mce/amd: Fix memory leak when `threshold_create_bank()` fails

 arch/x86/kernel/cpu/mce/amd.c | 16 ++++++++++------
 arch/x86/lib/delay.c          |  4 ++--
 2 files changed, 12 insertions(+), 8 deletions(-)


base-commit: 7e57714cd0ad2d5bb90e50b5096a0e671dec1ef3
-- 
2.32.0

