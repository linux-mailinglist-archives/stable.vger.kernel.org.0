Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1360E1FEF8D
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 12:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgFRKUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 06:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727981AbgFRKUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 06:20:07 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2898C0613ED
        for <stable@vger.kernel.org>; Thu, 18 Jun 2020 03:20:06 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id r15so5052874wmh.5
        for <stable@vger.kernel.org>; Thu, 18 Jun 2020 03:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeblueprint-co-uk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=ZDzS22ABd2kr6Q9N+iZeVVpuX4ohPjiFNCxXA+YL224=;
        b=Ef5BGNQS6PKmHdhwWTN+Ge5JUtxlUBRtnxbp1aS7NYEdRQ72nR7VdsWHWRmnmPS1Q7
         ZQMPNBp4pq4CcSfc+7p4qO9opYot/KLOEvPmJE2ei7g+6Uj79BRpQjD2ieWUBfHGuoLn
         CUISNvWDP/m/5+ablwzXSJcAn+AdMWgvXqcKRhjV9WKeqnSj1ZcQh1SFMZ7eaDdAz7TV
         FwwUZQVaVtVfaMneQcjwd2D7td800FXkoC9SDQGicfp/KsnxuAwNv0w/LzMPPOlYCUMG
         gg4pbB7jIRFwi/iF+JN67ib3eV4Z+U/19Jxv/9XclDPvtwS1uf4BQ+LDSEyQUdc3G6Zj
         EdLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZDzS22ABd2kr6Q9N+iZeVVpuX4ohPjiFNCxXA+YL224=;
        b=EHz4S2AN+nQfipVMOIdy5ZSgpAGU9aK2VkENxJb25zFOU+NDQM5Sj4jOXxv81fa5Mz
         LbeGBP6S8cDliTEJ0F4F2dfogLWlE5sgleJJk/fSRCNanicKFMqpvwEriroVjJLB4c+O
         wM0VKWVd+BazQDAjsSK05Udg1dPXgDxfdCKpUFyRfwS2WdNBC9bjHMq836j+T+NgkwJY
         tTA2vxy/1pRQNdAwvP50BJZrYzZuj3E2qVIHab6QK6KySnhIPCiPmO5oWZ/2xbUxe80r
         bJPT0D7L8vZcacLF+Gm0g4k4wSzL3IyluF8jigxFklYDyWyJvScyzlceH/7+2S8RYnVW
         IHAQ==
X-Gm-Message-State: AOAM5304W/ZDHdB/84GbvS6iGCBa/PDr/fexvlopN4GbE5eXFRARcjBI
        q/31FHxxcGOEY38ZyTqiz7ctKw==
X-Google-Smtp-Source: ABdhPJwwTnfV7bRfhIc9q9uf5O+5ALgdu5SAYXBjZl/zv6XL3RbYHaDXVITG/X1DIgpnQtI8C7JS/g==
X-Received: by 2002:a05:600c:4146:: with SMTP id h6mr3373407wmm.170.1592475605123;
        Thu, 18 Jun 2020 03:20:05 -0700 (PDT)
Received: from localhost ([51.19.80.112])
        by smtp.gmail.com with ESMTPSA id x8sm3170591wrs.43.2020.06.18.03.20.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Jun 2020 03:20:04 -0700 (PDT)
From:   Matt Fleming <matt@codeblueprint.co.uk>
To:     Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Alexey Dobriyan <adobriyan@gmail.com>,
        linux-kernel@vger.kernel.org,
        Matt Fleming <matt@codeblueprint.co.uk>,
        "Grimm, Jon" <Jon.Grimm@amd.com>,
        "Kumar, Venkataramanan" <Venkataramanan.Kumar@amd.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH] x86/asm/64: Align start of __clear_user() loop to 16-bytes
Date:   Thu, 18 Jun 2020 11:20:02 +0100
Message-Id: <20200618102002.30034-1-matt@codeblueprint.co.uk>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

x86 CPUs can suffer severe performance drops if a tight loop, such as
the ones in __clear_user(), straddles a 16-byte instruction fetch
window, or worse, a 64-byte cacheline. This issues was discovered in the
SUSE kernel with the following commit,

  1153933703d9 ("x86/asm/64: Micro-optimize __clear_user() - Use immediate constants")

which increased the code object size from 10 bytes to 15 bytes and
caused the 8-byte copy loop in __clear_user() to be split across a
64-byte cacheline.

Aligning the start of the loop to 16-bytes makes this fit neatly inside
a single instruction fetch window again and restores the performance of
__clear_user() which is used heavily when reading from /dev/zero.

Here are some numbers from running libmicro's read_z* and pread_z*
microbenchmarks which read from /dev/zero:

  Zen 1 (Naples)

  libmicro-file
                                        5.7.0-rc6              5.7.0-rc6              5.7.0-rc6
                                                    revert-1153933703d9+               align16+
  Time mean95-pread_z100k       9.9195 (   0.00%)      5.9856 (  39.66%)      5.9938 (  39.58%)
  Time mean95-pread_z10k        1.1378 (   0.00%)      0.7450 (  34.52%)      0.7467 (  34.38%)
  Time mean95-pread_z1k         0.2623 (   0.00%)      0.2251 (  14.18%)      0.2252 (  14.15%)
  Time mean95-pread_zw100k      9.9974 (   0.00%)      6.0648 (  39.34%)      6.0756 (  39.23%)
  Time mean95-read_z100k        9.8940 (   0.00%)      5.9885 (  39.47%)      5.9994 (  39.36%)
  Time mean95-read_z10k         1.1394 (   0.00%)      0.7483 (  34.33%)      0.7482 (  34.33%)

Note that this doesn't affect Haswell or Broadwell microarchitectures
which seem to avoid the alignment issue by executing the loop straight
out of the Loop Stream Detector (verified using perf events).

Fixes: 1153933703d9 ("x86/asm/64: Micro-optimize __clear_user() - Use immediate constants")
Cc: "Grimm, Jon" <Jon.Grimm@amd.com>
Cc: "Kumar, Venkataramanan" <Venkataramanan.Kumar@amd.com>
CC: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org> # v4.19+
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/lib/usercopy_64.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index fff28c6f73a2..b0dfac3d3df7 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -24,6 +24,7 @@ unsigned long __clear_user(void __user *addr, unsigned long size)
 	asm volatile(
 		"	testq  %[size8],%[size8]\n"
 		"	jz     4f\n"
+		"	.align 16\n"
 		"0:	movq $0,(%[dst])\n"
 		"	addq   $8,%[dst]\n"
 		"	decl %%ecx ; jnz   0b\n"
-- 
2.17.1

