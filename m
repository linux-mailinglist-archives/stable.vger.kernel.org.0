Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECAE4C84E3
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 08:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbiCAHZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 02:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiCAHZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 02:25:07 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0F16542B;
        Mon, 28 Feb 2022 23:24:25 -0800 (PST)
Received: from integral2.. (unknown [182.2.70.248])
        by gnuweeb.org (Postfix) with ESMTPSA id D746E7EC80;
        Tue,  1 Mar 2022 07:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646119464;
        bh=1DueruguqzudzU4GLjRyxswwEsV4p5hsQfPer9dQXT8=;
        h=From:To:Cc:Subject:Date:From;
        b=G5gwpQCdmlm5t/p/wxxAzp/RXTiXr1Y04KnGzgMFFhBW+7FaNJG04kAgnKqRlrpS/
         il6amVuOoRF2OQ+gAmgCfAtyLs6EwTPV7n6mTAa9ruwT4LeYy1DiS8fl1iY1f2JxTa
         VCMQyTFtF3hh3TQjprQyI34ykBVajgjz9BPwfwan7TiPPeBqzI8C7Au45iBtd0D9z9
         sV+iNxiEqlVn0WZ84I08nOjY4fBN6pZy64VHoGQ1EqNy9seM9DTAqU75XlAxF8p6gd
         tg04GfphsxQ1vqM/qTN0ydZjrEi7zthDCYmGpVYyYQtrfUUexHOwZ6kVUYcqo9vcgA
         jnC+Pn80t8SgQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, gwml@vger.gnuweeb.org,
        x86@kernel.org, stable@vger.kernel.org,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH 0/2] Two x86 fixes
Date:   Tue,  1 Mar 2022 14:23:51 +0700
Message-Id: <20220301072353.95749-1-ammarfaizi2@gnuweeb.org>
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

[PATCH 1/2] x86/delay: Fix the wrong asm constraint in `delay_loop()`

@bp is a local variable, calling mce_threshold_remove_device() when
threshold_create_bank() fails will not free the @bp. Note that
mce_threshold_remove_device() frees the @bp only if it's already
stored in the @threshold_banks per-CPU variable.

At that point, the @threshold_banks per-CPU variable is still NULL,
so the mce_threshold_remove_device() will just be a no-op and the
@bp is leaked.

Fix this by calling kfree() and early returning when we fail.

This bug is introduced by commit 6458de97fc15530b544 ("x86/mce/amd:
Straighten CPU hotplug path") [1].

Link: https://lore.kernel.org/all/20200403161943.1458-6-bp@alien8.de [1]

[PATCH 2/2] x86/mce/amd: Fix memory leak when `threshold_create_bank()` fails.

@bp is a local variable, calling mce_threshold_remove_device() when
threshold_create_bank() fails will not free the @bp. Note that
mce_threshold_remove_device() frees the @bp only if it's already
stored in the @threshold_banks per-CPU variable.

At that point, the @threshold_banks per-CPU variable is still NULL,
so the mce_threshold_remove_device() will just be a no-op and the
@bp is leaked.

Fix this by calling kfree() and early returning when we fail.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (2):
  x86/delay: Fix the wrong asm constraint in `delay_loop()`
  x86/mce/amd: Fix memory leak when `threshold_create_bank()` fails

 arch/x86/kernel/cpu/mce/amd.c | 9 ++++-----
 arch/x86/lib/delay.c          | 4 ++--
 2 files changed, 6 insertions(+), 7 deletions(-)


base-commit: 7e57714cd0ad2d5bb90e50b5096a0e671dec1ef3
-- 
2.32.0

