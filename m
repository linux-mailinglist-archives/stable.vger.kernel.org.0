Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1086059ACE7
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 11:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344268AbiHTJZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 05:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234988AbiHTJZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 05:25:40 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA06D5F983;
        Sat, 20 Aug 2022 02:25:38 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C5923337A8;
        Sat, 20 Aug 2022 09:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660987536; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=kJU1ufk7XsI6BxvM7y8ee3l2GxtzRVD+Tg1mt0G7ZYc=;
        b=J+NnjJlsSZkjxe4+QRQfV1WFaeKpYiRY31Xsi/w8OiVSq6NjuIY7p8QpDu1g83mJSEjP7U
        /WkFYpr2jvyeLB11aZ9DKc94f+Ghl4j9SAWsS5iXxO6dtpRNXWvJR9jrx4LohFq/zijX8q
        F/nJvM90ehANBi/p58aDfOujwRwNRrs=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 627FB13440;
        Sat, 20 Aug 2022 09:25:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WEGEFpCoAGPJMAAAMHmgww
        (envelope-from <jgross@suse.com>); Sat, 20 Aug 2022 09:25:36 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v2 00/10] x86: make pat and mtrr independent from each other
Date:   Sat, 20 Aug 2022 11:25:23 +0200
Message-Id: <20220820092533.29420-1-jgross@suse.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Today PAT can't be used without MTRR being available, unless MTRR is at
least configured via CONFIG_MTRR and the system is running as Xen PV
guest. In this case PAT is automatically available via the hypervisor,
but the PAT MSR can't be modified by the kernel and MTRR is disabled.

The same applies to a kernel built with no MTRR support: it won't
allow to use the PAT MSR, even if there is no technical reason for
that, other than setting up PAT on all cpus the same way (which is a
requirement of the processor's cache management) is relying on some
MTRR specific code.

Fix all of that by:

- moving the function needed by PAT from MTRR specific code one level
  up
- reworking the init sequences of MTRR and PAT to be more similar to
  each other without calling PAT from MTRR code
- removing the dependency of PAT on MTRR

While working on that I discovered two minor bugs in MTRR code, which
are fixed, too.

Changes in V2:
- complete rework of the patches based on comments by Boris Petkov
- added several patches to the series

Juergen Gross (10):
  x86/mtrr: fix MTRR fixup on APs
  x86/mtrr: remove unused cyrix_set_all() function
  x86/mtrr: replace use_intel() with a local flag
  x86: move some code out of arch/x86/kernel/cpu/mtrr
  x86/mtrr: split generic_set_all()
  x86/mtrr: remove set_all callback from struct mtrr_ops
  x86/mtrr: simplify mtrr_bp_init()
  x86/mtrr: let cache_aps_delayed_init replace mtrr_aps_delayed_init
  x86/mtrr: add a stop_machine() handler calling only cache_cpu_init()
  x86: decouple pat and mtrr handling

 arch/x86/include/asm/cacheinfo.h   |  14 +++
 arch/x86/include/asm/memtype.h     |   5 +-
 arch/x86/include/asm/mtrr.h        |  12 +--
 arch/x86/kernel/cpu/cacheinfo.c    | 159 +++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/common.c       |   3 +-
 arch/x86/kernel/cpu/mtrr/cyrix.c   |  34 ------
 arch/x86/kernel/cpu/mtrr/generic.c | 120 ++++------------------
 arch/x86/kernel/cpu/mtrr/mtrr.c    | 158 +++++-----------------------
 arch/x86/kernel/cpu/mtrr/mtrr.h    |   5 -
 arch/x86/kernel/setup.c            |  14 +--
 arch/x86/kernel/smpboot.c          |   9 +-
 arch/x86/mm/pat/memtype.c          | 127 +++++++----------------
 arch/x86/power/cpu.c               |   3 +-
 13 files changed, 274 insertions(+), 389 deletions(-)

-- 
2.35.3

