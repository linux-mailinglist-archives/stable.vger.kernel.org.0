Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF524D3EF9
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 02:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238908AbiCJByp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 20:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235354AbiCJByo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 20:54:44 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB27128581;
        Wed,  9 Mar 2022 17:53:44 -0800 (PST)
Received: from integral2.. (unknown [114.10.7.234])
        by gnuweeb.org (Postfix) with ESMTPSA id 0374F7E2CC;
        Thu, 10 Mar 2022 01:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646877223;
        bh=VgvFD5PbNA6rugPitfY9YWmZEniNGGoHTmksEfV3s5g=;
        h=From:To:Cc:Subject:Date:From;
        b=Y2ogKybWOlxy7/UPV3zKqH5BrFkKd1xUhTr4NS0ZSaHHd7p/xDuMumAn/y5f5vA8z
         9J98xi8r+omMB/qCvmLVpaI3WVqvp/yMHgGenDInz0Hy8+njGonEZPJG8atDYTMqQE
         kHsSavRTvHIbMhBov1XzSILqM4qqgf7jN1DDSEzhUC+QLmfWWGsvZEDfLRruKiIaYt
         Ds0DAvdEwKfzv3Bo/9hmNUzadj/haNEkhU7Ylq0V5N+zrkN8FLwfWvP+nuWSUO5Ep/
         lZaSnPTtbIn410Ouay0Urj2F3PRA3r5/sE7WX4WrldZUNJ3iUV1Qjw4QihHaLfx8vk
         vGM/Zzt0FpgLQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, gwml@vger.gnuweeb.org, x86@kernel.org
Subject: [PATCH v5 0/2] Two x86 fixes
Date:   Thu, 10 Mar 2022 08:53:04 +0700
Message-Id: <20220310015306.445359-1-ammarfaizi2@gnuweeb.org>
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

Two x86 fixes in this series.

1) x86/delay: Fix the wrong Assembly constraint in delay_loop() function.
2) x86/MCE/AMD: Fix memory leak when `threshold_create_bank()` fails.

## Changelog

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


base-commit: 7e57714cd0ad2d5bb90e50b5096a0e671dec1ef3
-- 
Ammar Faizi

